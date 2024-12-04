import 'dart:typed_data';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/all_users_provider.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/screens/profile/widgets/toto_card_widget.dart';
import 'package:moapp_toto/utils/date_format.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  int _selectedIndex = 4;

  bool _taggedPosts = false;
  bool _likedPosts = false;
  Uint8List? _selectedImageBytes;
  bool _isImageChanged = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 140 && !_showAppBarTitle) {
        setState(() {
          _showAppBarTitle = true;
        });
      } else if (_scrollController.offset <= 100 && _showAppBarTitle) {
        setState(() {
          _showAppBarTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child:
                            const Icon(Icons.local_offer, color: Colors.black),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '태그된 게시물',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '회원님이 태그된 게시물만 표시합니다.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Switch(
                        value: _taggedPosts,
                        onChanged: (bool value) {
                          setModalState(() {
                            _taggedPosts = value;
                          });
                          setState(() {});
                        },
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.favorite, color: Colors.black),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '좋아요 누른 게시물',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '회원님이 좋아요를 누른 게시물만 표시합니다.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Switch(
                        value: _likedPosts,
                        onChanged: (bool value) {
                          setModalState(() {
                            _likedPosts = value;
                          });
                          setState(() {});
                        },
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch();
    TotoProvider tp = context.watch();
    AllUsersProvider aup = context.watch();
    return Scaffold(
      appBar: AppBar(
        title: _showAppBarTitle
            ? Center(
                child: Text(up.ue?.nickname ?? up.ue?.uid ?? "Unknown User"))
            : null,
        actions: [
          IconButton(
            icon: Icon(
              AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              if (AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark) {
                AdaptiveTheme.of(context).setLight();
              } else {
                AdaptiveTheme.of(context).setDark();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigator.pushNamed(context, '/landing');
              _auth.signOut();
            },
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                color: const Color(0xFF363536),
              ),
              Positioned(
                bottom: -60,
                left: MediaQuery.of(context).size.width / 2 - 70,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: _selectedImageBytes != null
                            ? Image.memory(
                                _selectedImageBytes!,
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              )
                            : (up.ue?.profileImageUrl != null &&
                                    up.ue!.profileImageUrl!.isNotEmpty
                                ? up.ue!.profileImageUrl!.contains('/svg')
                                    ? SizedBox(
                                        width: 140,
                                        height: 140,
                                        child: SvgPicture.network(
                                          up.ue!.profileImageUrl!,
                                          placeholderBuilder: (context) =>
                                              const CircularProgressIndicator(),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 70,
                                        backgroundImage: NetworkImage(
                                            up.ue!.profileImageUrl!),
                                      )
                                : Container(
                                    width: 140,
                                    height: 140,
                                    color: Colors.blue,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  up.ue?.nickname ?? up.ue?.uid ?? "Unknown User",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  // color: Colors.black,
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    final Uint8List imageBytes = await pickedFile.readAsBytes();
                    setState(() {
                      _selectedImageBytes = imageBytes;
                      _isImageChanged = true;
                    });
                    print("Image selected from gallery.");
                  }
                },
              ),
              if (_isImageChanged)
                IconButton(
                  icon: const Icon(
                    Icons.save,
                    // color: Colors.black,
                  ),
                  onPressed: () async {
                    if (_selectedImageBytes != null) {
                      try {
                        await up.ue!.uploadProfileImage(_selectedImageBytes!);
                        setState(() {
                          _isImageChanged = false;
                        });
                        print("Profile image updated successfully.");
                      } catch (e) {
                        print("Failed to upload image: $e");
                      }
                    }
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text('함께한 투투', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    '${tp.findByCreator(up.currentUser?.uid).length}개',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('함께한지', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    '${daysPassed(up.currentUser?.metadata.creationTime)}일',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(
            thickness: 8,
            // color: Color.fromARGB(255, 245, 245, 245),
            color: Theme.of(context).dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          !_taggedPosts && !_likedPosts
                              ? '내가 작성한 투투'
                              : "필터링한 투투",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                Navigator.pushNamed(context, '/add');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.tune),
                              onPressed: _showFilterSheet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: tp.t
                      .where((item) => !_taggedPosts && !_likedPosts
                          ? (item != null &&
                              item.creator == up.currentUser?.uid)
                          : (item != null &&
                              (!_taggedPosts ||
                                  (item.taggedFriends
                                          ?.contains(up.currentUser?.uid) ??
                                      false)) &&
                              (!_likedPosts ||
                                  (up.ue?.likedToto.contains(item.id) ??
                                      false))))
                      .cast<ToToEntity>()
                      .map((item) => ToToCard(
                            key: ValueKey(item.id),
                            t: item,
                            userName: aup.au
                                    .firstWhere(
                                        (user) => user?.uid == item.creator)
                                    ?.nickname ??
                                item.creator,
                            userImagePath: aup.au
                                    .firstWhere(
                                        (user) => user?.uid == item.creator)
                                    ?.profileImageUrl ??
                                'assets/images/default_profile.jpg',
                            postDate:
                                convertTimestampToKoreanDate(item.created) ??
                                    "",
                            postContent: item.description,
                            postImagePath: item.imageUrl,
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
