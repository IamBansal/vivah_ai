import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../main_screen.dart';
import '../../../viewmodels/main_view_model.dart';
import '../../../widgets/custom_button.dart';
import '../initial_details.dart';
import 'guest_login.dart';

class CoupleLogin extends StatefulWidget {
  const CoupleLogin({super.key});

  @override
  State<CoupleLogin> createState() => _CoupleLoginState();
}

class _CoupleLoginState extends State<CoupleLogin> {
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
              SizedBox(
                width: 340,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Color(0xFF33201C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Color(0xFF33201C)),
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
                  style: const TextStyle(color: Color(0xFF33201C)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 340,
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFDFDFDF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Color(0xFF33201C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(color: Color(0xFF33201C)),
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF33201C),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Color(0xFF33201C)),
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                  label: 'Login',
                  onButtonPressed: (context) => signUpOrLoginWithEmail()),
              const SizedBox(height: 40),
              const Text(
                "or log in with",
                style: TextStyle(color: Color(0xFF33201C)),
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
                          child: ImageButton(imagePath: 'assets/apple.png'),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GuestLogin()),
                    );
                  },
                  child: const Text(
                    "Log in as guest",
                    style: TextStyle(color: Color(0xFF33201C)),
                  ),
                ),
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

      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('entries')
          .where('userId', isEqualTo: userCredential.user?.uid.toString())
          .get();

      if (snapshot.size == 0) {
        await firestore.collection('couple').add({
          'id': userCredential.user?.uid,
          'email': userCredential.user!.email.toString(),
        }).whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InitialDetails()),
            ));
      } else {
        await getMainDetails().whenComplete(() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            ));
      }
    } catch (e) {
      debugPrint("Google Sign-In Failed: $e");
      return null;
    }
    return null;
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpOrLoginWithEmail() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      try {
        final firestore = FirebaseFirestore.instance;

        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('entries')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (snapshot.size == 0) {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          await firestore.collection('couple').add({
            'id': userCredential.user?.uid,
            'email': _emailController.text,
          }).whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InitialDetails()),
              ));
        } else {
          debugPrint('Old user..Logging in');
          UserCredential cred = await _auth
              .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              )
              .whenComplete(() async => await getMainDetails().whenComplete(
                  () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()))));
          debugPrint('Logged in with ${cred.user?.uid}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 2),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fill all fields first'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> getMainDetails() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('entries')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = snapshot.docs[0].data();
      model.setForCouple(data['hashtag'], data['bride'], data['groom']);
      debugPrint('Fetched: $data');
    } catch (e) {
      debugPrint('Error: $e in fetching main details');
    }
  }

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            color: const Color(0xFF33201C), // Border color
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
