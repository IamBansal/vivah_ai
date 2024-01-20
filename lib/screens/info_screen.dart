// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jumping_dot/jumping_dot.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:vivah_ai/providers/api_calls.dart';
import 'dart:convert';
import 'package:vivah_ai/widgets/custom_text_field.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
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
            visible: isCouple,
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
                        onIconTap: (context) => _askController.text.isNotEmpty
                            ? sendMessageToChatGPT(_askController.text)
                            : null,
                        keyboardType: TextInputType.text,
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
                              labelStyle: const TextStyle(color: Colors.white),
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
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: chatHistory[index]['message'],
                    isSentByMe: chatHistory[index]['isUser'],
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
  }

  bool isCouple = false;
  bool isBotTyping = false;

  @override
  void initState() {
    super.initState();
    _isCouple();
  }

  final scrollController = ScrollController();
  final dragController = DraggableScrollableController();
  final _askController = TextEditingController();
  String apiKey = dotenv.env['API_KEY'] ?? '';
  int _selectedChipIndex = 0;
  String prompt = '';

  List<Map<String, dynamic>> chatHistory = [
    {
      'message': 'How can I help you?',
      'isUser': false,
    },
  ];

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

  Future<void> sendMessageToChatGPT(String message) async {
    setState(() {
      isBotTyping = true;
    });
    List<String> promptAndId = await ApiCalls.getPromptAndId();
    String prompt = promptAndId.isNotEmpty ? promptAndId[0] : 'No prompt';

    debugPrint(prompt);

    setState(() {
      chatHistory.insert(0, {'message': message, 'isUser': true});
    });
    _askController.text = '';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': prompt},
          {'role': 'user', 'content': message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final chatResponse = responseData['choices'][0]['message']['content'];
      setState(() {
        isBotTyping = false;
        chatHistory.insert(0, {'message': chatResponse, 'isUser': false});
      });
      debugPrint(chatResponse.toString());
      _updateUI();
      return chatResponse;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception(
          'Uh oh! Network Error\nYou are just a bit away, try again and beat the issue.');
    }
  }

  void _updateUI() {
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

  void _isCouple() async {
    bool isCoupleOrNot = await ApiCalls.isCouple();
    setState(() {
      isCouple = isCoupleOrNot;
    });
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
              ApiCalls.saveUpdatePrompt(parsingResult).whenComplete(() => Navigator.of(context).pop());
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
          color: isSentByMe ? const Color(0xFF713C05) : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSentByMe ? 12.0 : 0.0),
            topRight: Radius.circular(isSentByMe ? 0.0 : 12.0),
            bottomLeft: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
