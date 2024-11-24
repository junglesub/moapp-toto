import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class CustomAnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomAnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle submitTextStyle = TextStyle(
      fontSize: 15,
      color: Colors.white,
    );

    return AnimatedButton(
      height: 50,
      width: 330,
      text: text,
      isReverse: true,
      selectedTextColor: Colors.black,
      transitionType: TransitionType.LEFT_BOTTOM_ROUNDER,
      textStyle: submitTextStyle,
      backgroundColor: Colors.black,
      borderColor: Colors.black,
      borderRadius: 30,
      borderWidth: 2,
      onPress: onPressed,
    );
  }
}
