import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/providers/shared_pref.dart';
import '../providers/api_calls.dart';

class PersonalInvitation extends StatefulWidget {
  const PersonalInvitation({super.key});

  @override
  State<PersonalInvitation> createState() => _PersonalInvitationState();
}

class _PersonalInvitationState extends State<PersonalInvitation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 28.0, bottom: 10, left: 13, right: 13),
              child: Text(
                'Hi, $name',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Color(0xFF33201C),
                        fontSize: 42,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your invite',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            ApiCalls.shareDownloadInvite(
                                _screenshotController, false, context);
                          },
                          icon: const Icon(Icons.file_upload_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            ApiCalls.shareDownloadInvite(
                                _screenshotController, true, context);
                          },
                          icon: const Icon(Icons.file_download_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Screenshot(
                controller: _screenshotController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/pic.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
                indent: 10,
                endIndent: 10,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text(memory),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text('Room number: $room'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Voice Invitation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.file_upload_outlined), onPressed: () {
                        ApiCalls.shareDownloadVoiceInvite(false);
                      },),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(icon: const Icon(Icons.file_download_outlined), onPressed: () {
                        ApiCalls.shareDownloadVoiceInvite(true, audioUrl);
                      },),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    if (audioUrl.isNotEmpty) {
                      playing
                          ? myAudioPlayer.pause()
                          : myAudioPlayer.play(UrlSource(audioUrl));
                      setState(() {
                        playing = !playing;
                      });
                    }
                  },
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _getInvitation();
  }

  String imageUrl = '';
  String memory = '';
  String name = '';
  String room = '';
  bool playing = false;
  final _screenshotController = ScreenshotController();

  Future<void> _getInvitation() async {
    String contact = (FirebaseAuth.instance.currentUser?.phoneNumber)!;
    String hashtag = (await LocalData.getName())!;

    debugPrint(contact);

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .where('contact', isEqualTo: contact.substring(3))
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          setState(() {
            imageUrl = data!.containsKey('image') ? data['image'] : 'No image';
            memory = data.containsKey('memory') ? data['memory'] : 'No memory';
            name = data['name'];
            room = data['room'];
            audioUrl = data.containsKey('audio') ? data['audio'] : 'No audio';
          });
        }
        debugPrint('Found the invitation');
      } else {
        debugPrint('No matching documents found.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  AudioPlayer myAudioPlayer = AudioPlayer();
  String audioUrl = '';
}
