import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                Container(
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
              child: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
}