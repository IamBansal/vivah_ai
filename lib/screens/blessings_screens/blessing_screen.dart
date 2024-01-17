import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../../providers/api_calls.dart';
import '../../providers/shared_pref.dart';
import '../../widgets/custom_button.dart';

class BlessingsScreen extends StatefulWidget {
  final String filePath;

  const BlessingsScreen({super.key, required this.filePath});

  @override
  State<BlessingsScreen> createState() => _BlessingsScreenState();
}

class _BlessingsScreenState extends State<BlessingsScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
  }

  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black26,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blessings',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontStyle: FontStyle.italic)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Bless the couple',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              child: VideoPlayer(_videoPlayerController),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    !_isPlaying
                        ? await _videoPlayerController.play()
                        : await _videoPlayerController.pause();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color(0xFF713C05),
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          !_isPlaying ? Icons.play_arrow : Icons.pause,
                          size: 36,
                          color: const Color(0xFFFFD384),
                        ),
                      ),
                    ),
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      'Your blessings',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'A message for the couple',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
            Container(
              color: Colors.white10,
              height: 150,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _videoPlayerController.value.caption.text.isNotEmpty
                        ? _videoPlayerController.value.caption.text
                        : 'No captions found',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      persistentFooterAlignment: const AlignmentDirectional(0, 0),
      persistentFooterButtons: [
        CustomButton(
          label: buttonText,
          onButtonPressed: (context) => saveToDB(),
        )
      ],
    ));
  }

  String buttonText = 'Upload and share your blessing';

  Future<void> saveToDB() async {
    setState(() {
      buttonText = 'Uploading your blessing....';
    });
    String id = (FirebaseAuth.instance.currentUser?.uid)!;
    String hashtag = (await LocalData.getName())!;

    List<dynamic> cloudinaryResponse =
        (await ApiCalls.uploadVideoToCloudinary(widget.filePath))!;
    try {
      await FirebaseFirestore.instance.collection('blessings').add({
        'hashtag': hashtag,
        'addedBy': id,
        'video': cloudinaryResponse[0],
        'duration': cloudinaryResponse[1]
      }).whenComplete(() => Navigator.of(context).pop());

      setState(() {
        buttonText = 'Upload and share your blessing';
      });
      debugPrint('Blessing uploaded');
    } catch (e) {
      setState(() {
        buttonText = 'Upload and share your blessing';
      });
      debugPrint('Error uploading photo to Firestore: $e');
    }
  }
}
