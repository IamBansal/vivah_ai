
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blessing_screen.dart';

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
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.circle,
                      ),
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