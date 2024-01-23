import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/screens/auth/login/guest_login.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'main_screen.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider(
        create: (context) => MainViewModel(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainViewModel())
      ],
      child: Consumer<MainViewModel>(
          builder: (context, model, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                textTheme: GoogleFonts.openSansTextTheme(),
              ),
              home: const SplashScreen(),
            );
          }
      )
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('couple').where('id', isEqualTo : user.uid).get();

      if(snapshot.size == 0) {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        });
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            //TODO - CHANGE THIS isBrideGroom
            MaterialPageRoute(builder: (context) => const MainScreen()),
            // MaterialPageRoute(builder: (context) => const InitialDetails()),
          );
        });
      }

      debugPrint("User is logged in: ${user.email} ${user.phoneNumber}");
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GuestLogin()),
        );
      });
      debugPrint("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Shader-mask if for adding a black blend behind text
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.black45],
                stops: [0.0, 1],
              ).createShader(bounds);
            },
            child: ClipRRect(
                child: Image.asset(
                  'assets/vivah.jpg',
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.26,
            top: MediaQuery.of(context).size.height * 0.4,
            child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vivah',
                    style: GoogleFonts.carattere(
                        textStyle: const TextStyle(color: Colors.white, fontSize: 90, fontStyle: FontStyle.italic)
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('Your wedding, personalised', style: TextStyle(color: Colors.white ,fontSize: 15 ,fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),),
        ],
      ),
    );
  }
}