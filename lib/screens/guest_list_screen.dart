import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';

class GuestListScreen extends StatefulWidget {
  const GuestListScreen({super.key});

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {

  final _nameController = TextEditingController();
  final _relationController = TextEditingController();

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
                      textStyle: const TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic)
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Welcoming you all', style: TextStyle(color: Colors.black ,fontSize: 12),),
                )
              ],
            ),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: Colors.black,)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz, color: Colors.black,)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15,),
                Center(child: CustomTextField(controller: _nameController, label: 'Name', hint: 'Enter Preferred Name - e.g., Bindu Chachu')),
                const SizedBox(height: 15,),
                CustomTextField(controller: _relationController, label: 'Relation', hint: 'Enter Relation - e.g., Bride\'s Chachu'),
                const SizedBox(height: 15,),
                const Divider(height: 5, color: Colors.grey,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LADKI WALE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      Chip(label: Text('123')),
                    ],
                  ),
                ),
                const Divider(height: 5, color: Colors.grey,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LADKE WALE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      Chip(label: Text('101')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
