// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import '../../../main_screen.dart';
import '../../../widgets/custom_button.dart';
import '../../terms_and_policy.dart';
import 'couple_login.dart';

class GuestLogin extends StatefulWidget {
  const GuestLogin({super.key});

  @override
  State<GuestLogin> createState() => _GuestLoginState();
}

class _GuestLoginState extends State<GuestLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Vivah',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Color(0xFF33201C),
                        fontSize: 75,
                        fontStyle: FontStyle.italic)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 38.0),
                child: Text(
                  'Your wedding, personalised',
                  style: TextStyle(color: Color(0xFF33201C), fontSize: 15),
                ),
              ),
              CustomTextField(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                  expand: false),
              const SizedBox(height: 20),
              CustomTextFieldWithIcon(
                controller: _phoneController,
                label: 'Phone number',
                hint: 'Enter your phone number',
                icon: Icons.add_call,
                expand: false,
                onIconTap: (context) => _importContact(),
                keyboardType: TextInputType.phone,
                readOnly: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: _hashtagController,
                  label: 'Wedding hashtag',
                  hint: '',
                  expand: false),
              const SizedBox(height: 20),
              Visibility(
                  visible: !_verificationId.isNotEmpty,
                  child: CustomButton(
                    label: 'Send OTP',
                    // onButtonPressed: (context) => saveAndNavigate(),
                    onButtonPressed: (context) => verifyPhoneNumber(),
                  )),
              Visibility(
                visible: _verificationId.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomTextField(
                      controller: _otpController,
                      label: 'OTP',
                      hint: 'Enter OTP',
                      expand: false,
                    ),
                    InkWell(
                        onTap: verifyPhoneNumber,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Resend OTP?'),
                        )),
                    const SizedBox(height: 10),
                    CustomButton(
                      label: 'Verify OTP and Login...',
                      onButtonPressed: (context) => signInWithPhoneNumber(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CoupleLogin(),
                      ),
                    );
                  },
                  child: const Text(
                    "Log in as host",
                    style: TextStyle(color: Color(0xFF33201C)),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 28.0, bottom: 5),
                    child: Text(
                      "All rights reserved",
                      style: TextStyle(color: Color(0xFF33201C)),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen(isTerms: true)),
                          );
                        },
                        child: const Text(
                          "Terms & Conditions |",
                          style: TextStyle(color: Color(0xFF33201C), fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen(isTerms: false)),
                          );
                        },
                        child: const Text(
                          " Privacy Policy",
                          style: TextStyle(color: Color(0xFF33201C), fontWeight: FontWeight.bold, decoration: TextDecoration.underline,),),
                        ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
    _hashtagController.text = '#';
  }

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> _importContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    _phoneController.text = contact.phoneNumber!.number.toString();
  }

  Future<void> verifyPhoneNumber() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _hashtagController.text.isNotEmpty &&
        _hashtagController.text.startsWith('#')) {
      bool valid = await checkForHashtag();
      if (valid) {
        try {
          await _auth.verifyPhoneNumber(
            phoneNumber: '+91${_phoneController.text}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await _auth
                  .signInWithCredential(credential)
                  .whenComplete(() => saveAndNavigate());
            },
            verificationFailed: (FirebaseAuthException e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.message.toString()),
                duration: const Duration(seconds: 2),
              ));
              debugPrint(e.message);
            },
            codeSent: (String verificationId, int? resendToken) {
              setState(() {
                _verificationId = verificationId;
              });
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              setState(() {
                _verificationId = verificationId;
              });
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 2),
          ));
          debugPrint(e.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No matching hashtag found'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('All fields are required to be filled'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      saveAndNavigate();
      debugPrint(
          'Signed in with ${userCredential.user?.phoneNumber.toString()}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 2),
      ));
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _hashtagController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<bool> checkForHashtag() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('entries')
        .where('hashtag', isEqualTo: _hashtagController.text)
        .get();
    return snapshot.size != 0;
  }

  //TODO - fix it - make it add to DB only once for unique guest, not on each login
  void saveAndNavigate() async {
    await FirebaseFirestore.instance.collection('guests').add({
      'name': _nameController.text,
      'contact': _phoneController.text,
      'userId': FirebaseAuth.instance.currentUser?.uid.toString(),
      'hashtag': _hashtagController.text
    }).whenComplete(() => model.setForGuest(_hashtagController.text, _nameController.text));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StoryView(
          storyItems: [
            StoryItem.pageVideo(
              'https://res.cloudinary.com/dz1lt2wwz/video/upload/v1706109689/Public/scenl4fut0qqlkmrsz8u.mp4',
              duration: Duration(seconds: (35.78195).toInt()),
              controller: controller,
            )
          ],
          controller: controller,
          repeat: false,
          onStoryShow: (storyItem) {},
          onComplete: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          progressPosition: ProgressPosition.none,
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  final controller = StoryController();
}
