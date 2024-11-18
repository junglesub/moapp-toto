import 'package:flutter/material.dart';
import 'package:moapp_toto/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Button Example')),
        body: Center(
          child: CustomButton(
            label: 'Click Me',
            onPressed: () {
              print('Button Pressed');
            },
          ),
        ),
      ),
    );
  }
}
