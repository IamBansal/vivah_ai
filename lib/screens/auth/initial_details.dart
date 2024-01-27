import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vivah_ai/main_screen.dart';
import 'package:vivah_ai/widgets/custom_button.dart';
import '../../providers/api_calls.dart';
import '../../viewmodels/main_view_model.dart';
import '../../widgets/custom_text_field.dart';
import '../map_screens/select_location.dart';
import 'login/guest_login.dart';

class InitialDetails extends StatefulWidget {
  const InitialDetails({super.key});

  @override
  State<InitialDetails> createState() => _InitialDetailsState();
}

class _InitialDetailsState extends State<InitialDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
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
                'Wedding Details',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontStyle: FontStyle.italic)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Make everything perfect',
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
                                builder: (context) => const GuestLogin()),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Enter Details of your wedding!\n You can modify this later as well.',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: CustomTextField(
                      controller: _brideNameController,
                      label: 'Bride\'s Name',
                      hint: 'Enter Bride\'s name',
                      expand: false)),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                  controller: _groomNameController,
                  label: 'Groom\'s Name',
                  hint: 'Enter Groom\'s name',
                  expand: false),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: _hashtagController,
                label: 'Wedding Hashtag',
                hint: 'Enter your wedding hashtag',
                expand: false,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFieldWithIcon(
                controller: _venueController,
                label: 'Venue',
                hint: 'Enter wedding\'s venue',
                icon: Icons.location_on_outlined,
                expand: true,
                onIconTap: (context) => showSelectLocationDialog(),
                keyboardType: TextInputType.text,
                readOnly: false,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFieldWithIcon(
                controller: _dateController,
                label: 'Date',
                hint: 'Enter Date',
                icon: Icons.calendar_today,
                expand: false,
                onIconTap: (context) async => {
                  _dateController.text = (await ApiCalls.selectDate(context))!
                },
                keyboardType: TextInputType.text,
                readOnly: true,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: _moreController,
                label: 'Add more',
                hint: 'Anything you want to add to info',
                expand: true,
              ),
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                label: 'Save and Continue',
                onButtonPressed: (context) => validateAndAddData(),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ));
    });
  }

  final _brideNameController = TextEditingController();
  final _groomNameController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _venueController = TextEditingController();
  final _dateController = TextEditingController();
  final _moreController = TextEditingController();
  String docId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
    _hashtagController.text = '#';
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
      _venueController.text = address;
    });
  }

  Future<void> addData(String bride, String groom, String hashtag, String venue,
      String date, String more) async {
    try {
      final firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      DocumentReference newDocumentRef =
          await firestore.collection('entries').add({
        'bride': bride,
        'groom': groom,
        'hashtag': hashtag,
        'venue': venue,
        'date': date,
        'more': more,
        'email': user!.email.toString(),
        'userId': user.uid,
      });
      model.setForCouple(hashtag, bride, groom);
      await model.saveUpdatePrompt(
          'Bride: $bride, Groom: $groom, Wedding hashtag: $hashtag, Venue: $venue, Date: $date, and some more details are $more');

      setState(() {
        docId = newDocumentRef.id;
      });
      debugPrint('Data added successfully with ID: ${newDocumentRef.id}');
      await newDocumentRef
          .update({'id': docId}).whenComplete(() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              ));
    } catch (error) {
      showSnackBar(context, 'Error adding data: $error');
      debugPrint('Error adding data: $error');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  validateAndAddData() {
    if (_brideNameController.text.isNotEmpty &&
        _groomNameController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _venueController.text.isNotEmpty &&
        _hashtagController.text.isNotEmpty &&
        _hashtagController.text.startsWith('#')) {
      addData(
          _brideNameController.text,
          _groomNameController.text,
          _hashtagController.text,
          _venueController.text,
          _dateController.text,
          _moreController.text);
    } else {
      showSnackBar(context, 'All fields are required to be filled.');
    }
  }
}
