import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import '../../models/guest.dart';
import '../../providers/api_calls.dart';
import '../../viewmodels/main_view_model.dart';
import '../../widgets/custom_button.dart';
import 'package:screenshot/screenshot.dart';

class CreateInvite extends StatefulWidget {
  final Guest guest;
  final int indexInList;
  const CreateInvite({super.key, required this.guest, required this.indexInList});

  @override
  State<CreateInvite> createState() => _CreateInviteState();
}

class _CreateInviteState extends State<CreateInvite> {
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
                  'Create Invite',
                  style: GoogleFonts.carattere(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontStyle: FontStyle.italic)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Upload pictures and audio for them',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await ApiCalls.createShareVideo(_screenshotController, audioPath);
                },
                icon: const Icon(Icons.video_camera_back_outlined),
              ),
              IconButton(
                onPressed: () {
                  ApiCalls.shareDownloadInvite(
                      _screenshotController, true, context);
                },
                icon: const Icon(Icons.file_download_outlined),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Stack(
                    children: [
                      //Shader-mask if for adding a black blend behind text
                      ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black38, Colors.transparent],
                            stops: [0.0, 0.6],
                          ).createShader(bounds);
                        },
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14)),
                            child: Image.asset(
                              'assets/static.jpg',
                              // height: MediaQuery.of(context).size.height * 0.6,
                              // width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.27,
                        top: MediaQuery.of(context).size.height * 0.11,
                        child: toMakePhotoCall ? FutureBuilder(
                            future: ApiCalls.makePhotoLabAPICall(widget.guest.url),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.27,
                                    width: MediaQuery.of(context).size.width * 0.47,
                                    child: const Center(child: CircularProgressIndicator(color: Color(0xFFFFD384),)));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Text(
                                        'Error loading image ${snapshot.error.toString()}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                              } else {
                                if(snapshot.data != null) { imageUrlEmbed = snapshot.data!; toMakePhotoCall = !toMakePhotoCall; }
                                return ClipRRect(
                                    child: Image.network(
                                      snapshot.data != null ? snapshot.data! : imageUrlEmbed,
                                      height: MediaQuery.of(context).size.height * 0.27,
                                      width: MediaQuery.of(context).size.width * 0.47,
                                      fit: BoxFit.cover,
                                    )
                                );
                              }
                            }
                        ) : ClipRRect(child: Image.network(
                          imageUrlEmbed,
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: MediaQuery.of(context).size.width * 0.47,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        )),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.08,
                        left: MediaQuery.of(context).size.width * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Dear ${widget.guest.name},',
                              style: GoogleFonts.carattere(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontStyle: FontStyle.italic)),
                            ),
                            SizedBox(
                              height: 100,
                              width: 230,
                              child: Padding(
                                padding:
                                const EdgeInsets.only(bottom: 0.0, top: 8),
                                child: Text(
                                  _text,
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 5,),
                    GestureDetector(
                      onTap: () {
                        isRecording ? stopRecording() : startRecording();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color:
                          !isRecording ? const Color(0xFF713C05) : Colors.green,
                        ),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          color: Colors.transparent,
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.mic,
                              size: 36,
                              color: Color(0xFFFFD384),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Visibility(
                      visible: widget.guest.audio.isNotEmpty,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.guest.audio.isNotEmpty) {
                            listenerPlaying
                                ? audioPlayer.pause()
                                : audioPlayer.play(UrlSource(widget.guest.audio));
                            setState(() {
                              listenerPlaying = !listenerPlaying;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: listenerPlaying ? Colors.green : const Color(0xFF713C05),
                          ),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: Colors.transparent,
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(
                                Icons.multitrack_audio_outlined,
                                size: 36,
                                color: Color(0xFFFFD384),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your memory with ${widget.guest.name}',
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Voice Record your favorite memories',
                            style: TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                showLoader
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: JumpingDots(
                    color: Colors.black,
                    radius: 8,
                    numberOfDots: 3,
                  ),
                )
                    : Container(
                  color: Colors.white10,
                  height: 150,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          persistentFooterAlignment: const AlignmentDirectional(0, 0),
          persistentFooterButtons: [
            Consumer<MainViewModel>(
                builder: (context, model, child){
                  return CustomButton(
                    label: model.guestCreateInviteButtonText,
                    onButtonPressed: (context) => {
                      model.updateGuestAddInviteToDB(_screenshotController, audioPath, widget.guest, _text, widget.indexInList, imageUrlEmbed)
                          .whenComplete(() => ApiCalls.shareDownloadInvite(
                          _screenshotController,
                          false,
                          context,
                          'Inviting you!!\nDownload the app to know more about what\'s for you\nUse the hashtag ${widget.guest.hashtag} to login'))
                    },
                  );
                }
            )
          ],
        ));
  }

  String _text = '';
  String imageUrlEmbed = '';
  final _screenshotController = ScreenshotController();
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";
  bool recodingNow = true;
  String buttonText = 'Create and share your invite';
  bool playing = false;
  bool listenerPlaying = false;
  bool showLoader = false;
  bool toMakePhotoCall = false;

  @override
  void initState() {
    super.initState();
    imageUrlEmbed = widget.guest.url;
    _text = widget.guest.memory;
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    toMakePhotoCall = widget.guest.image.isEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

  Future<void> startRecording() async {
    try {
      debugPrint("Start Recording");
      if (await audioRecord.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final audioPath = '${tempDir.path}/audio.mp3';
        await audioRecord.start(const RecordConfig(), path: audioPath);
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      debugPrint('Recording stopped');
      String? path = await audioRecord.stop();
      setState(() {
        recodingNow = false;
        isRecording = false;
        audioPath = path!;
      });
      setState(() {
        showLoader = true;
      });
      String text = await ApiCalls.transcribeAudio(audioPath);
      setState(() {
        _text = text;
        showLoader = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}