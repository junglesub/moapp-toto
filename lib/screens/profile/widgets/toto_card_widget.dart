import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moapp_toto/models/toto_entity.dart';
import 'package:moapp_toto/models/user_entity.dart';
import 'package:moapp_toto/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ToToCard extends StatefulWidget {
  final ToToEntity t;
  final String userName;
  final String userImagePath;
  final String postDate;
  final String postContent;
  final String? postImagePath;

  const ToToCard({
    super.key,
    required this.t,
    required this.userName,
    required this.userImagePath,
    required this.postDate,
    required this.postContent,
    required this.postImagePath,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ToToCardState createState() => _ToToCardState();
}

class _ToToCardState extends State<ToToCard> {
  bool isLiked = false;
  List<String> hashtags = [];

  @override
  void initState() {
    super.initState();
    _initializeHashtags();
  }

  Future<void> _initializeHashtags() async {
    List<String> tempHashtags = [];

    if (widget.t.emotion?.name != null) {
      tempHashtags.add("${widget.t.emotion?.emoji} ${widget.t.emotion?.name}");
    }

    if (widget.t.location?.placeName != null) {
      tempHashtags.add("# ${widget.t.location!.placeName}");
    }

    if (widget.t.taggedFriends != null && widget.t.taggedFriends!.isNotEmpty) {
      for (String? uid in widget.t.taggedFriends!) {
        if (uid != null) {
          UserEntry? userEntry = await UserEntry.getUserByUid(uid);
          if (userEntry != null && userEntry.nickname != null) {
            tempHashtags.add("# ${userEntry.nickname!}");
          }
        }
      }
    }
    setState(() {
      hashtags = tempHashtags;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider up = context.watch();
    bool isLiked = up.ue?.likedToto.contains(widget.t.id) ?? false;
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: widget.userImagePath.contains('/svg')
                          ? ClipOval(
                              child: SvgPicture.network(
                                widget.userImagePath,
                                placeholderBuilder: (context) =>
                                    const CircularProgressIndicator(),
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(widget.userImagePath),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.postDate,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (isLiked) {
                          up.ue?.removeLike(widget.t.id);
                        } else {
                          up.ue?.addLike(widget.t.id);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        _showOptionsModal();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.postContent,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            if (widget.postImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.postImagePath!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0, // 태그 사이 간격
              runSpacing: 4.0, // 줄 간 간격
              children: hashtags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[500],
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
        .slideY(begin: 0.1, end: 0, duration: 1000.ms);
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text('투투 수정',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmationDialog('edit');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                ),
                title: const Text('투투 삭제',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmationDialog('delete');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(String action) {
    String title = action == 'edit' ? '투투 수정' : '투투 삭제';
    String content = action == 'edit'
        ? '투투를 수정하시겠습니까?\n티켓 포인트 ***p가 소모됩니다.'
        : '투투를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';
    String confirmText = action == 'edit' ? '수정' : '삭제';
    Color confirmColor = action == 'edit' ? Colors.blue : Colors.red;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소',
                  style: TextStyle(color: Color.fromARGB(255, 133, 133, 133))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (action == 'edit') {
                  _performEditAction();
                } else if (action == 'delete') {
                  _performDeleteAction();
                }
              },
              child: Text(confirmText, style: TextStyle(color: confirmColor)),
            ),
          ],
        );
      },
    );
  }

  void _performEditAction() {
    // 수정 동작 로직 추가
    Navigator.pushNamed(context, "/add", arguments: {"toto": widget.t});
    // Navigator.pushNamed(context, '/edit');
  }

  void _performDeleteAction() async {
    // 삭제 동작 로직 추가
    await widget.t.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('투투가 삭제되었습니다.'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
