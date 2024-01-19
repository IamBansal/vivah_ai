import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:vivah_ai/providers/shared_pref.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {

  @override
  Widget build(context) {
    if(storyItems.isNotEmpty) {
      return StoryView(
      storyItems: storyItems,
      controller: controller,
      repeat: false,
      onStoryShow: (s) {},
      onComplete: () {
        Navigator.pop(context);
      },
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
    );
    } else {
      return const Center(
        child: SizedBox(
          height: 60,
            width: 60,
            child: CircularProgressIndicator(color: Colors.white,)),
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
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('blessings')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          setState(() {
            storyItems.add(
                StoryItem.pageVideo(
                  data!['video'],
                  caption: 'Uploaded by: ${data['addedBy']}',
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
    } catch (error) {
      debugPrint('Error querying entries: $error');
      return null;
    }
  }
}