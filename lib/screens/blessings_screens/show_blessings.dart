// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vivah_ai/screens/blessings_screens/record_blessing.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import '../../widgets/custom_button.dart';

class ShowBlessings extends StatefulWidget {
  const ShowBlessings({super.key});

  @override
  State<ShowBlessings> createState() => _ShowBlessingsState();
}

class _ShowBlessingsState extends State<ShowBlessings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child){
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
                              color: Color(0xFF33201C),
                              fontSize: 35,
                              fontStyle: FontStyle.italic)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Wishes from the loved ones',
                        style: TextStyle(color: Color(0xFF33201C), fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              body: Stack(children: [
                model.blessingList.isNotEmpty
                    ? PageView.builder(
                  controller: PageController(),
                  itemCount: model.blessingList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    videoC = VideoPlayerController.network(model.blessingList[index].video);
                    return FutureBuilder(
                      future: videoC.initialize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          videoC.play();
                          return Dismissible(
                              key: Key(model.blessingList[index].video),
                              onDismissed: (direction) {
                                if (FirebaseAuth.instance.currentUser?.uid == model.blessingList[index].addedBy) {
                                  model.deleteBlessing(model.blessingList[index].blessingId).whenComplete(
                                          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Blessing deleted successfully'),
                                        duration: Duration(seconds: 2),
                                      )));
                                  // list.removeAt(index);
                                  // setState(() {
                                  //   length = list.length;
                                  // });
                                }
                              },
                              child: GestureDetector(
                                  onTap: () {
                                    if (videoC.value.isPlaying) {
                                      videoC.pause();
                                    } else {
                                      videoC.play();
                                    }
                                  },
                                  child: AspectRatio(
                                    aspectRatio: videoC.value.aspectRatio,
                                    child: Stack(
                                      children: [
                                        VideoPlayer(videoC),
                                        Positioned(
                                            bottom: MediaQuery.of(context).size.height * 0.1,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(model.blessingList[index].name, style: const TextStyle(color: Colors.white),),
                                            ))
                                      ],
                                    ),
                                  )));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF33201C),
                            ),
                          );
                        }
                      },
                    );
                  },
                )
                    : const Center(
                  child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Text(
                        'No blessing',
                      )),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  right: 5,
                  child: CustomButton(
                    label: 'Record blessings',
                    onButtonPressed: (context) => {
                      videoC.pause(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordBlessingScreen(),
                        ),
                      )
                    },
                  ),
                )
              ]),
            ));
      }
    );
  }

  late VideoPlayerController videoC;

  @override
  void dispose() {
    super.dispose();
    videoC.dispose();
  }
}