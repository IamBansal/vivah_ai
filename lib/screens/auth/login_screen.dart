import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/providers/shared_pref.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import 'dart:io';
import '../../main_screen.dart';
import '../../widgets/custom_button.dart';
import 'initial_details.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    _hashtagController.text = '#';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Vivah',
                    style: GoogleFonts.carattere(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 75,
                            fontStyle: FontStyle.italic)),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Your wedding, personalised',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('login as'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBrideGroom = true;
                        });
                      },
                      child: LoginAsButton(
                          persona: 'Bride/Groom', isBrideGroom: _isBrideGroom)),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBrideGroom = false;
                        });
                      },
                      child: LoginAsButton(
                          persona: 'Guest', isBrideGroom: !_isBrideGroom)),
                ],
              ),
              const SizedBox(height: 35),
              Visibility(
                visible: _isBrideGroom,
                child: Column(
                  children: [
                    SizedBox(
                      width: 340,
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFDFDFDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Enter your email',
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          hintMaxLines: 1,
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 340,
                      height: 50,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFDFDFDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          hintMaxLines: 1,
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomButton(
                        label: 'Login',
                        onButtonPressed: (context) => _isBrideGroom
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InitialDetails(),
                                ),
                              )
                            : saveAndNavigate()),
                  ],
                ),
              ),
              Visibility(
                visible: !_isBrideGroom,
                child: Column(
                  children: [
                    SizedBox(
                      width: 340,
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFDFDFDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Enter your name',
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          hintMaxLines: 1,
                          labelText: 'Name',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 340,
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFDFDFDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Enter your phone number',
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          hintMaxLines: 1,
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 340,
                      height: 50,
                      child: TextField(
                        controller: _hashtagController,
                        // obscureText: _obscureText,
                        decoration: InputDecoration(
                          fillColor: const Color(0xFFDFDFDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Enter wedding hashtag',
                          hintStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          hintMaxLines: 1,
                          labelText: 'Wedding Hashtag',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          // suffixIcon: IconButton(
                          //   icon: Icon(
                          //     _obscureText ? Icons.visibility : Icons.visibility_off,
                          //     color: Colors.black,
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       _obscureText = !_obscureText;
                          //     });
                          //   },
                          // ),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                        visible: !_verificationId.isNotEmpty,
                        child: CustomButton(
                          label: 'Send OTP',
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
                              hint: 'Enter OTP'),
                          InkWell(
                              onTap: verifyPhoneNumber,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Resend OTP?'),
                              )),
                          const SizedBox(height: 10),
                          CustomButton(
                            label: 'Verify OTP and Login...',
                            onButtonPressed: (context) =>
                                signInWithPhoneNumber(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Visibility(
                  visible: _isBrideGroom,
                  child: Column(
                    children: [
                      const Text(
                        "or log in with",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    onTap: () async {
                                      await _signInWithGoogle();
                                    },
                                    child: const ImageButton(
                                        imagePath: 'assets/google.png')),
                              ),
                              if (Platform.isIOS)
                                const Expanded(
                                  child: ImageButton(
                                      imagePath: 'assets/apple.png'),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _obscureText = true;
  bool _isBrideGroom = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> authenticate(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  String _verificationId = '';

  Future<void> verifyPhoneNumber() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _hashtagController.text.isNotEmpty &&
        _hashtagController.text.startsWith('#')) {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: '+91${_phoneController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
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
        content: Text('Check for the inputs and hashtags (Hashtag must start with #)'),
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
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final firestore = FirebaseFirestore.instance;

      await firestore.collection('couple').add({
        'id': userCredential.user?.uid,
        'email': userCredential.user!.email.toString(),
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('entries')
          .where('userId', isEqualTo: userCredential.user?.uid.toString())
          .get();

      if (snapshot.size == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InitialDetails()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen(isBrideGroom: true)),
        );
      }
    } catch (e) {
      debugPrint("Google Sign-In Failed: $e");
      return null;
    }
    return null;
  }

  Future<bool> checkForHashtag() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('entries')
        .where('hashtag', isEqualTo: _hashtagController.text)
        .get();
    return snapshot.size != 0;
  }

  void saveAndNavigate() async {
    if (await checkForHashtag()) {
      await LocalData.saveGuestName(_nameController.text);
      await LocalData.saveName(_hashtagController.text)
          .whenComplete(() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(isBrideGroom: false),
                ),
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No matching hashtag found'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}

class LoginAsButton extends StatefulWidget {
  final String persona;
  final bool isBrideGroom;

  const LoginAsButton(
      {super.key, required this.persona, required this.isBrideGroom});

  @override
  State<LoginAsButton> createState() => _LoginAsButtonState();
}

class _LoginAsButtonState extends State<LoginAsButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFD7B2E5),
            child: Icon(
              Icons.person,
              color: widget.isBrideGroom ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.persona,
            style: TextStyle(
                fontWeight:
                    widget.isBrideGroom ? FontWeight.bold : FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String imagePath;

  const ImageButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Image.asset(
          imagePath,
          width: 25,
          height: 40,
        ),
      ),
    );
  }
}
