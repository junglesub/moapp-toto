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
import 'package:moapp_toto/widgets/custom_button.dart';
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
  List<Map<String, dynamic>> postDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    TotoProvider tp = context.read();
    List<ToToEntity?> posts = tp.t.where((item) => item != null).toList();

    List<Map<String, dynamic>> loadedPostData = [];
    for (ToToEntity? post in posts) {
      if (post != null) {
        // 해시태그 초기화
        List<String> hashtags = await _initializeHashtags(post);
        loadedPostData.add({"post": post, "hashtags": hashtags});
      }
    }

    setState(() {
      postDataList = loadedPostData;
      isLoading = false;
    });
  }

  void _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      print("Selected date: $selectedDate");
    }
  }

  Widget _buildAccumulativeDiary() {
    return Container(
      // color: Colors.white,
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
            child: const Text(
              "🔥 누적 투투 16개째...",
              style: TextStyle(
                fontSize: 14,
                // color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              // Ticket and Point box
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromRGBO(255, 143, 0, 1),
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: const Text(
                  "T 5 P 100",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
    required List<String> hashtags,
  }) {
    UserProvider up = context.watch();
    bool isLiked = up.ue?.likedToto.contains(t.id) ?? false;
    return GestureDetector(
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
              Wrap(
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
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  );
                }).toList(),
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

  @override
  Widget build(BuildContext context) {
    TotoProvider tp = context.watch();
    AllUsersProvider aup = context.watch();
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
        appBar: AppBar(
          title: const Text("Today, Together"),
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccumulativeDiary(),
            Divider(
              thickness: 2,
              // color: Color.fromARGB(255, 245, 245, 245),
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: ListView(
                children: postDataList.map((postData) {
                  ToToEntity t = postData["post"];
                  List<String> hashtags = postData["hashtags"];

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
                    hashtags: hashtags,
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
