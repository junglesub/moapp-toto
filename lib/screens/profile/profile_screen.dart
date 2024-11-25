// import 'package:flutter/material.dart';
// import 'package:moapp_toto/widgets/botttom_nav_bar.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final ScrollController _scrollController = ScrollController();
//   bool _showAppBarTitle = false;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.offset > 140 && !_showAppBarTitle) {
//         setState(() {
//           _showAppBarTitle = true;
//         });
//       } else if (_scrollController.offset <= 100 && _showAppBarTitle) {
//         setState(() {
//           _showAppBarTitle = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _showAppBarTitle ? const Center(child: Text('유저 닉네임')) : null,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.dark_mode),
//             onPressed: () {
//               // 다크모드 전환 로직
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushNamed(context, '/landing');
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         controller: _scrollController,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 180,
//                 color: const Color(0xFF363536),
//               ),
//               Positioned(
//                 bottom: -60,
//                 left: MediaQuery.of(context).size.width / 2 - 70,
//                 child: CircleAvatar(
//                   radius: 70,
//                   backgroundColor: Colors.grey[300],
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.camera_alt,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       // 프로필 사진 변경
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 70),
//           const Text(
//             '개발의 정석',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 children: [
//                   Text('함께한 투투', style: TextStyle(fontSize: 16)),
//                   SizedBox(width: 8),
//                   Text(
//                     '45일',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text('성공한 미션'),
//                   SizedBox(width: 8),
//                   Text(
//                     '13개',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Divider(
//             color: Color.fromARGB(255, 184, 184, 184),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Column(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '누적 투투 15개째',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     const SizedBox(
//                       height: 2,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           '내가 작성한 투투',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.tune),
//                           onPressed: () {
//                             // 필터 아이콘 동작
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: const Center(
//                     child: Text('유저가 작성한 게시물'),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: const Center(
//                     child: Text('유저가 작성한 게시물'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showAppBarTitle ? const Center(child: Text('유저 닉네임')) : null,
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
            ],
          ),
          const SizedBox(height: 70),
          const Text(
            '개발의 정석',
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
                    const SizedBox(
                      height: 2,
                    ),
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
                          onPressed: () {
                            // 필터 아이콘 동작
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 게시물 리스트 시작
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5, // 더미 데이터 3개
                  itemBuilder: (context, index) {
                    return Container(
                      height: 200,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.asset(
                                'assets/images/toto.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '유저가 작성한 게시물',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                        // 애니메이션 추가
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .slideY(begin: 0.1, end: 0, duration: 1000.ms);
                  },
                ),
                // 게시물 리스트 끝
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
