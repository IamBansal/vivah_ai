
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/custom_button.dart';

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
            CustomButton(label: 'Record my blessings', onButtonPressed: (context) => null,)
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
                                  border: Border.all(color: const Color(0xFFD7B2E5), width: 1)),
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
                              )
                          ),
                          const Text('Our story', style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFD7B2E5), width: 1)),
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
                              )
                          ),
                          const Text('Memories', style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFD7B2E5), width: 1)),
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
                              )
                          ),
                          const Text('Blessings', style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(thickness: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Ceremonies', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
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
                                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
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
                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text('Roka', style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      const Text('hsvcwubcowbcwicoiwbvwnvowvcbskejbqcboqbcoqibcq', style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.grey), maxLines: 2,)
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
                    child: Divider(thickness: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Venue on Maps', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
                  ),
                  Center(
                    child: Container(
                      height: 200,
                      width: 355,
                      color: Colors.grey,
                      child: const Center(child: Text('Placeholder for google maps')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}