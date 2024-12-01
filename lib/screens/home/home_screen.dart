import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:moapp_toto/provider/all_users_provider.dart';
import 'package:moapp_toto/provider/toto_provider.dart';
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
  final List<bool> _isFavorited = [false, false, false]; // 각 카드의 하트 상태 저장 (임시)

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

  Widget _buildPostCard({
    required String authorName,
    required String date,
    required String content,
    String? imageUrl,
    required int cardIndex, // 카드 인덱스를 받음
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorited[cardIndex] = !_isFavorited[cardIndex]; // 하트 상태 토글
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    child: Icon(Icons.person),
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
                      _isFavorited[cardIndex]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorited[cardIndex]
                          ? Colors.red
                          : null, // 하트 색상 변경
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorited[cardIndex] =
                            !_isFavorited[cardIndex]; // 하트 상태 변경
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(content),
              const SizedBox(height: 12.0),
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              const SizedBox(height: 12.0),
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
                  children: tp.t.where((item) => item != null).map((item) {
                return _buildPostCard(
                  authorName: aup.au
                          .firstWhere((user) => user?.uid == item!.creator)
                          ?.nickname ??
                      item!.creator,
                  date: convertTimestampToKoreanDate(item!.created) ?? "",
                  content: item!.description,
                  imageUrl: item.imageUrl,
                  cardIndex: 0, // 카드 인덱스를 전달
                );
              }).toList()),
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
