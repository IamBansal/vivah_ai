import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'package:vivah_ai/screens/map_screens/select_location.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_button.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import '../../main_screen.dart';
import '../../models/ceremony.dart';
import '../auth/login/guest_login.dart';
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
    return Consumer<MainViewModel>(
      builder: (context, model, child) {
        return SafeArea(child: Scaffold(
              backgroundColor: const Color(0x0ffff7e2),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.2,
                automaticallyImplyLeading: false,
                toolbarHeight: 90,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.groom} weds ${model.bride}',
                      style: GoogleFonts.carattere(
                          textStyle: const TextStyle(
                              color: Color(0xFF33201C),
                              fontSize: 35,
                              fontStyle: FontStyle.italic)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'A match made in heaven',
                        style: TextStyle(color: Color(0xFF33201C), fontSize: 12),
                      ),
                    )
                  ],
                ),
                actions: const [
                  MyPopupMenuButton(),
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
                                    builder: (context) => const StoryScreen(
                                      filter: '',
                                    ))),
                          ),
                          HighlightItem(
                              title: 'Memories',
                              onItemPressed: (context) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StoryScreen(
                                          filter: 'photos',)))),
                          HighlightItem(
                              title: 'Blessings',
                              onItemPressed: (context) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StoryScreen(
                                          filter: 'blessings',
                                      )))),
                          HighlightItem(
                              title: 'Others',
                              onItemPressed: (context) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StoryScreen(
                                          filter: 'others',
                                      )))),
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
                                  color: Color(0xFF33201C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                          Visibility(
                              visible: model.isCouple,
                              child: IconButton(
                                  onPressed: () {
                                    showAddCeremonyDialog();
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFF33201C),
                                  )))
                        ],
                      ),
                      Visibility(
                        visible: model.ceremonyList.isNotEmpty,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: SizedBox(
                            height: double.infinity,
                            child: ListView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: model.ceremonyList.length,
                              itemBuilder: (context, index) {
                                return CeremonyItem(
                                  ceremony: model.ceremonyList[index], model: model,);
                              },
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
                              color: Color(0xFF33201C),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      const Center(
                        child: SizedBox(
                          height: 200,
                          width: 355,
                          // child: MyMap(showLocation: true,),
                          child: Text('acbecbow'),
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
                          'Vivah Album',
                          style: TextStyle(
                              color: Color(0xFF33201C),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      Visibility(
                        visible: model.photoList.isNotEmpty,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainScreen(isBrideGroom: model.isCouple, index: 2),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 170,
                            child: SizedBox(
                              height: double.infinity,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: model.photoList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        model.photoList[index].image,
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
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             MainScreen(isBrideGroom: model.isCouple, index: 2),
                      //       ),
                      //     );
                      //   },
                      //   child: Center(
                      //     child: Container(
                      //       height: 200,
                      //       width: 355,
                      //       color: Colors.grey,
                      //       child: const Center(
                      //           child: Text('Placeholder for vivah album')),
                      //     ),
                      //   ),
                      // ),
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
                          'Vivah bot',
                          style: TextStyle(
                              color: Color(0xFF33201C),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MainScreen(isBrideGroom: model.isCouple, index: 3),
                            ),
                          );
                        },
                        child: Center(
                          child: Container(
                            height: 200,
                            width: 355,
                            color: Colors.grey,
                            child:
                            const Center(child: Text('Placeholder for chat bot')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              persistentFooterAlignment: const AlignmentDirectional(0, 0),
              persistentFooterButtons: [
                CustomButton(
                  label: 'Record Blessing',
                  onButtonPressed: (context) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MainScreen(isBrideGroom: model.isCouple, index: 1),
                    ),
                  ),
                )
              ],
            ));
      }
    );
  }

  // late MainViewModel model;
  final firestore = FirebaseFirestore.instance;
  // String userId = '';
  // String bride = 'Bride';
  // String groom = 'Groom';
  // String hashtag = '';
  // bool isBrideGroom = false;

  // List<Ceremony> ceremonies = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // model = widget.;
    // _getHashTagAndId();
  }

  // Future<void> _getHashTagAndId() async {
  //   String? hash = await LocalData.getName();
  //   setState(() {
  //     hashtag = hash!;
  //   });
  //   // _getCeremonyList();
  //   // widget.model.getCeremonyList();
  //   debugPrint(hashtag);
  //
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
  //         .collection('entries')
  //         .where('hashtag', isEqualTo: hashtag)
  //         .limit(1)
  //         .get();
  //     if (snapshot.docs.isNotEmpty) {
  //       DocumentSnapshot<Map<String, dynamic>> firstEntry = snapshot.docs.first;
  //       Map<String, dynamic>? data = firstEntry.data();
  //       setState(() {
  //         bride = data!['bride'].toString();
  //         groom = data['groom'].toString();
  //         userId = data['userId'].toString();
  //       });
  //       await LocalData.saveNameAndId(bride, groom, userId);
  //
  //       bool isCouple = await ApiCalls.isCouple();
  //       setState(() {
  //         // isBrideGroom = isCouple;
  //       });
  //
  //       debugPrint('Found for bride groom');
  //     } else {
  //       debugPrint('No matching documents found for bride groom.');
  //     }
  //   } catch (error) {
  //     debugPrint('Error querying entries: $error');
  //   }
  // }

  // Future<void> _getCeremonyList() async {
  //   ceremonies.clear();
  //   ceremonies = await ApiCalls.getCeremonyList();
  // }

  void showAddCeremonyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const AddNewCeremony(),
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
    return Consumer<MainViewModel>(
        builder: (context, model, child){
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onItemPressed != null) {
                    widget.onItemPressed!(context);
                  }
                },
                onLongPress: () {
                  showMenu(
                    context: context,
                    position: calculatePosition(),
                    items: [
                      PopupMenuItem(
                        value: 'edit',
                        onTap: () async {
                          String path =
                          (await ApiCalls.getImage(ImageSource.gallery))!;
                          ApiCalls.uploadThumbnail(path, widget.title).whenComplete(
                                  () => ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text('Thumbnail updated successfully'))));
                        },
                        child: const Text('Edit thumbnail'),
                      ),
                      PopupMenuItem(
                        value: 'upload',
                        onTap: () async {
                          String path =
                          (await ApiCalls.getImage(ImageSource.gallery))!;
                          ApiCalls.uploadPhoto(path, 'Memory').whenComplete(() =>
                          model.getPhotoList().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Memory uploaded successfully')))));
                        },
                        child: const Text('Upload memory'),
                      ),
                    ],
                  );
                },
                child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF713C05), width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipOval(
                          child: thumbnailPath.isNotEmpty
                              ? Image.network(
                            thumbnailPath,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                              : Image.asset(
                            'assets/pic.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )),
                    )),
              ),
              Text(
                widget.title,
                style: const TextStyle(color: Color(0xFF33201C)),
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _getThumbnail();
  }

  RelativeRect calculatePosition() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var screenSize = MediaQuery.of(context).size;
    var position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + renderBox.size.height,
      screenSize.width - offset.dx - renderBox.size.width,
      screenSize.height - offset.dy,
    );
    return position;
  }

  String thumbnailPath = '';

  void _getThumbnail() async {
    String path = await ApiCalls.getThumbnail(widget.title);
    setState(() {
      thumbnailPath = path;
    });
  }
}

