import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as user_location;

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedPlaceName;
  LatLng? _currentLocation;
  final user_location.Location _locationService = user_location.Location();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _predictions = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final locationData = await _locationService.getLocation();
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      // Only attempt to move the camera after the map controller is initialized
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation!, 16),
        );
        _plotPinAtCurrentLocation();
      }
    } catch (e) {
      print('Failed to get current location: $e');
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPlaceName = null;
      _selectedLocation = position;
    });
  }

  void _moveToCurrentLocation() async {
    await _fetchCurrentLocation();
    if (_currentLocation != null && _mapController != null) {
      // Only animate the camera if the map controller is available
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );

      setState(() {
        _selectedPlaceName = null;
        _selectedLocation = _currentLocation;
      });
    }
  }

  void _plotPinAtCurrentLocation() {
    if (_currentLocation != null) {
      setState(() {
        _selectedLocation = _currentLocation;
      });
    }
  }

  // Modified function to search places
  Future<void> _searchPlaces(String query) async {
    if (query.isNotEmpty) {
      js.context.callMethod('getAutocompletePredictions', [
        query,
        (List<dynamic> predictions) {
          setState(() {
            _predictions = predictions
                .map((p) => {
                      'description': p['description'],
                      'place_id': p['place_id'],
                    })
                .toList();
          });
        }
      ]);
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  // Modified function to select location from prediction
  Future<void> _selectLocationFromPrediction(String placeId) async {
    js.context.callMethod('getPlaceDetails', [
      placeId,
      (dynamic place) {
        if (place != null && place['geometry'] != null) {
          final location = place['geometry']['location'];

          // Ensure that lat and lng are accessed as numeric values
          final double lat = (location['lat'] is js.JsFunction)
              ? (location['lat'] as js.JsFunction).apply([]) as double
              : (location['lat'] as num).toDouble();
          final double lng = (location['lng'] is js.JsFunction)
              ? (location['lng'] as js.JsFunction).apply([]) as double
              : (location['lng'] as num).toDouble();

          final newLocation = LatLng(lat, lng);

          _searchController.text = place['name'];
          setState(() {
            _selectedLocation = newLocation;
            _currentLocation = newLocation;

            _selectedPlaceName = place['name']; // Store place name
            _predictions = []; // Clear predictions
          });

          // if (_mapController != null) {
          //   // Only animate the camera after the map is fully initialized
          //   _mapController!.animateCamera(
          //     CameraUpdate.newLatLngZoom(newLocation, 16),
          //   );
          // }
        }
      }
    ]);
  }

  // Function to clear the search input and predictions
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _predictions = []; // Clear predictions
    });
  }

  // Save the selected location and return the place name and coordinates
  void _saveLocation() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    if (_selectedPlaceName == null || _selectedPlaceName!.isEmpty) {
      // Show a dialog to ask for the place name
      final TextEditingController placeNameController = TextEditingController();
      _selectedPlaceName = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('장소 이름을 추가해보세요!'),
            content: TextField(
              controller: placeNameController,
              decoration: const InputDecoration(
                hintText: 'ex) 양덕 카페',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close without saving
                },
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(placeNameController.text);
                },
                child: const Text('추가'),
              ),
            ],
          );
        },
      );
    }

    if (_selectedPlaceName != null && _selectedPlaceName!.isNotEmpty) {
      final result = LocationResult(
          coordinates: _selectedLocation!, placeName: _selectedPlaceName!);

      // Show the result in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved location: ${result.placeName}')),
      );

      Navigator.pop(
          context, result); // Return the result (place name and coordinates)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place name is required')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("위치 선택"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _moveToCurrentLocation,
                  tooltip: 'My Location',
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchPlaces,
                    decoration: InputDecoration(
                      hintText: "Search location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_predictions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(prediction['description'] ?? ""),
                    onTap: () {
                      _selectLocationFromPrediction(prediction['place_id']);
                    },
                  );
                },
              ),
            )
          else
            Expanded(
              child: _currentLocation != null
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation!,
                        zoom: 16,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _selectedLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('selected-location'),
                                position: _selectedLocation!,
                                infoWindow: InfoWindow(
                                  title:
                                      _selectedPlaceName ?? "Selected Location",
                                ),
                              ),
                            }
                          : {},
                      onTap: _onMapTap,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class LocationResult {
  String placeName;
  LatLng coordinates;

  LocationResult({required this.placeName, required this.coordinates});
}
