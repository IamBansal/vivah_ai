// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vivah_ai/models/photo.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_button.dart';
import '../providers/shared_pref.dart';

class VivahPhotosScreen extends StatefulWidget {
  const VivahPhotosScreen({super.key});

  @override
  State<VivahPhotosScreen> createState() => _VivahPhotosScreenState();
}

class _VivahPhotosScreenState extends State<VivahPhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      // filteredPhotoList = model.photoList.where((item) => item.category != 'Memory').toList();
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
                'Vivah Album',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Color(0xFF33201C),
                        fontSize: 35,
                        fontStyle: FontStyle.italic)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'All occasions in one gallery',
                  style: TextStyle(color: Color(0xFF33201C), fontSize: 12),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
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
                            _selectedChipIndex == 0
                                ? filteredPhotoList = model.photoList
                                    .where((item) => item.category != 'Memory')
                                    .toList()
                                : filteredPhotoList = model.photoList
                                    .where((item) => item.category != 'Memory')
                                    .toList()
                                    .where((item) =>
                                        item.category ==
                                        _options[_selectedChipIndex])
                                    .toList();
                          });
                        },
                        selectedColor: const Color(0xFF713C05),
                        backgroundColor: const Color(0xFFC58D80),
                        labelStyle: const TextStyle(color: Colors.white),
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
                                  color: Color(0xFF33201C)),
                              title: const Text('Take Photo'),
                              onTap: () async {
                                Navigator.pop(
                                    context); // Close the bottom sheet
                                String path = (await ApiCalls.getImage(
                                    ImageSource.camera))!;
                                await LocalData.saveImage(path);
                                setState(() {
                                  imagePath = path;
                                });
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.photo_library,
                                color: Color(0xFF33201C),
                              ),
                              title: const Text('Choose from Gallery'),
                              onTap: () async {
                                Navigator.pop(context);
                                String path = (await ApiCalls.getImage(
                                    ImageSource.gallery))!;
                                await LocalData.saveImage(path);
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
                model.isCouple
                    ? '${model.bride} | ${model.groom}'
                    : model.guestName,
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Color(0xFF713C05),
                        fontSize: 40,
                        fontStyle: FontStyle.italic)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Text(
                  'Save your favorite moments to your gallery or upload some future-worthy clicks for everyone!',
                  style: TextStyle(color: Color(0xFF713C05)),
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
                        style: TextStyle(color: Color(0xFF33201C)),
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
                        style: TextStyle(color: Color(0xFF33201C)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Handle solo of images
                      },
                      child: const Text(
                        'Your photos',
                        style: TextStyle(color: Color(0xFF33201C)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 5,
                color: Colors.grey,
              ),
              filteredPhotoList.isNotEmpty
                  ? SizedBox(
                      height: filteredPhotoList.length % 3 == 0
                          ? ((filteredPhotoList.length / 3)) * 150
                          : ((filteredPhotoList.length / 3) + 1) * 120,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        itemCount: filteredPhotoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GridTile(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoViewScreen(
                                          url: filteredPhotoList[index].image)),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2.0),
                                color: Colors.white30,
                                child: Center(
                                  child: Image.network(
                                    filteredPhotoList[index].image,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'No ${_options[_selectedChipIndex]} photos for now'),
                    )
            ],
          ),
        ),
      ));
    });
  }

  final List<String> _options = [
    'All events',
    'Haldi',
    'Ladies Sangeet',
    'Mehndi',
    'Wedding'
  ];
  static const List<String> list = <String>[
    'Wedding',
    'Haldi',
    'Mehndi',
    'Ladies Sangeet',
  ];
  ScrollController scrollController = ScrollController();
  int _selectedChipIndex = 0;
  String imagePath = '';
  String imagePathForDialog = '';
  String photoCategory = list.first;
  String buttonText = 'Upload the photo';
  List<PhotoItem> filteredPhotoList = [];

  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
      filteredPhotoList =
          model.photoList.where((item) => item.category != 'Memory').toList();
    });
    _getImageAndName();
  }

  void _getImageAndName() async {
    String path = await LocalData.getImage() ?? '';

    setState(() {
      imagePath = path;
    });
  }

  void saveToDB() {
    setState(() {
      buttonText = 'Uploading the photo.....';
    });
    model
        .savePhotoToDB(imagePathForDialog, photoCategory)
        .whenComplete(() => setState(() {
              filteredPhotoList = model.photoList
                  .where((item) => item.category != 'Memory')
                  .toList();
              _selectedChipIndex = 0;
              buttonText = 'Upload the photo';
              Navigator.of(context).pop();
            }));
  }

  void showUploadPhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: MediaQuery.of(context1).size.height * 0.5,
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
                          context: context1,
                          builder: (BuildContext context2) {
                            return Container(
                              color: Colors.transparent,
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera,
                                        color: Color(0xFF33201C)),
                                    title: const Text('Take Photo'),
                                    onTap: () async {
                                      Navigator.pop(
                                          context2); // Close the bottom sheet
                                      String path = (await ApiCalls.getImage(
                                          ImageSource.camera))!;
                                      setState(() {
                                        imagePathForDialog = path;
                                      });
                                      Navigator.of(context1).pop();
                                      showUploadPhotoDialog();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.photo_library,
                                      color: Color(0xFF33201C),
                                    ),
                                    title: const Text('Choose from Gallery'),
                                    onTap: () async {
                                      Navigator.pop(context2);
                                      String path = (await ApiCalls.getImage(
                                          ImageSource.gallery))!;
                                      setState(() {
                                        imagePathForDialog = path;
                                      });
                                      Navigator.of(context1).pop();
                                      showUploadPhotoDialog();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFF33201C), width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: imagePathForDialog.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        FileImage(File(imagePathForDialog)),
                                    radius: 5.0,
                                  )
                                : const Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xFF33201C),
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
                        borderSide: const BorderSide(color: Color(0xFF33201C)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFF33201C)),
                      ),
                    ),
                    dropdownMenuEntries:
                        list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: CustomButton(
                    label: buttonText,
                    onButtonPressed: (context) => {
                      if (imagePathForDialog.isNotEmpty) {saveToDB()}
                    },
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PhotoViewScreen extends StatefulWidget {
  final String url;

  const PhotoViewScreen({super.key, required this.url});

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFF2F1F19),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      ApiCalls.shareDownloadInvite(
                          _screenshotController, false, context);
                    },
                    icon: const Icon(Icons.file_upload_outlined,
                        color: Color(0xFFFFD384))),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      ApiCalls.shareDownloadInvite(
                          _screenshotController, true, context);
                    },
                    icon: const Icon(Icons.file_download_outlined,
                        color: Color(0xFFFFD384))),
              ],
            ),
            Screenshot(
              controller: _screenshotController,
              child: PhotoView(
                tightMode: true,
                enableRotation: true,
                disableGestures: false,
                imageProvider: NetworkImage(widget.url),
                customSize: MediaQuery.of(context).size,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: const BoxDecoration(
                  color: Color(0xFF33201C),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  final ScreenshotController _screenshotController = ScreenshotController();
}
