import 'package:flutter/material.dart';
import 'package:moapp_toto/widgets/custom_full_button.dart';
import 'package:moapp_toto/widgets/my_text_field.dart';

import '../add/widgets/animated_btn_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            MyTextField(label: '이메일'),
            const SizedBox(height: 16),
            // 닉네임
            MyTextField(label: '닉네임'),
            const SizedBox(height: 16),
            // 성별 및 나이
            Row(
              children: [
                Expanded(child: MyTextField(label: '성별')),
                const SizedBox(width: 16),
                Expanded(child: MyTextField(label: '나이')),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? value) {
                    // TODO: 약관 추가
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
