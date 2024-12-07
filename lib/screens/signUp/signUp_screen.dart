import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/widgets/custom_full_button.dart';
import 'package:moapp_toto/widgets/dicebear_avatar.dart';
import 'package:moapp_toto/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../add/widgets/animated_btn_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for the text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  bool isTermsAccepted = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    emailController.dispose();
    nicknameController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider up = Provider.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (emailController.text.isEmpty) {
      emailController.text = up.currentUser?.email ?? "";
    }
    if (nicknameController.text.isEmpty) {
      nicknameController.text = up.currentUser?.displayName ?? "";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DiceBearAvatar(
              seed: emailController.text,
              radius: 60,
            ),
            const SizedBox(height: 32),
            // 이메일
            MyTextField(
              label: '이메일',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            // 닉네임
            MyTextField(
              label: '닉네임',
              controller: nicknameController,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: isTermsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      isTermsAccepted = value ?? false;
                    });
                  },
                ),
                const Text(
                  '약관을 확인했습니다',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomAnimatedButton(
              key: const ValueKey(2),
              text: "시작하기",
              onPressed: () async {
                final Avatar avatar = DiceBearBuilder(
                  sprite: DiceBearSprite.botttsNeutral,
                  seed: emailController.text,
                ).build();

                final svgUrl = avatar.svgUri.toString();

                print("Email: ${emailController.text}");
                print("Nickname: ${nicknameController.text}");
                print("Gender: ${genderController.text}");
                print("Age: ${ageController.text}");
                print("Terms Accepted: $isTermsAccepted");
                print("SVG URL: $svgUrl");

                UserEntry ue = UserEntry(
                  uid: up.currentUser?.uid ?? "error",
                  gender: genderController.text,
                  email: emailController.text,
                  nickname: nicknameController.text,
                  birthyear: int.tryParse(ageController.text),
                  profileImageUrl: svgUrl,
                );

                final userDocRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(up.currentUser?.uid);
                await userDocRef.set(ue.toMap());

                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const MyTextField({
    required this.label,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
