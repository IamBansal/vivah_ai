import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/screens/create_invite.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/shared_pref.dart';
import '../widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String buttonText = 'Add the guest!';
  File _imageFile = File('');
  final picker = ImagePicker();

  String cloudName = dotenv.env['CLOUD_NAME'] ?? '';
  String uploadPreset = dotenv.env['UPLOAD_PRESET'] ?? '';

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

  String userId = '';
  String hashtag = '';
  List<Guest> ladkeVale = [];
  List<Guest> ladkiVale = [];

  @override
  void initState() {
    super.initState();
    _getHashTagAndId();
    _getGuestList();
  }

  Future<void> _getHashTagAndId() async {
    List<String>? list = await LocalData.getNameAndId();
    String? hash = await LocalData.getName();
    setState(() {
      userId = list![2];
      hashtag = hash!;
    });
    debugPrint(userId);
    debugPrint(hashtag);
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
                icon: const Icon(Icons.add_ic_call_outlined,
                    color: Color(0xFFD7B2E5)),
                onIconTap: (context) => _importContact(),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
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
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Chip(label: Text(ladkiVale.length.toString())),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: ladkiVisible,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.6,
                      height: ladkiVale.length * 90,
                      child: ListView.builder(
                        itemCount: ladkiVale.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: isValidURL(ladkiVale[index].url) ? Image.network(
                                ladkiVale[index].url,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ) : Image.asset(
                                'assets/pic.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              ),
                              title: Text(ladkiVale[index].name),
                              subtitle: Text(ladkiVale[index].relation),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // TODO - Handle onTap action for each list item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateInvite(guest: ladkiVale[index]),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LADKE WALE',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Chip(label: Text(ladkeVale.length.toString())),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: ladkeVisible,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.6,
                      height: ladkeVale.length * 90,
                      child: ListView.builder(
                        itemCount: ladkeVale.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: isValidURL(ladkeVale[index].url) ? Image.network(
                                  ladkeVale[index].url,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ) : Image.asset(
                                  'assets/pic.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(ladkeVale[index].name),
                              subtitle: Text(ladkeVale[index].relation),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // TODO - Handle onTap action for each list item
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateInvite(guest: ladkeVale[index]),
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

  Future<String> uploadImage(File imageFile, String imageFileName) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('$imageFileName.jpg');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return e.toString();
    }
  }

  Future<String?> uploadImageToCloudinary(String imagePath) async {
    Uri url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    var request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var parsedResponse = json.decode(responseData);
        return parsedResponse['secure_url'];
      } else {
        debugPrint('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
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
      if (_imageFile != File('')) {
        // String url = await uploadImage(_imageFile, _contactController.text);
        String? url = await uploadImageToCloudinary(_imageFile.path);

        setState(() {
          downloadUrl = url!;
        });
      } else {
        setState(() {
          downloadUrl = 'https://res.cloudinary.com/dz1lt2wwz/image/upload/v1704534097/WhatsApp_Image_2023-12-21_at_6.55.22_PM_acw9tv.jpg';
        });
      }

      try {
        await FirebaseFirestore.instance.collection('guestList').add({
          'url': downloadUrl,
          'name': _nameController.text,
          'contact': _contactController.text,
          'relation': _relationController.text,
          'category': relationCategory,
          'team': team,
          'userId' : userId,
          'hashtag' : hashtag
        }).whenComplete(() => _getGuestList());

        _nameController.clear();
        _relationController.clear();
        _contactController.clear();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guest added successfully'), duration: Duration(seconds: 2),));

        setState(() {
          buttonText = 'Add the guest!';
        });

        debugPrint('Guest added');
      } catch (e) {
        debugPrint('Error adding guest to Firestore: $e');
      }
    }
  }

  Future<void> _getGuestList() async {
    ladkeVale.clear();
    ladkiVale.clear();
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot1 = await FirebaseFirestore.instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .get();

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('guestList')
          .where('hashtag', isEqualTo: hashtag)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for(DocumentSnapshot<Map<String, dynamic>> entry in snapshot.docs) {
          Map<String, dynamic>? data = entry.data();
          setState(() {
            Guest guest = Guest(
                category: data!['category'].toString(),
                contact: data['contact'].toString(),
                hashtag: data['hashtag'].toString(),
                name: data['name'].toString(),
                relation: data['relation'].toString(),
                team: data['team'].toString(),
                url: data['url'].toString(),
                userId: data['userId'].toString()
            );
            if(guest.team == 'Ladki wale') {
              ladkiVale.add(guest);
            } else {
              ladkeVale.add(guest);
            }
          });
        }
        debugPrint('Found the guest');
      } else {
        debugPrint('No matching documents found.');
      }

    } catch (error) {
      debugPrint('Error querying entries: $error');
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

class Guest {
  String category;
  String contact;
  String hashtag;
  String name;
  String relation;
  String team;
  String url;
  String userId;

  // Constructor
  Guest({
    required this.category,
    required this.contact,
    required this.hashtag,
    required this.name,
    required this.relation,
    required this.team,
    required this.url,
    required this.userId,
  });

  // Factory method to create a Guest instance from a Map
  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      category: map['category'],
      contact: map['contact'],
      hashtag: map['hashtag'],
      name: map['name'],
      relation: map['relation'],
      team: map['team'],
      url: map['url'],
      userId: map['userId'],
    );
  }

  // Method to convert Guest instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'contact': contact,
      'hashtag': hashtag,
      'name': name,
      'relation': relation,
      'team': team,
      'url': url,
      'userId': userId,
    };
  }
}

