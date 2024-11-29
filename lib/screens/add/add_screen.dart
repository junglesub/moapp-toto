import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/screens/add/widgets/text_form_filed_widget.dart';
import 'package:moapp_toto/screens/add/widgets/image_picker_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController textController = TextEditingController();
  bool isAnalysisPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 투투'),
        actions: isAnalysisPage
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    // 저장 버튼 클릭 시 동작 추가
                  },
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: isAnalysisPage ? _buildAnalysisPage() : _buildWritingPage(),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: isAnalysisPage
                    ? null
                    : CustomAnimatedButton(
                        key: const ValueKey(2),
                        text: "투두 등록하기",
                        onPressed: () {
                          setState(() {
                            isAnalysisPage = true;
                          });
                        },
                      ),
              ),
            ),
          ),
          if (isAnalysisPage) _buildPersistentBottomSheet(context),
        ],
      ),
    );
  }

  Widget _buildWritingPage() {
    return Padding(
      key: const ValueKey(1),
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
    );
  }

  Widget _buildAnalysisPage() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.only(top: 50),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "AI가 판단한 오늘의 리액션",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          '투투를 기반으로 기분을 분석 중입니다.',
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      pause: const Duration(milliseconds: 500),
                      displayFullTextOnTap: false,
                      stopPauseOnTap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0,
      maxChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: const [
              ListTile(
                leading: Icon(Icons.mood),
                title: Text('기분'),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('위치 추가'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('사람 태그'),
              ),
            ],
          ),
        );
      },
    );
  }
}
