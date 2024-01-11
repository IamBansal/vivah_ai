import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivah_ai/providers/api_calls.dart';

class VivahPhotosScreen extends StatefulWidget {
  const VivahPhotosScreen({super.key});

  @override
  State<VivahPhotosScreen> createState() => _VivahPhotosScreenState();
}

class _VivahPhotosScreenState extends State<VivahPhotosScreen> {

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
              'Vivah Photos',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontStyle: FontStyle.italic)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'All occasions in one gallery',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List<Widget>.generate(
                _options.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(_options[index]),
                    selected: _selectedChipIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedChipIndex = selected ? index : -1;
                        _options[_selectedChipIndex];
                      });
                    },
                    selectedColor: const Color(0xFFD7B2E5),
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.black),
                  );
                },
              ).toList(),
            ),
          ),
          GestureDetector(
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
                            Navigator.pop(context); // Close the bottom sheet
                            String path =
                                (await ApiCalls.getImage(ImageSource.camera))!;
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
                            String path =
                                (await ApiCalls.getImage(ImageSource.gallery))!;
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20, 0, 10),
              child: ClipOval(
                  child: imagePath.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(imagePath)),
                          radius: 75.0,
                        )
                      : Image.asset(
                          'assets/pic.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Anika',
            style: GoogleFonts.carattere(
                textStyle: const TextStyle(
                    color: Color(0xFF5D2673),
                    fontSize: 40,
                    fontStyle: FontStyle.italic)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Text(
              'Save your favorite moments to your gallery or upload some future-worthy clicks for everyone!',
              style: TextStyle(color: Color(0xFF9B40BF)),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {
                showUploadPhotoDialog();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_upload_outlined),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    //Handle All of images
                  },
                  child: const Text(
                    'All Photos',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //Handle solo of images
                  },
                  child: const Text(
                    'Your photos',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 5,
            color: Colors.grey,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Disable GridView's scrolling
                  children: List.generate(
                    12,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.all(2.0),
                        color: Colors.blue,
                        child: Center(
                          child: Image.asset(
                            'assets/pic.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  void showUploadPhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
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
                                        imagePathForDialog = path;
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
                                        imagePathForDialog = path;
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
                            child: imagePathForDialog.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(imagePathForDialog)),
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
                  DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      setState(() {
                        photoCategory = value!;
                      });
                    },
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                        const BorderSide(color: Color(0xFF5271EF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                        const BorderSide(color: Color(0xFF5271EF)),
                      ),
                    ),
                    dropdownMenuEntries: list
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  Center(
                    child: SizedBox(
                      width: 250.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD7B2E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          if (imagePathForDialog.isNotEmpty) {
                            setState(() {
                              buttonText = 'Uploading the photo.....';
                            });
                            saveToDB();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            buttonText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
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
      },
    );
  }

  int _selectedChipIndex = 0;
  final List<String> _options = [
    'All events',
    'Haldi Ceremony',
    'Ladies Sangeet',
    'Mehndi',
    'Wedding'
  ];
  String imagePath = '';
  String imagePathForDialog = '';

  static const List<String> list = <String>[
    'Wedding',
    'Haldi',
    'Mehndi',
    'Ladies Sangeet',
  ];
  String photoCategory = list.first;
  String buttonText = 'Upload the photo';

  Future<void> saveToDB() async {

    //TODO - IMPLEMENT THIS

    // String url = (await ApiCalls.uploadImageToCloudinary(imagePath))!;
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('ceremonies')
    //       .add()
    //       .whenComplete(() => Navigator.of(context).pop());
      setState(() {
        buttonText = 'Add the ceremony';
      });
    //   debugPrint('Ceremony added');
    // } catch (e) {
    //   debugPrint('Error adding guest to Firestore: $e');
    // }
  }
}
