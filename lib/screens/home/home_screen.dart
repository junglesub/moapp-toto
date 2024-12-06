import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/all_users_provider.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:moapp_toto/utils/date_format.dart';
import 'package:moapp_toto/widgets/botttom_nav_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  // final List<bool> _isFavorited = [false, false, false]; // 각 카드의 하트 상태 저장 (임시)
  DateTime? _selectedDate; // 날짜 필터링용
  @override
  void initState() {
    super.initState();
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      print("Selected date: $selectedDate");
    }
  }

  Widget _buildAccumulativeDiary(BuildContext context) {
    UserProvider up = context.read();
    TotoProvider tp = context.read();

    int ticketCount = up.ue?.ticket ?? 0; //파이어베이스랑 티켓정보 연결
    int pointCount = up.ue?.point ?? 0; //

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Accumulative diary text
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.amber,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Text(
              "🔥 누적 투투 ${tp.findByCreator(up.currentUser?.uid).length}개째...",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              // Ticket and Point box
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 143, 0, 1),
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$ticketCount", // <<< 나중에 티켓 숫자 집어넣기>>>
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Coin icon and count
                    const Icon(
                      Icons.stars, // Use coin-like icon
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$pointCount", // Point count
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Calendar icon
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> _initializeHashtags(ToToEntity t) async {
    List<String> tempHashtags = [];

    if (t.emotion?.name != null) {
      tempHashtags.add("${t.emotion?.emoji} ${t.emotion?.name}");
    }

    if (t.location?.placeName != null) {
      tempHashtags.add("# ${t.location!.placeName}");
    }

    if (t.taggedFriends != null && t.taggedFriends!.isNotEmpty) {
      for (String? uid in t.taggedFriends!) {
        if (uid != null) {
          UserEntry? userEntry = await UserEntry.getUserByUid(uid);
          if (userEntry != null && userEntry.nickname != null) {
            tempHashtags.add("# ${userEntry.nickname!}");
          }
        }
      }
    }

    return tempHashtags;
  }

  Widget _buildPostCard({
    required BuildContext context,
    required ToToEntity t,
    required String authorName,
    required String date,
    required String content,
    String? imageUrl,
    String? userImagePath,
    required int cardIndex,
  }) {
    UserProvider up = context.watch();
    bool isLiked = up.ue?.likedToto.contains(t.id) ?? false;
    return GestureDetector(
      key: ValueKey(t.id),
      onDoubleTap: () {
        if (isLiked) {
          // up.ue?.removeLike(t.id);
        } else {
          up.ue?.addLike(t.id);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child:
                        userImagePath != null && userImagePath.contains('/svg')
                            ? ClipOval(
                                child: SvgPicture.network(
                                  userImagePath,
                                  placeholderBuilder: (context) =>
                                      const CircularProgressIndicator(),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage: userImagePath != null
                                    ? NetworkImage(userImagePath)
                                    : null,
                                child: userImagePath == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // 하트 아이콘 수정 부분
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null, // 하트 색상 변경
                    ),
                    onPressed: () {
                      if (isLiked) {
                        up.ue?.removeLike(t.id);
                      } else {
                        up.ue?.addLike(t.id);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(content),
              const SizedBox(height: 12.0),
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              const SizedBox(height: 12.0),
              FutureBuilder<List<String>>(
                future: _initializeHashtags(t),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final hashtags = snapshot.data!;
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: hashtags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(child: Text('No hashtags found.'));
                  }
                },
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 1000.ms)
          .slideY(begin: 0.1, end: 0, duration: 1000.ms),
    );
  }

  Widget _buildSelectedDateFilter() {
    if (_selectedDate == null) {
      return const SizedBox.shrink(); // 선택된 날짜가 없으면 아무것도 표시하지 않음
    }

    return Align(
      alignment: Alignment.topRight,
      // 추가된 부분
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.yellow,
              Color.fromRGBO(255, 143, 0, 1),
            ],
          ),
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(
          //   width: 2,
          //   color: Colors.black,
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedDate = null; // 선택된 날짜 초기화
                });
              },
              child: const Icon(
                Icons.cancel,
                size: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.search,
              size: 20,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TotoProvider tp = context.watch();
    UserProvider up = context.watch();
    AllUsersProvider aup = context.watch();
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Today, Together"),
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccumulativeDiary(context),
            Divider(
              thickness: 2,
              // color: Color.fromARGB(255, 245, 245, 245),
              color: Theme.of(context).dividerColor,
            ),
            _buildSelectedDateFilter(), // 선택된 날짜 필터 표시
            // Expanded(
            //   child: ListView(
            //     children: tp.t.where((toto) {
            //       // 자기가 팔로우중 사람 아니면 무조건 숨기기
            //       if (toto.creator != up.currentUser?.uid &&
            //           !(up.ue?.following.contains(toto.creator) ?? false)) {
            //         return false;
            //       }
            //       // 날짜 확인
            //       if (_selectedDate == null) return true;
            //       DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
            //         (toto.created as Timestamp).millisecondsSinceEpoch,
            //       );

            //       // 선택된 날짜와 게시물 날짜 비교 (연, 월, 일만 확인)
            //       return postDate.year == _selectedDate!.year &&
            //           postDate.month == _selectedDate!.month &&
            //           postDate.day == _selectedDate!.day;
            //     }).map((t) {
            //       return _buildPostCard(
            //         context: context,
            //         t: t,
            //         authorName: aup.au
            //                 .firstWhere((user) => user?.uid == t.creator)
            //                 ?.nickname ??
            //             t.creator,
            //         userImagePath: aup.au
            //             .firstWhere((user) => user?.uid == t.creator)
            //             ?.profileImageUrl,
            //         date: convertTimestampToKoreanDate(t.created) ?? "",
            //         content: t.description,
            //         imageUrl: t.imageUrl,
            //         cardIndex: 0,
            //       );
            //     }).toList(),
            //   ),
            // ),
            Expanded(
              child: tp.t.where((toto) {
                // 자기가 팔로우중 사람 아니면 무조건 숨기기
                if (toto.creator != up.currentUser?.uid &&
                    !(up.ue?.following.contains(toto.creator) ?? false)) {
                  return false;
                }
                // 날짜 확인
                if (_selectedDate == null) return true;
                DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
                  (toto.created as Timestamp).millisecondsSinceEpoch,
                );

                // 선택된 날짜와 게시물 날짜 비교 (연, 월, 일만 확인)
                return postDate.year == _selectedDate!.year &&
                    postDate.month == _selectedDate!.month &&
                    postDate.day == _selectedDate!.day;
              }).isEmpty
                  ? const Center(
                      child: Text('해당 날짜에 작성된 투투가 없습니다'),
                    )
                  : ListView(
                      children: tp.t.where((toto) {
                        // 자기가 팔로우중 사람 아니면 무조건 숨기기
                        if (toto.creator != up.currentUser?.uid &&
                            !(up.ue?.following.contains(toto.creator) ??
                                false)) {
                          return false;
                        }
                        // 날짜 확인
                        if (_selectedDate == null) return true;
                        DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
                          (toto.created as Timestamp).millisecondsSinceEpoch,
                        );

                        return postDate.year == _selectedDate!.year &&
                            postDate.month == _selectedDate!.month &&
                            postDate.day == _selectedDate!.day;
                      }).map((t) {
                        return _buildPostCard(
                          context: context,
                          t: t,
                          authorName: aup.au
                                  .firstWhere((user) => user?.uid == t.creator)
                                  ?.nickname ??
                              t.creator,
                          userImagePath: aup.au
                              .firstWhere((user) => user?.uid == t.creator)
                              ?.profileImageUrl,
                          date: convertTimestampToKoreanDate(t.created) ?? "",
                          content: t.description,
                          imageUrl: t.imageUrl,
                          cardIndex: 0,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (indexPage) {
            setState(() {
              _currentIndex = indexPage;
            });
            print("Selected tab: $indexPage");
          },
        ),
      ),
      floatingWidget: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingWidgetHeight: 50,
      floatingWidgetWidth: 50,
      dx: 320,
      dy: 700,
      deleteWidget: const Icon(Icons.cancel),
      deleteWidgetAlignment: Alignment.bottomCenter,
      deleteWidgetPadding: const EdgeInsets.only(bottom: 80),
    );
  }
}
