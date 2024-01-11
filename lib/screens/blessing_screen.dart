import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../widgets/custom_button.dart';

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
                      color: const Color(0xFFD7B2E5),
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
                          color: Colors.white,
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
                    _videoPlayerController.value.caption.text.isNotEmpty ? _videoPlayerController.value.caption.text : 'No captions found',
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
          label: 'Upload and share your blessing',
          onButtonPressed: (context) => null,
        )
      ],
    ));
  }
}

class RecordBlessingScreen extends StatefulWidget {
  const RecordBlessingScreen({super.key});

  @override
  State<RecordBlessingScreen> createState() => _RecordBlessingScreenState();
}

class _RecordBlessingScreenState extends State<RecordBlessingScreen> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      toNextScreen(file.path);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  void toNextScreen(String path) {
    final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => BlessingsScreen(filePath: path),
    );
    Navigator.push(context, route);
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
                  'Record good wishes or a memory!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
        ),
        body: _isLoading
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD7B2E5),
                  ),
                ),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
                children: [
                  CameraPreview(
                    _cameraController,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: FloatingActionButton(
                            backgroundColor:
                                _isRecording ? Colors.green : Colors.red,
                            child:
                                Icon(_isRecording ? Icons.stop : Icons.circle,),
                            onPressed: () => _recordVideo(),
                          ),
                        )),
                  ),
                ],
              ),
      ),
    );
  }
}
