
// ignore_for_file: deprecated_member_use

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:vivah_ai/screens/blessings_screens/record_blessing.dart';
import '../../providers/shared_pref.dart';
import '../../widgets/custom_button.dart';

class ShowBlessings extends StatefulWidget {
  const ShowBlessings({super.key});

  @override
  State<ShowBlessings> createState() => _ShowBlessingsState();
}

class _ShowBlessingsState extends State<ShowBlessings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blessings',
                  style: GoogleFonts.carattere(
                      textStyle: const TextStyle(
                          color: Color(0xFF33201C),
                          fontSize: 35,
                          fontStyle: FontStyle.italic)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'The blessings, the couple is blessed with',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          body: list.isNotEmpty
              ?
          // ListView.builder(
          //   itemCount: list.length,
          //   itemBuilder: (context, index) {
          //     return VideoPlayerWidget(videoUrl: list[index]);
          //   },
          // )
          PageView.builder(
            controller: PageController(),
            itemCount: list.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return VideoPlayerWidget(videoUrl: list[index]);
            },
          )
              : const Center(
            child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  color: Colors.white,
                )),
          ),
          persistentFooterAlignment: const AlignmentDirectional(0, 0),
          persistentFooterButtons: [
            CustomButton(
              label: 'Record my blessings',
              onButtonPressed: (context) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecordBlessingScreen(),
                ),
              ),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _getHighlightsList();
  }

  List<String> list = [];

  Future<List<String>?> _getHighlightsList() async {
    String hashtag = (await LocalData.getName())!;
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
            list.add(data!['video']);
          });
        }
        debugPrint('Found the highlights');
        return list;
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

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        draggableProgressBar: false,
        looping: true,
        showControls: false,
        aspectRatio: 9 / 16,
        autoInitialize: true,
        showOptions: false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}