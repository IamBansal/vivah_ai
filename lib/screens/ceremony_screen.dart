import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivah_ai/models/ceremony.dart';

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
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Text(
              '${widget.ceremony.title} ceremony',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontStyle: FontStyle.italic)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 12),
              child: Text(
                widget.ceremony.description,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8),
              child: Text(
                'Mark your presence on ${widget.ceremony.date} at ${widget.ceremony.location}',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
