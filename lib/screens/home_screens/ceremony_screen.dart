import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vivah_ai/models/ceremony.dart';
import '../../providers/api_calls.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CeremonyScreen extends StatefulWidget {
  final Ceremony ceremony;

  const CeremonyScreen({super.key, required this.ceremony});

  @override
  State<CeremonyScreen> createState() => _CeremonyScreenState();
}

class _CeremonyScreenState extends State<CeremonyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black26,
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.ceremony.title,
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontStyle: FontStyle.italic)),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Enjoy the function to the most',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                deleteCeremony(widget.ceremony);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Color(0xFF33201C),
              )),
          IconButton(
              onPressed: () {
                showUpdateCeremonyDialog();
              },
              icon: const Icon(
                Icons.edit_note_outlined,
                color: Color(0xFF33201C),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14)),
                child: Image.network(
                  widget.ceremony.url,
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.ceremony.title} ceremony',
                    style: GoogleFonts.carattere(
                        textStyle: const TextStyle(
                            color: Color(0xFF33201C),
                            fontSize: 40,
                            fontStyle: FontStyle.italic)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 12),
                    child: Text(
                      widget.ceremony.description,
                      style: const TextStyle(color: Color(0xFF33201C), fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                    child: Text(
                      'Mark your presence on ${widget.ceremony.date} at ${widget.ceremony.location}',
                      style: const TextStyle(color: Color(0xFF33201C), fontSize: 14),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void deleteCeremony(Ceremony ceremony) async {
    await FirebaseFirestore.instance.collection('ceremonies').doc(ceremony.ceremonyId).delete().whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${ceremony.title} deleted successfully'),
      duration: const Duration(seconds: 2),
    ));
  }

  void showUpdateCeremonyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: UpdateCeremony(ceremony: widget.ceremony),
        );
      },
    );
  }
}


class UpdateCeremony extends StatefulWidget {
  final Ceremony ceremony;

  const UpdateCeremony({super.key, required this.ceremony});

  @override
  State<UpdateCeremony> createState() => _UpdateCeremonyState();
}

class _UpdateCeremonyState extends State<UpdateCeremony> {
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
                onIconTap: (context) => null,
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
                            _dateController.text.isNotEmpty &&
                            _locationController.text.isNotEmpty)
                          { updateCeremony() }
                      })),
            ],
          ),
        ),
      ),
    );
  }

  String buttonText = 'Update ceremony';
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.ceremony.title;
    _descController.text = widget.ceremony.description;
    _locationController.text = widget.ceremony.location;
    _dateController.text = widget.ceremony.date;
  }

  String imagePath = '';

  Future<void> updateCeremony() async {
    setState(() {
      buttonText = 'Updating ceremony....';
    });

    String url = imagePath.isNotEmpty ? (await ApiCalls.uploadImageOrAudioToCloudinary(imagePath))! : widget.ceremony.url;
    try {
      await FirebaseFirestore.instance.collection('ceremonies').doc(widget.ceremony.ceremonyId)
          .update({
        if(_titleController.text != widget.ceremony.title) 'title': _titleController.text,
        if(_descController.text != widget.ceremony.description) 'description': _descController.text,
        if(url != widget.ceremony.url) 'url': url,
        if(_locationController.text != widget.ceremony.location) 'location': _locationController.text,
        if(_dateController.text != widget.ceremony.location) 'date': _dateController.text,
      }).whenComplete(() => Navigator.pop(context));
      Navigator.pop(context);
      setState(() {
        buttonText = 'Update ceremony';
      });
      debugPrint('Ceremony updated');
    } catch (e) {
      debugPrint('Error updating ceremony to Firestore: $e');
    }
  }
}
