import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/widgets/custom_full_button.dart';
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
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      size: 32, color: Colors.black),
                  onPressed: () {
                    // TODO: Photo Button
                  },
                ),
              ],
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
            const SizedBox(height: 16),
            // 성별 및 나이
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    label: '성별',
                    controller: genderController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: MyTextField(
                    label: '나이',
                    controller: ageController,
                  ),
                ),
              ],
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
                // Print all text field values
                print("Email: ${emailController.text}");
                print("Nickname: ${nicknameController.text}");
                print("Gender: ${genderController.text}");
                print("Age: ${ageController.text}");
                print("Terms Accepted: $isTermsAccepted");

                UserEntry ue = UserEntry(
                  uid: up.currentUser?.uid ?? "error",
                  gender: genderController.text,
                  email: emailController.text,
                  nickname: nicknameController.text,
                  birthyear: int.tryParse(ageController.text),
                );

                final userDocRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(up.currentUser?.uid);
                await userDocRef.set(ue.toMap());

                // Simulate a delay and navigate
                // await Future.delayed(const Duration(milliseconds: 500));
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
