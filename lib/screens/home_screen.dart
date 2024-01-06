import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/providers/shared_pref.dart';

import '../widgets/custom_button.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  // final Function(int) onButtonPressed;

  const HomeScreen({super.key
      // , required this.onButtonPressed
      });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String userId = '';
  String bride = 'Bride';
  String groom = 'Groom';

  @override
  void initState() {
    super.initState();
    _getHashTagAndId();
  }

  Future<void> _getHashTagAndId() async {
    // await LocalData.saveName('#AniKaTanmay');
    String? hashtag = await LocalData.getName();
    // List<String>? list = await LocalData.getNameAndId();
    //
    // setState(() {
    //   bride = list![0];
    //   groom = list[1];
    //   userId = list[2];
    // });
    print(hashtag);

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('entries')
          .where('hashtag', isEqualTo: hashtag)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> firstEntry = snapshot.docs.first;
        Map<String, dynamic>? data = firstEntry.data();
        setState(() {
          bride = data!['bride'].toString();
          groom = data['groom'].toString();
          userId = data['id'].toString();
        });
        await LocalData.saveNameAndId(bride, groom, userId);
        debugPrint('Found');
      } else {
        debugPrint('No matching documents found.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

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
              '$groom weds $bride',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontStyle: FontStyle.italic)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'A match made in heaven',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await _auth
                    .signOut()
                    .whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false,
                        ));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      persistentFooterAlignment: const AlignmentDirectional(0, 0),
      persistentFooterButtons: [
        CustomButton(
          label: 'Record my blessings',
          onButtonPressed: (context) => null,
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD7B2E5), width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Stack(
                              children: [
                                ClipOval(
                                    child: Image.asset(
                                  'assets/pic.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ))
                              ],
                            ),
                          )),
                      const Text(
                        'Our story',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD7B2E5), width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Stack(
                              children: [
                                ClipOval(
                                    child: Image.asset(
                                  'assets/pic.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ))
                              ],
                            ),
                          )),
                      const Text(
                        'Memories',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFD7B2E5), width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Stack(
                              children: [
                                ClipOval(
                                    child: Image.asset(
                                  'assets/pic.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ))
                              ],
                            ),
                          )),
                      const Text(
                        'Blessings',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Ceremonies',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        // width: MediaQuery.of(context).size.width * 1.5,
                        width: 400,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              width: 150,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(2.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/pic.png',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Roka',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Text(
                                    'hsvcwubcowbcwicoiwbvwnvowvcbskejbqcboqbcoqibcq',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.grey),
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Venue on Maps',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
              Center(
                child: Container(
                  height: 200,
                  width: 355,
                  color: Colors.grey,
                  child:
                      const Center(child: Text('Placeholder for google maps')),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
