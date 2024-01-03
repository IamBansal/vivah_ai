import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/screens/create_invite.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_button.dart';

class GuestListScreen extends StatefulWidget {
  const GuestListScreen({super.key});

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

const List<String> list = <String>[
  'Core',
  'Friends',
  'Relatives',
  'Peers',
  'Guests'
];

const List<String> listTeam = <String>[
  'Ladki wale',
  'Ladke wale',
];

class _GuestListScreenState extends State<GuestListScreen> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isVisible = false;
  String relationCategory = list.first;
  String team = listTeam.first;
  bool ladkiVisible = false;
  bool ladkeVisible = false;

  File _imageFile = File('');
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _importContact() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    _contactController.text = contact.phoneNumber!.number.toString();
    _nameController.text = contact.fullName.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _relationController.dispose();
    _contactController.dispose();
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
              'Guest List',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontStyle: FontStyle.italic)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Welcoming you all',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: CustomTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter Preferred Name - e.g., Bindu Chachu')),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  controller: _relationController,
                  label: 'Relation',
                  hint: 'Enter Relation - e.g., Bride\'s Chachu'),
              const SizedBox(
                height: 15,
              ),
              CustomTextFieldWithIcon(
                controller: _contactController,
                label: 'Contact',
                hint: 'Enter contact of relative',
                icon: const Icon(Icons.add_ic_call_outlined, color: Color(0xFFD7B2E5)),
                onIconTap: (context) => _importContact(),
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: !_isVisible,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    child: const Icon(Icons.arrow_drop_down)),
              ),
              Visibility(
                  visible: _isVisible,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownMenu<String>(
                            hintText: 'Gender',
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              setState(() {
                                relationCategory = value!;
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
                          DropdownMenu<String>(
                            hintText: 'Team',
                            initialSelection: listTeam.first,
                            onSelected: (String? value) {
                              setState(() {
                                team = value!;
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
                            dropdownMenuEntries: listTeam
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ],
                      ),
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
                                        onTap: () {
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                          getImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_library,
                                          color: Color(0xFF5271EF),
                                        ),
                                        title:
                                            const Text('Choose from Gallery'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          getImage(ImageSource.gallery);
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
                                      color: const Color(0xFF5271EF),
                                      width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _imageFile != File('')
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(_imageFile),
                                        radius: 50.0,
                                      )
                                    : const Icon(
                                        Icons.add_a_photo,
                                        color: Color(0xFF5271EF),
                                      ),
                              )),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          child: const Icon(Icons.arrow_drop_up))
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              CustomButton(label: 'Add the guest!', onButtonPressed: (context) => null,),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 5,
                color: Colors.grey,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      ladkiVisible = !ladkiVisible;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LADKI WALE',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Chip(label: Text('123')),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: ladkiVisible,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/pic.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: const Text('Bindu Chachu'),
                              subtitle: const Text('Anika\'s Elder Chachu'),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // TODO - Handle onTap action for each list item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateInvite(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              const Divider(
                height: 5,
                color: Colors.grey,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      ladkeVisible = !ladkeVisible;
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LADKE WALE',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Chip(label: Text('101')),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: ladkeVisible,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/pic.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: const Text('Bindu Chachu'),
                              subtitle: const Text('Tanmay\'s Elder Chachu'),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // TODO - Handle onTap action for each list item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateInvite(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}