import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/main_screen.dart';
import 'package:vivah_ai/widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class InitialDetails extends StatefulWidget {
  const InitialDetails({super.key});

  @override
  State<InitialDetails> createState() => _InitialDetailsState();
}

class _InitialDetailsState extends State<InitialDetails> {
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
                        hint: 'Enter Bride\'s name')),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    controller: _groomNameController,
                    label: 'Groom\'s Name',
                    hint: 'Enter Groom\'s name'),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    controller: _hashtagController,
                    label: 'Wedding Hashtag',
                    hint: 'Enter your wedding hashtag'),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    controller: _venueController,
                    label: 'Venue',
                    hint: 'Enter wedding\'s venue'),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFieldWithIcon(
                    controller: _dateController,
                    label: 'Date',
                    hint: 'Enter Date',
                  icon: const Icon(Icons.calendar_today, color: Color(0xFFD7B2E5)),
                  onIconTap: (context) => _selectDate(context),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                    controller: _moreController,
                    label: 'Add more',
                    hint: 'Anything you want to add to info'),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(label: 'Save and Continue', onButtonPressed: (context) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(isBrideGroom: true),
                  ),
                ),)
              ],
            ),
          ),
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  final _brideNameController = TextEditingController();
  final _groomNameController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _venueController = TextEditingController();
  final _dateController = TextEditingController();
  final _moreController = TextEditingController();
}