class AddNewCeremony extends StatefulWidget {
  const AddNewCeremony({super.key});

  @override
  State<AddNewCeremony> createState() => _AddNewCeremonyState();
}

class _AddNewCeremonyState extends State<AddNewCeremony> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
        builder: (context, model, child) {
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
                                          color: Color(0xFF33201C)),
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
                                        color: Color(0xFF33201C),
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
                                    color: const Color(0xFF4F2E22), width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: imagePath.isNotEmpty
                                  ? CircleAvatar(
                                backgroundImage: FileImage(File(imagePath)),
                                radius: 50.0,
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
                      icon: Icons.location_on_outlined,
                      expand: true,
                      onIconTap: (context) => showSelectLocationDialog(),
                      // onIconTap: (context) => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const MyMap(showLocation: false),
                      //   ),
                      // ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldWithIcon(
                      controller: _dateController,
                      label: 'Date',
                      hint: 'Ceremony Date',
                      icon: Icons.calendar_today,
                      expand: false,
                      onIconTap: (context) async => {
                        _dateController.text = (await ApiCalls.selectDate(context))!
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 20),
                    Center(
                        child: CustomButton(
                            label: buttonText,
                            onButtonPressed: (context) => {
                              if (_titleController.text.isNotEmpty &&
                                  _descController.text.isNotEmpty &&
                                  imagePath.isNotEmpty &&
                                  _dateController.text.isNotEmpty &&
                                  _locationController.text.isNotEmpty)
                                {saveToDB()}
                            })),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
  }

  void showSelectLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const MyMap(
                showLocation: false,
              )),
        );
      },
    );
  }

  void getCurrentLocation() async {
    String address = await ApiCalls.getCurrentPosition(context);
    setState(() {
      _locationController.text = address;
    });
  }

  String buttonText = 'Add ceremony';
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
    setState(() {
      buttonText = 'Adding ceremony....';
    });
    model.saveCeremonyToDB(imagePath, _titleController.text, _descController.text,
            _locationController.text, _dateController.text)
        .whenComplete(() => Navigator.of(context).pop());
    setState(() {
      buttonText = 'Add ceremony';
    });
  }
}

class CeremonyItem extends StatefulWidget {
  final Ceremony ceremony;
  final MainViewModel model;

  const CeremonyItem({super.key, required this.ceremony, required this.model});

  @override
  State<CeremonyItem> createState() => _CeremonyItemState();
}

class _CeremonyItemState extends State<CeremonyItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.model.ceremony = widget.ceremony;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CeremonyScreen(model: widget.model)),
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF33201C)),
              ),
            ),
            Text(
              widget.ceremony.description,
              style: const TextStyle(
                  overflow: TextOverflow.ellipsis, color: Color(0xFF620600)),
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class MyPopupMenuButton extends StatelessWidget {
  const MyPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Color(0xFF33201C),
      ),
      onSelected: (String result) {
        handleMenuItemSelected(result, context);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                color: Color(0xFF33201C),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Sign out',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> handleMenuItemSelected(
      String value, BuildContext context) async {
    switch (value) {
      case 'logout':
        await FirebaseAuth.instance
            .signOut()
            .whenComplete(() => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const GuestLogin()),
                  (route) => false,
                ))
            .onError((error, stackTrace) => debugPrint(error.toString()));
        break;
    }
  }
}
