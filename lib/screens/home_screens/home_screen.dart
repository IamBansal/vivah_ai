import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'package:vivah_ai/providers/shared_pref.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import '../../models/ceremony.dart';
import '../auth/login_screen.dart';
import 'ceremony_screen.dart';
import 'highlights_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HighlightItem(
                    title: 'Our story',
                    onItemPressed: (context) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoryScreen())),
                  ),
                  HighlightItem(
                      title: 'Memories',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen()))),
                  HighlightItem(
                      title: 'Blessings',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen()))),
                  HighlightItem(
                      title: 'Others',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen()))),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Visibility(
                      visible: isBrideGroom,
                      child: IconButton(
                          onPressed: () {
                            showAddCeremonyDialog();
                          },
                          icon: const Icon(Icons.add)))
                ],
              ),
              Visibility(
                visible: ceremonies.isNotEmpty,
                child: SizedBox(
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
                            itemCount: ceremonies.length,
                            itemBuilder: (context, index) {
                              return CeremonyItem(ceremony: ceremonies[index]);
                            },
                          ),
                        ),
                      ],
                    ),
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  String userId = '';
  String bride = 'Bride';
  String groom = 'Groom';
  String hashtag = '';
  bool isBrideGroom = false;
  List<Ceremony> ceremonies = [];

  @override
  void initState() {
    super.initState();
    _getHashTagAndId();
  }

  Future<void> _getHashTagAndId() async {
    String? hash = await LocalData.getName();
    setState(() {
      hashtag = hash!;
    });
    _getCeremonyList();
    debugPrint(hashtag);

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
          userId = data['userId'].toString();
        });
        await LocalData.saveNameAndId(bride, groom, userId);

        bool isCouple = await ApiCalls.isCouple();
        setState(() {
          isBrideGroom = isCouple;
        });

        debugPrint('Found for bride groom');
      } else {
        debugPrint('No matching documents found for bride groom.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  Future<void> _getCeremonyList() async {
    ceremonies.clear();
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('ceremonies')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          setState(() {
            ceremonies.add(Ceremony.fromMap(data!));
          });
        }
        debugPrint('Found the ceremony');
      } else {
        debugPrint('No matching documents found for ceremonies.');
      }
    } catch (error) {
      debugPrint('Error querying entries: $error');
    }
  }

  void showAddCeremonyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: AddNewCeremony(userId: userId, hashtag: hashtag),
        );
      },
    );
  }
}

class HighlightItem extends StatefulWidget {
  final String title;
  final Function(BuildContext)? onItemPressed;

  const HighlightItem(
      {super.key, required this.title, required this.onItemPressed});

  @override
  State<HighlightItem> createState() => _HighlightItemState();
}

class _HighlightItemState extends State<HighlightItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onItemPressed != null) {
              widget.onItemPressed!(context);
            }
          },
          child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD7B2E5), width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipOval(
                    child: Image.asset(
                  'assets/pic.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )),
              )),
        ),
        Text(
          widget.title,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class AddNewCeremony extends StatefulWidget {
  final String userId;
  final String hashtag;

  const AddNewCeremony(
      {super.key, required this.userId, required this.hashtag});

  @override
  State<AddNewCeremony> createState() => _AddNewCeremonyState();
}

class _AddNewCeremonyState extends State<AddNewCeremony> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: Colors.transparent,
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera,
                                    color: Color(0xFF5271EF)),
                                title: const Text('Take Photo'),
                                onTap: () async {
                                  Navigator.pop(
                                      context); // Close the bottom sheet
                                  String path = (await ApiCalls.getImage(
                                      ImageSource.camera))!;
                                  setState(() {
                                    imagePath = path;
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.photo_library,
                                  color: Color(0xFF5271EF),
                                ),
                                title: const Text('Choose from Gallery'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  String path = (await ApiCalls.getImage(
                                      ImageSource.gallery))!;
                                  setState(() {
                                    imagePath = path;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF5271EF), width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: imagePath.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: FileImage(File(imagePath)),
                                radius: 50.0,
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                color: Color(0xFF5271EF),
                              ),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Ceremony Title',
                  expand: false),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: _descController,
                  label: 'Description',
                  hint: 'Ceremony Description',
                  expand: true),
              const SizedBox(height: 20),
              CustomTextFieldWithIcon(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'Ceremony Location',
                  icon: const Icon(Icons.location_on_outlined, color: Color(0xFFD7B2E5)),
                  expand: true,
              onIconTap: (context) => null,
              keyboardType: TextInputType.text,),
              const SizedBox(height: 20),
              CustomTextFieldWithIcon(
                controller: _dateController,
                label: 'Date',
                hint: 'Ceremony Date',
                icon:
                    const Icon(Icons.calendar_today, color: Color(0xFFD7B2E5)),
                expand: false,
                onIconTap: (context) async => {
                  _dateController.text = (await ApiCalls.selectDate(context))!
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 320.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD7B2E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_titleController.text.isNotEmpty &&
                          _descController.text.isNotEmpty &&
                          imagePath.isNotEmpty &&
                          _dateController.text.isNotEmpty &&
                          _locationController.text.isNotEmpty) {
                        saveToDB();
                        setState(() {
                          buttonText = 'Adding the ceremony.....';
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        buttonText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String buttonText = 'Add the ceremony';
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _dateController.dispose();
  }

  String imagePath = '';

  Future<void> saveToDB() async {
    String url = (await ApiCalls.uploadImageToCloudinary(imagePath))!;
    try {
      await FirebaseFirestore.instance
          .collection('ceremonies')
          .add(Ceremony(
                  title: _titleController.text,
                  description: _descController.text,
                  url: url,
                  location: _locationController.text,
                  date: _dateController.text,
                  userId: widget.userId,
                  hashtag: widget.hashtag)
              .toMap())
          .whenComplete(() => Navigator.of(context).pop());
      setState(() {
        buttonText = 'Add the ceremony';
      });
      debugPrint('Ceremony added');
    } catch (e) {
      debugPrint('Error adding guest to Firestore: $e');
    }
  }
}

class CeremonyItem extends StatefulWidget {
  final Ceremony ceremony;

  const CeremonyItem({super.key, required this.ceremony});

  @override
  State<CeremonyItem> createState() => _CeremonyItemState();
}

class _CeremonyItemState extends State<CeremonyItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CeremonyScreen(ceremony: widget.ceremony)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.ceremony.url,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.ceremony.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              widget.ceremony.description,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, color: Colors.grey),
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
