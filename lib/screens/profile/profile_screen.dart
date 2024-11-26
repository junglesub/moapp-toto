import 'package:flutter/material.dart';
import 'package:moapp_toto/screens/profile/widgets/toto_card_widget.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;
  int _selectedIndex = 0;

  bool _taggedPosts = false;
  bool _likedPosts = false;

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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.1,
          maxChildSize: 0.2,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                controller: scrollController,
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
                          setState(() {
                            _taggedPosts = value;
                          });
                          Navigator.pop(context);
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
                        child: const Icon(Icons.thumb_up, color: Colors.black),
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
                          setState(() {
                            _likedPosts = value;
                          });
                          Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title:
            _showAppBarTitle ? const Center(child: Text('Ryoo Jungsub')) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // 다크모드 전환 로직
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/landing');
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
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // 프로필 사진 변경
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          const Text(
            'Ryoo Jungsub',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text('함께한 투투', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    '45일',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('성공한 미션'),
                  SizedBox(width: 8),
                  Text(
                    '13개',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Color.fromARGB(255, 184, 184, 184),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '누적 투투 15개째',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '내가 작성한 투투',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: _showFilterSheet,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ToToCard(
                      userName: 'Ryoo Jungsub',
                      userImagePath: 'assets/images/profile.jpg',
                      postDate: '2020년 4월 17일',
                      postContent:
                          '뒤에는 영화관에서 구매한 포스터 - 앞에는 코로나 때문에 영화관을 못 가는 나를 위해 구매한 블루레이',
                      postImagePath: 'assets/images/toto.jpg',
                    );
                  },
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
