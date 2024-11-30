import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moapp_toto/screens/friend/widgets/find_friend.dart';

class RecommandFriendRow extends StatefulWidget {
  final List<Person> friends; // Friends list as a parameter
  const RecommandFriendRow({Key? key, required this.friends}) : super(key: key);

  @override
  State<RecommandFriendRow> createState() => _RecommandFriendRowState();
}

class _RecommandFriendRowState extends State<RecommandFriendRow> {
  int _current = 0; // Current index for the indicator
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.friends.map((friend) {
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200, // Adjust height as needed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, size: 48),
                        const SizedBox(height: 8),
                        Text(friend.name),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: 200.0, // Adjust height as needed
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            viewportFraction: 0.4, // Show multiple items
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.friends.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
