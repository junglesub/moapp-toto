import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/add/location_select_screen.dart';
import 'package:moapp_toto/screens/add/widgets/animated_btn_widget.dart';
import 'package:moapp_toto/screens/add/widgets/text_form_filed_widget.dart';
import 'package:moapp_toto/screens/add/widgets/image_picker_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:moapp_toto/utils/emotions.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController textController = TextEditingController();
  bool isAnalysisPage = false;
  bool isEditMode = false;
  MoodOption? selectedMood;
  LocationResult? selectedLocation;
  ToToEntity? currentToto;

  dynamic _selectedImage;
  void _pickImage(dynamic image) async {
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  bool _isStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isStarted) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      UserProvider up = Provider.of(context, listen: false);
      currentToto =
          args?['toto'] ?? ToToEntity.empty(creator: up.currentUser?.uid ?? "");

      textController =
          TextEditingController(text: currentToto?.description ?? "");

      if (args?['toto'] != null) {
        isAnalysisPage = true;
        isEditMode = true;
      }
      _isStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch();
    TotoProvider tp = context.watch();

    ToToEntity? toto = tp.findId(currentToto?.id ?? "unknown ID");

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 투투'),
        actions: isAnalysisPage
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    // 저장 버튼 클릭 시 동작 추가
                    if (toto == null) {
                      print("Save ToTo is null. Something wrong!");
                      return;
                    }
                    ToToEntity t = ToToEntity(
                      id: toto.id,
                      name: toto.name,
                      description:
                          isEditMode ? textController.text : toto.description,
                      creator: toto.creator,
                      liked: toto.liked,
                      created: toto.created,
                      modified: toto.modified,
                      imageUrl: toto.imageUrl,
                      location: selectedLocation,
                      emotion: selectedMood ?? toto.emotion,
                    );
                    await t.save();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    }
                  },
                ),
              ]
            : null,
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: isAnalysisPage
                ? _buildAnalysisPage(context)
                : _buildWritingPage(),
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
                        onPressed: () async {
                          ToToEntity? newT;
                          ToToEntity toto = ToToEntity.empty(
                              creator: up.currentUser?.uid ?? "");
                          if (_selectedImage == null) {
                            newT = ToToEntity(
                                // id: product.id,
                                name: "",
                                description: textController.text,
                                creator: toto.creator,
                                created: toto.created,
                                modified: toto.modified,
                                imageUrl: toto.imageUrl,
                                liked: toto.liked);
                            await newT.save();
                          } else {
                            newT = await ToToEntity.createWithImageFile(
                                id: toto.id,
                                name: "",
                                description: textController.text,
                                creator: toto.creator,
                                created: toto.created,
                                modified: toto.modified,
                                imageFile: _selectedImage!,
                                liked: toto.liked);
                          }
                          setState(() {
                            isAnalysisPage = true;
                            currentToto = newT;
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
                ImagePickerWidget(parentPickImage: _pickImage),
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

  Widget _buildAnalysisPage(BuildContext context) {
    TotoProvider tp = context.watch<TotoProvider>();
    ToToEntity? toto = tp.findId(currentToto?.id ?? "unknown ID");
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.only(top: 16),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (toto?.emotion != null || selectedMood != null)
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  selectedMood?.emoji ??
                                      toto?.emotion?.emoji ??
                                      "",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    selectedMood?.name ??
                                        toto?.emotion?.name ??
                                        "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle text overflow
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectedLocation != null)
                      Flexible(
                        child: Container(
                          child: Chip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    selectedLocation?.placeName ?? "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle text overflow
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(toto?.id ?? "Unknown ID"),
                if (!isEditMode)
                  Column(
                    children: [
                      Text(
                        "AI가 판단한 오늘의 리액션",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                            key: ValueKey(toto?.aiReaction),
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                toto?.aiReaction ?? '투투를 기반으로 기분을 분석 중입니다.',
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
                if (isEditMode)
                  Column(
                    children: [
                      CustomTextFormField(
                        hintText: "오늘은 어떤 날인가요?",
                        controller: textController,
                        maxLines: 4,
                      ),
                    ],
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
            children: [
              ListTile(
                leading: const Icon(Icons.mood),
                title: const Text('기분'),
                onTap: () async {
                  MoodOption? mood = await _navigateToMoodPage(context);
                  if (mood != null) {
                    print("선택된 기분: ${mood.name}");
                    setState(() {
                      selectedMood = mood;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('위치 추가'),
                onTap: () async {
                  LocationResult? locationResult =
                      await _navigateToLocationPage(context);
                  if (locationResult != null) {
                    // print("선택된 기분: ${mood.name}");
                    setState(() {
                      selectedLocation = locationResult;
                    });
                  }
                },
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text('사람 태그'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<MoodOption?> _navigateToMoodPage(BuildContext context) async {
    return Navigator.push<MoodOption>(
      context,
      MaterialPageRoute(
        builder: (context) => MoodSelectionPage(),
      ),
    );
  }

  Future<LocationResult?> _navigateToLocationPage(BuildContext context) async {
    return Navigator.push<LocationResult>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationSelectionPage(),
      ),
    );
  }
}

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MoodOption> moodOptions = MoodOption.moodOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("기분 선택"),
      ),
      body: ListView.builder(
        itemCount: moodOptions.length,
        itemBuilder: (context, index) {
          final mood = moodOptions[index];
          return ListTile(
            leading: Text(mood.emoji, style: TextStyle(fontSize: 30)),
            title: Text(mood.name),
            onTap: () {
              // 선택된 기분 이름을 반환
              Navigator.pop(context, mood);
            },
          );
        },
      ),
    );
  }
}
