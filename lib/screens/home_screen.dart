
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {

  // final Function(int) onButtonPressed;

  const HomeScreen({super.key
    // , required this.onButtonPressed
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.2,
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanmay weds Anika',
                  style: GoogleFonts.carattere(
                      textStyle: const TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic)
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('A match made in heaven', style: TextStyle(color: Colors.black ,fontSize: 12),),
                )
              ],
            ),
          ),
          persistentFooterAlignment: const AlignmentDirectional(0, 0),
          persistentFooterButtons: [
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
                  // widget.onButtonPressed(1);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const BlessingsScreen(),
                  //   ),
                  // );
                },
                child: const Text(
                  "Record my blessings",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }
}