import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/screens/add/widgets/text_form_filed_widget.dart';
import 'package:moapp_toto/screens/add/widgets/image_picker_widget.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 투투'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: Column(
                    children: [
                      const ImagePickerWidget(),
                      CustomTextFormField(
                        hintText: "오늘은 어떤 날인가요?",
                        controller: textController,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CustomAnimatedButton(
                text: "오늘 하루 기분 분석하기",
                onPressed: () {
                  // 다음 버튼 클릭 시 페이지 UI 변경
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
