import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/screens/auth/login/guest_login.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'firebase_options.dart';
import 'main_screen.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  if(!kIsWeb) await FlutterConfig.loadEnvVariables();
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        home: Consumer<MainViewModel>(
            builder: (context, model, child) {
              return const SplashScreen();
            }
        ),
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

  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('entries').where('userId', isEqualTo : user.uid).get();
      if(snapshot.size == 0){
        QuerySnapshot<Map<String, dynamic>> snapshotGuest = await firestore.collection('guests').where('userId', isEqualTo : user.uid).limit(1).get();
        if(snapshotGuest.size != 0) {
          final data = snapshotGuest.docs[0].data();
          model.setForGuest(data['hashtag'], data['name']);
          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()), //Guest
            );
          });
          debugPrint("User is logged in as guest with: ${user.phoneNumber}");
        } else {
          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GuestLogin()),
            );
          });
          debugPrint("User is not logged in");
        }
      } else {
        final data = snapshot.docs[0].data();
        model.setForCouple(data['hashtag'], data['bride'], data['groom']);
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()), //Guest
          );
        });
        debugPrint("User is logged in as couple with: ${user.email}");
      }
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