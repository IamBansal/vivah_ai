import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../widgets/custom_button.dart';

class CreateInvite extends StatefulWidget {
  const CreateInvite({super.key});

  @override
  State<CreateInvite> createState() => _CreateInviteState();
}

class _CreateInviteState extends State<CreateInvite> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
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
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                    child: Image.asset(
                      'assets/pic.png',
                      height: 500,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    top: 9,
                    left: 14,
                    child: Column(
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
                    )),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () { _listen(); },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: !_isListening ? const Color(0xFFD7B2E5) : Colors.green,
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
                const Column(
                  children: [
                    Text('Anika\'s memory with Bindu chachu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    Text('Voice Record your favorite memories', style: TextStyle(color: Colors.black),),
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
        CustomButton(label: 'Create and share this personalised invite', onButtonPressed: (context) => null,),
      ],
    ));
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

}