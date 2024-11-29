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
      _selectedLocation = position;
    });
  }

  void _moveToCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 16),
      );

      setState(() {
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

  Future<void> _selectLocationFromPrediction(String placeId) async {
    js.context.callMethod('getPlaceDetails', [
      placeId,
      (dynamic place) {
        if (place != null && place['geometry'] != null) {
          final location = place['geometry']['location'];
          final newLocation = LatLng(location['lat'], location['lng']);
          setState(() {
            _selectedLocation = newLocation;
            _predictions = []; // Clear predictions
          });

          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(newLocation, 16),
            );
          }
        }
      }
    ]);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _predictions = []; // Clear predictions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("위치 선택"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, _selectedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('위치를 선택해주세요.')),
                );
              }
            },
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
