// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:provider/provider.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:vivah_ai/viewmodels/main_view_model.dart';
import 'package:vivah_ai/widgets/custom_text_field.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(builder: (context, model, child) {
      return SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vivah Guide',
                style: GoogleFonts.carattere(
                    textStyle: const TextStyle(
                        color: Color(0xFF33201C),
                        fontSize: 35,
                        fontStyle: FontStyle.italic)),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Chat to get all details here',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              )
            ],
          ),
          actions: [
            Visibility(
              visible: model.isCouple,
              child: IconButton(
                  onPressed: () {
                    pickFile(context);
                  },
                  icon: const Icon(
                    Icons.edit_note_outlined,
                    color: Color(0xFF33201C),
                  )),
            ),
          ],
        ),
        bottomSheet: DraggableScrollableSheet(
            controller: dragController,
            expand: false,
            initialChildSize: 0.22,
            minChildSize: 0.22,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Divider(
                            indent: 170,
                            endIndent: 170,
                            height: 5,
                            thickness: 5,
                            color: Colors.grey,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Ask a question about the wedding',
                            style: TextStyle(
                                color: Color(0xFF33201C),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        CustomTextFieldWithIcon(
                          controller: _askController,
                          label: 'Ask me',
                          hint: 'Ask anything',
                          icon: Icons.send,
                          expand: true,
                          onIconTap: (context) {
                            if (_askController.text.isNotEmpty) {
                              setState(() {
                                isBotTyping = true;
                              });
                              model.sendMessageToChatGPT(_askController.text);
                              _updateUI();
                            }
                          },
                          keyboardType: TextInputType.text,
                          readOnly: false,
                        ),
                        const SizedBox(height: 15),
                        Wrap(
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
                                    _askController.text =
                                        _options[_selectedChipIndex];
                                  });
                                },
                                selectedColor: const Color(0xFF713C05),
                                backgroundColor: Colors.grey,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              );
                            },
                          ).toList(),
                        )
                      ],
                    )),
              );
            }),
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.only(top: 12, bottom: 20) +
                      const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 12,
                  ),
                  controller: scrollController,
                  itemCount: model.chatHistory.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: model.chatHistory[index]['message'],
                      isSentByMe: model.chatHistory[index]['isUser'],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                    visible: isBotTyping,
                    child: JumpingDots(
                      color: Colors.black,
                      radius: 8,
                      numberOfDots: 3,
                    )),
              )
            ],
          ),
        ),
      ));
    });
  }

  bool isBotTyping = false;
  final scrollController = ScrollController();
  final dragController = DraggableScrollableController();
  final _askController = TextEditingController();
  int _selectedChipIndex = 0;
  late MainViewModel model;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model = Provider.of<MainViewModel>(context, listen: false);
    });
  }

  final List<String> _options = [
    'How did you both meet?',
    'What are the venue details?',
    'How to reach there from my location?'
  ];

  static Future<String?> pickFile(BuildContext context) async {
    try {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (file == null || file.files.isEmpty) {
        debugPrint('File is empty');
        return null;
      } else {
        String? path = file.files.single.path;
        debugPrint('File is not empty and path is : $path');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PdfTextParsingDialog(pdfPath: path!);
          },
        );
        return path;
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      return null;
    }
  }

  void _updateUI() {
    setState(() {
      isBotTyping = false;
    });
    dragController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class PdfTextParsingDialog extends StatefulWidget {
  final String pdfPath;

  const PdfTextParsingDialog({super.key, required this.pdfPath});

  @override
  _PdfTextParsingDialogState createState() => _PdfTextParsingDialogState();
}

class _PdfTextParsingDialogState extends State<PdfTextParsingDialog> {
  String parsingResult = '';
  int pages = 0;

  @override
  void initState() {
    super.initState();
    parsePdfText(widget.pdfPath);
  }

  Future<void> parsePdfText(String path) async {
    try {
      String text = await ReadPdfText.getPDFtext(path);
      int length = await ReadPdfText.getPDFlength(path);
      setState(() {
        parsingResult = text;
        pages = length;
      });
      return;
    } on PlatformException {
      debugPrint('Failed to get PDF text.');
      setState(() {
        parsingResult = '';
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, model, child){
        return AlertDialog(
          scrollable: true,
          icon: const Icon(Icons.picture_as_pdf),
          title: Text(parsingResult.isEmpty
              ? 'Parsing your file.....'
              : 'Parsed successfully'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: parsingResult.isEmpty
                    ? JumpingDots(
                  color: Colors.black,
                  radius: 8,
                  numberOfDots: 3,
                )
                    : Text(
                  parsingResult,
                ),
              ),
              Visibility(
                  visible: pages != 0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Number of pages parsed: $pages',
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 13),
                    ),
                  )),
            ],
          ),
          actions: [
            Visibility(
              visible: parsingResult.isNotEmpty,
              child: ElevatedButton(
                onPressed: () {
                  model.saveUpdatePrompt(parsingResult).whenComplete(() => Navigator.of(context).pop());
                },
                child: const Text('Upload'),
              ),
            ),
            Visibility(
              visible: parsingResult.isEmpty,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        );
      }
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const ChatBubble(
      {super.key, required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: isSentByMe ? const Color(0xFFC58D80) : const Color(0xFF4F2E22),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSentByMe ? 12.0 : 0.0),
            topRight: Radius.circular(isSentByMe ? 0.0 : 12.0),
            bottomLeft: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: isSentByMe ? const Color(0xFF4F2E22) : Colors.white),
        ),
      ),
    );
  }
}
