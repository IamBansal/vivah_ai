import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import '../providers/api_calls.dart';

class PersonalInvitation extends StatefulWidget {
  const PersonalInvitation({super.key});

  @override
  State<PersonalInvitation> createState() => _PersonalInvitationState();
}

class _PersonalInvitationState extends State<PersonalInvitation> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child) {
        return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 28.0, bottom: 10, left: 13, right: 13),
                      child: Text(
                        'Hi, ${model.personalInvite.name}',
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
                          child: model.personalInvite.image.isNotEmpty
                              ? Image.network(
                            model.personalInvite.image,
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
                      child: Text(model.personalInvite.memory),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                      child: Text('Room number: ${model.personalInvite.room}'),
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
                                ApiCalls.shareDownloadVoiceInvite(true, model.personalInvite.audio);
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
                            if (model.personalInvite.audio.isNotEmpty) {
                              playing
                                  ? myAudioPlayer.pause()
                                  : myAudioPlayer.play(UrlSource(model.personalInvite.audio));
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
      },
    );
  }

  AudioPlayer myAudioPlayer = AudioPlayer();
  bool playing = false;
  final _screenshotController = ScreenshotController();
}
