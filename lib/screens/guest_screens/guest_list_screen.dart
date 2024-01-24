import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/screens/guest_screens/create_invite.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/api_calls.dart';
import '../../widgets/custom_button.dart';

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
  final _roomController = TextEditingController();
  bool _isVisible = false;
  String relationCategory = list.first;
  String team = listTeam.first;
  bool ladkiVisible = false;
  bool ladkeVisible = false;
  String buttonText = 'Add the guest!';
  String imagePath = '';
  late MainViewModel model;

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
    _roomController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child){
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
                              color: Color(0xFF33201C),
                              fontSize: 35,
                              fontStyle: FontStyle.italic)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Welcoming you all',
                        style: TextStyle(color: Color(0xFF33201C), fontSize: 12),
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
                              hint: 'Enter Preferred Name - e.g., Bride\'s Chachu',
                              expand: false)),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                          controller: _relationController,
                          label: 'Relation',
                          hint: 'Enter Relation - e.g., Bride\'s Chachu',
                          expand: false),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFieldWithIcon(
                        controller: _contactController,
                        label: 'Contact',
                        hint: 'Enter contact of relative',
                        icon: Icons.add_ic_call_outlined,
                        expand: false,
                        onIconTap: (context) => _importContact(),
                        keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                        readOnly: false,
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
                                    width: MediaQuery.of(context).size.width * 0.25,
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
                                        const BorderSide(color: Color(0xFF4F2E22)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide:
                                        const BorderSide(color: Color(0xFF4F2E22)),
                                      ),
                                    ),
                                    dropdownMenuEntries: list
                                        .map<DropdownMenuEntry<String>>((String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  ),
                                  DropdownMenu<String>(
                                    width: MediaQuery.of(context).size.width * 0.35,
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
                                        const BorderSide(color: Color(0xFF4F2E22)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide:
                                        const BorderSide(color: Color(0xFF4F2E22)),
                                      ),
                                    ),
                                    dropdownMenuEntries: listTeam
                                        .map<DropdownMenuEntry<String>>((String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    // height: 50,
                                    child: TextField(
                                      controller: _roomController,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xFFDFDFDF),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide:
                                            const BorderSide(color: Color(0xFF33201C)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            borderSide:
                                            const BorderSide(color: Color(0xFF33201C)),
                                          ),
                                          hintText: '102',
                                          hintStyle: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                          ),
                                          hintMaxLines: 1,
                                          labelText: 'Room',
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                          ),
                                          counterText: ''
                                      ),
                                      textAlignVertical: TextAlignVertical.center,
                                      style: const TextStyle(color: Color(0xFF33201C)),
                                      maxLines: 1,
                                      maxLength: 6,
                                      minLines: 1,
                                      keyboardType: TextInputType.number,
                                    ),
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
                                                    color: Color(0xFF4F2E22)),
                                                title: const Text('Take Photo'),
                                                onTap: () async {
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet
                                                  String path =
                                                  (await ApiCalls.getImage(
                                                      ImageSource.camera))!;
                                                  setState(() {
                                                    imagePath = path;
                                                  });
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo_library,
                                                  color: Color(0xFF4F2E22),
                                                ),
                                                title:
                                                const Text('Choose from Gallery'),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  String path =
                                                  (await ApiCalls.getImage(
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
                                              color: const Color(0xFF4F2E22),
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: imagePath.isNotEmpty
                                            ? CircleAvatar(
                                          backgroundImage:
                                          FileImage(File(imagePath)),
                                          radius: 50.0,
                                        )
                                            : const Icon(
                                          Icons.add_a_photo,
                                          color: Color(0xFF4F2E22),
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
                      CustomButton(
                        label: buttonText,
                        onButtonPressed: (context) => addTheGuestToDB(),
                      ),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'LADKI WALE',
                                style: TextStyle(
                                    color: Color(0xFF33201C), fontWeight: FontWeight.bold),
                              ),
                              Chip(label: Text(model.ladkiVale.length.toString()), backgroundColor: const Color(0xFFFBEDEA)),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: model.ladkiVale.length * 90,
                          child: ListView.builder(
                            itemCount: model.ladkiVale.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(model.ladkiVale[index].guestId),
                                onDismissed: (direction) {
                                  if (model.ladkiVale[index].guestId.isNotEmpty) {
                                    model.deleteGuest(model.ladkiVale[index].guestId).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Guest deleted successfully'),
                                      duration: Duration(seconds: 2),
                                    )));
                                    // model.ladkiVale.removeAt(index);
                                    // _getGuestList();
                                  }
                                },
                                child: Card(
                                  elevation: 0.5,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: isValidURL(model.ladkiVale[index].url)
                                          ? Image.network(
                                        model.ladkiVale[index].url,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        'assets/pic.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(model.ladkiVale[index].name),
                                    subtitle: Text(model.ladkiVale[index].relation),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Visibility(visible: model.ladkiVale[index].isCreated,child: const Icon(Icons.check, color: Colors.green,),),
                                        const SizedBox(width: 5,),
                                        const Icon(Icons.arrow_forward, color: Color(0xFF4F2E22),),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateInvite(guest: model.ladkiVale[index], indexInList: index,),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                              ladkeVisible = !ladkeVisible;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'LADKE WALE',
                                style: TextStyle(
                                    color: Color(0xFF33201C), fontWeight: FontWeight.bold),
                              ),
                              Chip(label: Text(model.ladkeVale.length.toString()), backgroundColor: const Color(0xFFFBEDEA),),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.6,
                          height: model.ladkeVale.length * 90,
                          child: ListView.builder(
                            itemCount: model.ladkeVale.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(model.ladkeVale[index].guestId),
                                onDismissed: (direction) {
                                  if (model.ladkeVale[index].guestId.isNotEmpty) {
                                    model.deleteGuest(model.ladkeVale[index].guestId).whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Guest deleted successfully'),
                                      duration: Duration(seconds: 2),
                                    )));
                                    // model.ladkeVale.removeAt(index);
                                    // _getGuestList();
                                  }
                                },
                                child: Card(
                                  elevation: 0.5,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: isValidURL(model.ladkeVale[index].url)
                                          ? Image.network(
                                        model.ladkeVale[index].url,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        'assets/pic.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(model.ladkeVale[index].name),
                                    subtitle: Text(model.ladkeVale[index].relation),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Visibility(visible: model.ladkeVale[index].isCreated,child: const Icon(Icons.check, color: Colors.green,),),
                                        const SizedBox(width: 5,),
                                        const Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateInvite(guest: model.ladkeVale[index], indexInList: index,),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      }
    );
  }

  addTheGuestToDB() async {
    if (_nameController.text.isNotEmpty &&
        _relationController.text.isNotEmpty &&
        _contactController.text.isNotEmpty &&
        _contactController.text.length >= 10) {
      setState(() {
        buttonText = 'Adding the guest.....';
      });

      String downloadUrl = '';
      if (imagePath.isNotEmpty) {
        String? url = await ApiCalls.uploadImageOrAudioToCloudinary(imagePath);
        setState(() {
          downloadUrl = url!;
        });
      } else {
        setState(() {
          downloadUrl =
              'https://res.cloudinary.com/dz1lt2wwz/image/upload/v1704534097/WhatsApp_Image_2023-12-21_at_6.55.22_PM_acw9tv.jpg';
        });
      }

      String contact = _contactController.text.replaceAll(' ', '');
      contact = contact.length > 10
          ? contact.substring(contact.length - 10)
          : contact;

      model.addGuestToDB(downloadUrl, _nameController.text, contact, _relationController.text, relationCategory, team, _roomController.text)
          .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Guest added successfully'),
        duration: Duration(seconds: 2),
      )));

        _nameController.clear();
        _relationController.clear();
        _contactController.clear();

        setState(() {
          buttonText = 'Add the guest!';
        });
    }
  }

  bool isValidURL(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      return true;
    }
    return false;
  }
}
