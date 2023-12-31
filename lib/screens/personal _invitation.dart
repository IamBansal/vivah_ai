import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalInvitation extends StatefulWidget {
  const PersonalInvitation({super.key});

  @override
  State<PersonalInvitation> createState() => _PersonalInvitationState();
}

class _PersonalInvitationState extends State<PersonalInvitation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 10, left: 13, right: 13),
              child: Text(
                'Bindu Chachu',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(color: Colors.black, fontSize: 42, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Personalised Card Invitation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Row(
                    children: [
                      Icon(Icons.file_upload_outlined),
                      SizedBox(width: 10,),
                      Icon(Icons.file_download_outlined)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Container(
                height: 500,
                color: Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 1, color: Colors.grey, indent: 10, endIndent: 10,),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Voice Invitation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  Row(
                    children: [
                      Icon(Icons.file_upload_outlined),
                      SizedBox(width: 10,),
                      Icon(Icons.file_download_outlined)
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0),
              child: Align(alignment: Alignment.centerLeft,child: Icon(Icons.mic, size: 30,),),
            )
          ],
        ),
      ),
    ));
  }
}
