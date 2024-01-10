import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:vivah_ai/screens/guest_list_screen.dart';
import '../widgets/custom_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateInvite extends StatefulWidget {
  final Guest guest;

  const CreateInvite({super.key, required this.guest});

  @override
  State<CreateInvite> createState() => _CreateInviteState();
}

class _CreateInviteState extends State<CreateInvite> {
  String imageUrlEmbed = '';

  @override
  void initState() {
    super.initState();
    imageUrlEmbed = widget.guest.url;
  }

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
                  onPressed: () {
                    makePhotoLabAPICall(widget.guest.url);
                  },
                  icon: const Icon(Icons.transform),)
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
                    // child: FutureBuilder(
                    //   future: makePhotoLabAPICall(widget.guest.url),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState
                    //         .waiting) {
                    //       return const CircularProgressIndicator();
                    //     } else if (snapshot.hasError) {
                    //       return Center(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(13.0),
                    //             child: Text(
                    //               'Error loading image ${snapshot.error.toString()}',
                    //               style: const TextStyle(
                    //                   color: Colors.white, fontSize: 18),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ));
                    //     } else {
                    //       // return ClipRRect(
                    //       //   borderRadius: const BorderRadius.only(
                    //       //       bottomLeft: Radius.circular(14),
                    //       //       bottomRight: Radius.circular(14)),
                    //       //   child: isValidURL(widget.guest.url) ? Image.network(
                    //       //     widget.guest.url,
                    //       //     height: 500,
                    //       //     width: MediaQuery
                    //       //         .of(context)
                    //       //         .size
                    //       //         .width,
                    //       //     fit: BoxFit.cover,
                    //       //   ) : Image.asset(
                    //       //     'assets/pic.png',
                    //       //     height: 500,
                    //       //     width: MediaQuery
                    //       //         .of(context)
                    //       //         .size
                    //       //         .width,
                    //       //     fit: BoxFit.cover,
                    //       //   ),
                    //       // );
                    //       return ClipRRect(
                    //         borderRadius: const BorderRadius.only(
                    //             bottomLeft: Radius.circular(14),
                    //             bottomRight: Radius.circular(14)),
                    //         child: Image.network(
                    //           snapshot.data != null ? snapshot.data! : widget.guest.url,
                    //           height: 500,
                    //           width: MediaQuery
                    //               .of(context)
                    //               .size
                    //               .width,
                    //           fit: BoxFit.cover,
                    //         )
                    //       );
                    //     }
                    //   }
                    // ),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14)),
                      child: Image.asset(
                      'assets/invite.jpg',
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.26,
                    top: MediaQuery.of(context).size.height * 0.07,
                    child: ClipRRect(
                      child: Image.network(
                        imageUrlEmbed,
                        height: 240,
                        width: 185,
                        fit: BoxFit.cover,
                      )),),
                  Positioned(
                    bottom: 50,
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
                          padding: const EdgeInsets.only(bottom: 10.0, top: 8),
                          child: Text(
                            _text,
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                  ),
                      ],
                    ),)
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _listen();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: !_isListening
                          ? const Color(0xFFD7B2E5)
                          : Colors.green,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Your memory with ${widget.guest.name}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Voice Record your favorite memories',
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
                    _text,
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
          label: 'Create and share this personalised invite',
          onButtonPressed: (context) => _shareInvite(),
        ),
      ],
    ));
  }

  String photoApiKey = dotenv.env['PHOTO_API_KEY'] ?? '';

  Future<String?> makePhotoLabAPICall(String imageUrl) async {
    String apiUrl = 'https://photolab-me.p.rapidapi.com/photolab/v2/';
    String rapidApiKey = photoApiKey;

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-Rapidapi-Key': rapidApiKey,
      'X-Rapidapi-Host': 'photolab-me.p.rapidapi.com',
    };

    String comboId = '33975893';

    String encodedParams =
        'image_url=$imageUrl&combo_id=$comboId';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: encodedParams,
      );

      if (response.statusCode == 200) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        var parsedResponse = json.decode(response.body);
        setState(() {
          imageUrlEmbed = parsedResponse['image_url'];
        });
        return parsedResponse['image_url'];
      } else {
        debugPrint('API call failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error making API call: $e');
      return null;
    }
  }

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  Future<bool> requestPermissions() async {
    PermissionStatus status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _listen() async {
    _text = "";
    if (!_isListening) {
      var microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus.isGranted) {
        bool available = await _speech.initialize(
          onStatus: _onSpeechStatus,
          onError: _onSpeechError,
        );

        if (available) {
          debugPrint("it is available $available");
          setState(() => _isListening = true);
          _speech.listen(
            onResult: _onSpeechResult,
          );
        } else {
          debugPrint("Speech recognition is not available");
        }
      } else {
        debugPrint("Permission denied for speech");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _onSpeechResult(SpeechRecognitionResult result) async {
    setState(() => _text = result.recognizedWords);
    debugPrint(_text);
    if (result.finalResult) {
      _isListening = !_isListening;
    }
  }

  void _onSpeechError(SpeechRecognitionError error) {
    debugPrint(error.errorMsg);
  }

  void _onSpeechStatus(String status) {
    debugPrint("status is $status");
  }

  bool isValidURL(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      return true;
    }
    return false;
  }

  final _screenshotController = ScreenshotController();

  Future<void> _shareInvite() async {
    try {
      final uint8List = await _screenshotController.capture();
      final tempDir = await getTemporaryDirectory();
      final imagePath = '${tempDir.path}/image.png';

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(uint8List!);

      await Share.shareFiles(
        [imagePath],
        text:
            'Inviting you!!\nDownload the app to know more about what\'s for you',
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
