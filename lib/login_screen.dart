import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // Future<bool> authenticate(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1C1E1F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Center(
              //   child: Image.asset('assets/splash.png',
              //     color: Colors.black,
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Vivah',
                    style: GoogleFonts.carattere(
                        textStyle: const TextStyle(color: Colors.black, fontSize: 75, fontStyle: FontStyle.italic)
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('Your wedding, personalised', style: TextStyle(color: Colors.black ,fontSize: 15),),
                  )
                ],
              ),
              const SizedBox(height: 10),
             const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('login as'),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginAsButton(persona: 'Bride'),
                  LoginAsButton(persona: 'Groom'),
                  LoginAsButton(persona: 'Guest'),
                ],
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 340,
                height: 50,
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: _fullNameController,
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
                    hintText: 'Enter your full name',
                    hintStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    hintMaxLines: 1,
                    labelText: 'Full Name',
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
              SizedBox(
                height: 50,
                width: 340,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD7B2E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MainScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                              // UserCredential? userCredential = await _signInWithGoogle();
                              // if (userCredential != null) {
                              //   print("Google Sign-In Success!");
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => MainScreen()),
                              //   );
                              // } else {
                              //   print("Google Sign-In Failed!");
                              // }
                            },
                            child: const ImageButton(imagePath: 'assets/google.png')),
                      ),
                      if(Platform.isIOS) const Expanded(child: ImageButton(imagePath: 'assets/apple.png'),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // TextButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //       builder: (context) => const SignupScreen()),
              //     // );
              //   },
              //   child: const Text(
              //     "Don't have an account?\nSign up now.",
              //     style: TextStyle(
              //       color: Colors.black,
              //       // decoration: TextDecoration.underline,
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginAsButton extends StatefulWidget {
  final String persona;
  const LoginAsButton({super.key, required this.persona});

  @override
  State<LoginAsButton> createState() => _LoginAsButtonState();
}

class _LoginAsButtonState extends State<LoginAsButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Handle click
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const CircleAvatar(backgroundColor: Color(0xFFD7B2E5), child: Icon(Icons.person, color: Colors.white,),),
            Text(widget.persona)
          ],
        ),
      ),
    )
    ;
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
          // color: const Color(0xFF1C1E1F),
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