import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:vivah_ai/models/ceremony.dart';
import 'package:vivah_ai/models/photo.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'package:vivah_ai/providers/shared_pref.dart';

class StoryScreen extends StatefulWidget {
  final String filter;
  final bool isCouple;

  const StoryScreen({super.key, required this.filter, required this.isCouple});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(context) {
    if (storyItems.isNotEmpty) {
      return SafeArea(
        child: Scaffold(
          body: StoryView(
            storyItems: storyItems,
            controller: controller,
            repeat: false,
            onStoryShow: (storyItem) {},
            onComplete: () {
              Navigator.pop(context);
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context);
              }
            },
            indicatorColor: const Color(0xFF33201C),
            indicatorForegroundColor: const Color(0xFFFFD384),
          ),
        ),
      );
    } else {
      return const Center(
        child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: Colors.white,
            )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getHighlightsList();
  }

  final controller = StoryController();
  List<StoryItem> storyItems = [];

  Future<List<StoryItem>?> _getHighlightsList() async {
    String hashtag = (await LocalData.getName())!;
    storyItems.clear();
    try {
      if (widget.filter == 'blessings') {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('blessings')
            .where('hashtag', isEqualTo: hashtag)
            .get();
        if (snapshot.docs.isNotEmpty) {
          for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
            Map<String, dynamic>? data = entry.data();
            setState(() {
              storyItems.add(StoryItem.pageVideo(
                data!['video'],
                caption: 'Uploaded by: ${data['name']}',
                duration: Duration(seconds: data['duration'].toInt()),
                controller: controller,
              ));
            });
          }
          debugPrint('Found the highlights');
          return storyItems;
        } else {
          debugPrint('No matching documents found for highlights.');
          return null;
        }
      } else if (widget.filter == 'photos') {
        List<PhotoItem> list = await ApiCalls.getPhotosList();
        for (PhotoItem item in list) {
          setState(() {
            storyItems.add(StoryItem(
              StoryWidget(image: item.image, text: '${item.name} in ${item.category}', isCouple: widget.isCouple),
                duration: const Duration(seconds: 3)));
          });
        }
        return storyItems;
      } else if (widget.filter == 'others') {
        List<Ceremony> list = await ApiCalls.getCeremonyList();
        for (Ceremony item in list) {
          setState(() {
            // storyItems.add(StoryItem.pageImage(
            //     url: item.url,
            //     controller: controller,
            //     caption: '${item.title} on ${item.date}'));
            storyItems.add(StoryItem(
                StoryWidgetOthers(image: item.url, text: '${item.title} on ${item.date}'),
                duration: const Duration(seconds: 3)));
          });
        }
        return storyItems;
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return null;
    }
    return null;
  }
}

class StoryWidget extends StatelessWidget {
  final String image;
  final String text;
  final bool isCouple;
  const StoryWidget({super.key, required this.image, required this.text, required this.isCouple});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.network(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          (loadingProgress
                              .expectedTotalBytes ??
                              1)
                          : null,
                    ),
                  );
                }
              },
            ),
            Positioned(
              left: 5,
              top: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Text(text),
              ),
            ),
            if (isCouple) Positioned(right: 5, top: 10,child: IconButton(onPressed: (){
              //TODO - deleteMemory();
            }, icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFF33201C),
            ),),)
          ],
        ),
      ),
    );
  }
}

class StoryWidgetOthers extends StatelessWidget {
  final String image;
  final String text;
  const StoryWidgetOthers({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.network(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          (loadingProgress
                              .expectedTotalBytes ??
                              1)
                          : null,
                    ),
                  );
                }
              },
            ),
            Positioned(
              left: 5,
              top: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Text(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

