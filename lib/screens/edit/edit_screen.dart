import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/image_picker_widget.dart';
import 'package:moapp_toto/screens/add/widgets/text_form_filed_widget.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _AddPageState();
}

class _AddPageState extends State<EditPage> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: const Text("투투 수정하기"),
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
                      // const ImagePickerWidget(),
                      CustomTextFormField(
                        hintText: "작성된 기존 투투 내용",
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
                text: "수정하기",
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
