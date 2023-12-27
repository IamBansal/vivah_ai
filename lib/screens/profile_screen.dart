import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedChipIndex = 0;
  final List<String> _options = ['All events', 'Haldi Ceremony', 'Ladies Sangeet', 'Mehndi', 'Wedding'];

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
              'Vivah Photos',
              style: GoogleFonts.carattere(
                textStyle: const TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic)
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'All occasions in one gallery',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
              )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List<Widget>.generate(
                _options.length,
                (int index) {
                  return ChoiceChip(
                    label: Text(_options[index]),
                    selected: _selectedChipIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedChipIndex = selected ? index : -1;
                        _options[_selectedChipIndex];
                      });
                    },
                    selectedColor: const Color(0xFFD7B2E5),
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(color: Colors.black),
                  );
                },
              ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20, 0, 10),
            child: ClipOval(
                child: Image.asset(
              'assets/pic.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )),
          ),
          const SizedBox(height: 5,),
          Text(
            'Anika',
            style: GoogleFonts.carattere(
                textStyle: const TextStyle(color: Color(0xFF5D2673), fontSize: 40, fontStyle: FontStyle.italic)
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: Text(
              'Save your favorite moments to your gallery or upload some future-worthy clicks for everyone!',
              style: TextStyle(color: Color(0xFF9B40BF)),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: (){
                //Handle uploading of images
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_upload_outlined),
                  SizedBox(width: 5,),
                  Text('Upload', style: TextStyle(color: Colors.black),)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    //Handle All of images
                  },
                  child: const Text('All Photos', style: TextStyle(color: Colors.black),),
                ),
                GestureDetector(
                  onTap: (){
                    //Handle solo of images
                  },
                  child: const Text('Solo', style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
          const Divider(height: 5, color: Colors.grey,),
        ],
      ),
    ));
  }
}
