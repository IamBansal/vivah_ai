import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'package:vivah_ai/screens/map_screens/select_location.dart';
import 'package:vivah_ai/screens/terms_and_policy.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_button.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import '../../models/ceremony.dart';
import '../auth/login/guest_login.dart';
import '../info_screen.dart';
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
    return Consumer<MainViewModel>(builder: (context, model, child) {
      return SafeArea(
          child: Scaffold(
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
                      title: 'Story',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen(
                                    filter: 'story',
                                  ))),
                      enable: model.storyList.isNotEmpty,
                    ),
                    HighlightItem(
                      title: 'Memories',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen(
                                    filter: 'photos',
                                  ))),
                      enable: model.photoList.isNotEmpty,
                    ),
                    HighlightItem(
                      title: 'Blessings',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen(
                                    filter: 'blessings',
                                  ))),
                      enable: model.blessingList.isNotEmpty,
                    ),
                    HighlightItem(
                      title: 'Others',
                      onItemPressed: (context) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StoryScreen(
                                    filter: 'others',
                                  ))),
                      enable: model.ceremonyList.isNotEmpty,
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
                            ceremony: model.ceremonyList[index],
                            model: model,
                          );
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
                    child: MyMap(
                      showLocation: true,
                    ),
                    // child: Text('n'),
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
                Center(
                  child: GestureDetector(
                    onTap: () {
                      model.setTabIndex(2);
                    },
                    child: SizedBox(
                      // height: 350,
                      // width: MediaQuery.of(context).size.width,
                      child: model.photoList.isNotEmpty
                          ? GridView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: model.photoList.length <= 3
                                  ? model.photoList.length + 1
                                  : 4,
                              itemBuilder: (context, index) {
                                return (index == 3 ||
                                        index == model.photoList.length)
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: const Color(0xFFFBEDEA)),
                                        margin: const EdgeInsets.all(5),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 150,
                                        child: const Icon(Icons.add),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            model.photoList[index].image,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Add some cool photos man!!'),
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
                    'Vivah Guide',
                    style: TextStyle(
                        color: Color(0xFF33201C),
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    model.setTabIndex(3);
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFFBEDEA),
                          borderRadius: BorderRadius.circular(12)),
                      child: ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        padding: const EdgeInsets.only(top: 12, bottom: 20) +
                            const EdgeInsets.symmetric(horizontal: 12),
                        separatorBuilder: (_, __) => const SizedBox(
                          height: 12,
                        ),
                        controller: scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.chatHistory.length <= 3
                            ? model.chatHistory.length
                            : 3,
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            message: model.chatHistory[index]['message'],
                            isSentByMe: model.chatHistory[index]['isUser'],
                          );
                        },
                      ),
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
              onButtonPressed: (context) => model.setTabIndex(1))
        ],
      ));
    });
  }

  final firestore = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();

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
  final bool enable;
  final String title;
  final Function(BuildContext)? onItemPressed;

  const HighlightItem(
      {super.key,
      required this.title,
      required this.onItemPressed,
      required this.enable});

  @override
  State<HighlightItem> createState() => _HighlightItemState();
}

class _HighlightItemState extends State<HighlightItem> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.onItemPressed != null && widget.enable) {
                widget.onItemPressed!(context);
              }
            },
            onLongPress: () {
              model.isCouple
                  ? showMenu(
                      context: context,
                      position: calculatePosition(),
                      items: [
                        PopupMenuItem(
                          value: 'edit',
                          onTap: () async {
                            String path =
                                (await ApiCalls.getImage(ImageSource.gallery))!;
                            model
                                .saveUpdateThumbnail(path, widget.title)
                                .whenComplete(() => ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Thumbnail updated successfully'))));
                          },
                          child: const Text('Edit thumbnail'),
                        ),
                        if (widget.title == 'Memories')
                          PopupMenuItem(
                            value: 'upload',
                            onTap: () async {
                              String path = (await ApiCalls.getImage(
                                  ImageSource.gallery))!;
                              model.savePhotoToDB(path, 'Memory').whenComplete(
                                  () => model.getPhotoList().whenComplete(() =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Memory uploaded successfully')))));
                            },
                            child: const Text('Upload memory'),
                          ),
                        if (widget.title == 'Story')
                          PopupMenuItem(
                            value: 'upload',
                            onTap: () async {
                              String path = (await ApiCalls.getImage(
                                  ImageSource.gallery))!;
                              model.saveStoryToDB(path).whenComplete(() =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Story uploaded successfully'))));
                            },
                            child: const Text('Upload story'),
                          ),
                      ],
                    )
                  : null;
            },
            child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF713C05), width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipOval(
                      child: model.thumbnailList
                              .where((thumbnail) =>
                                  thumbnail.category == widget.title)
                              .toList()
                              .isNotEmpty
                          ? Image.network(
                              model.thumbnailList
                                  .where((thumbnail) =>
                                      thumbnail.category == widget.title)
                                  .toList()
                                  .first
                                  .image,
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
    });
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
}

class AddNewCeremony extends StatefulWidget {
  const AddNewCeremony({super.key});

  @override
  State<AddNewCeremony> createState() => _AddNewCeremonyState();
}

class _AddNewCeremonyState extends State<AddNewCeremony> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      _locationController.text = model.address;
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
                  keyboardType: TextInputType.text,
                  readOnly: false,
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
                  readOnly: true,
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
    });
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
    model
        .saveCeremonyToDB(
            imagePath,
            _titleController.text,
            _descController.text,
            _locationController.text,
            _dateController.text)
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
    return Consumer<MainViewModel>(builder: (context, model, child) {
      return PopupMenuButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: Color(0xFF33201C),
        ),
        onSelected: (String result) {
          handleMenuItemSelected(result, context, model);
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
          const PopupMenuItem<String>(
            value: 'terms',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.miscellaneous_services,
                  color: Color(0xFF33201C),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Terms and Services',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'policy',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.miscellaneous_services,
                  color: Color(0xFF33201C),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  color: Color(0xFF33201C),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Delete Account?',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Future<void> handleMenuItemSelected(
      String value, BuildContext context, MainViewModel model) async {
    switch (value) {
      case 'logout':
        model.clearAll();
        await FirebaseAuth.instance
            .signOut()
            .whenComplete(() => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const GuestLogin()),
                  (route) => false,
                ))
            .onError((error, stackTrace) => debugPrint(error.toString()));
        break;
      case 'terms':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen(isTerms: true)),
        );
        break;
      case 'policy':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen(isTerms: false)),
        );
        break;
      case 'delete':
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delete Account!'),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Aww, are you sure you want to delete your account?\nAll your data will be lost.'),
                      ),
                      Row(
                        children: [
                          CustomButton(
                            label: 'Yes',
                            width: 100,
                            onButtonPressed: (context) async {
                              model.clearAll();
                              await FirebaseAuth.instance.currentUser?.delete()
                                  .whenComplete(() => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const GuestLogin()),
                                    (route) => false,
                              ))
                                  .onError((error, stackTrace) => debugPrint(error.toString()));
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          CustomButton(
                            label: 'No',
                            width: 100,
                            onButtonPressed: (context) => Navigator.pop(context),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
        break;
    }
  }
}
