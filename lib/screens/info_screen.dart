import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<Map<String, dynamic>> chatHistory = [
    {
      'message': 'How can I help you?',
      'isUser': false,
    },
  ];

  final _askController = TextEditingController();
  int _selectedChipIndex = 0;
  final List<String> _options = [
    'How did you both meet?',
    'What are the venue details?',
    'How to reach there from my location?'
  ];
  String apiKey = dotenv.env['API_KEY'] ?? '';

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
              'Vivah Guide',
              style: GoogleFonts.carattere(
                  textStyle: const TextStyle(color: Colors.black, fontSize: 35, fontStyle: FontStyle.italic)
              ),
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
      bottomSheet: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              // return BottomSheetContainer(sendMessageToGPT: sendMessageToChatGPT ,context);
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: Card(
                      color: const Color(0xFFF5ECF9),
                      elevation: 5.0,
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Ask a question about the wedding',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            height: 50,
                            child: TextField(
                              controller: _askController,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFDFDFDF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                hintText: 'Ask anything',
                                hintStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                                hintMaxLines: 1,
                                labelText: 'Ask me',
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    sendMessageToChatGPT(_askController.text);
                                    Navigator.pop(context);
                                  },
                                )
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(color: Colors.black),
                            ),
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
                                      _selectedChipIndex =
                                          selected ? index : -1;
                                      _askController.text =
                                          _options[_selectedChipIndex];
                                    });
                                  },
                                  selectedColor: const Color(0xFFD7B2E5),
                                  backgroundColor: Colors.grey[200],
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                );
                              },
                            ).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 65, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 5, color: Colors.grey,),
              SizedBox(height: 8,),
              Text(
                'Ask a question about the wedding....\nClick me!!!',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(30),
          itemCount: chatHistory.length,
          itemBuilder: (ctx, index) {
            final chatItem = chatHistory[chatHistory.length - index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: chatItem['isUser']
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  chatItem['isUser']
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5ECF9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 100,
                            maxWidth: 220,
                          ),
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                chatItem['message'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD7B2E5),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 120,
                            maxWidth: 220,
                          ),
                          child: Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                chatItem['message'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }

  Future<void> sendMessageToChatGPT(String message) async {
    setState(() {
      chatHistory.add({'message': message, 'isUser': true});
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'behave according to the list of responses provided in message'
          },
          {
            'role': 'user',
            'content':
                'You have a list of responses : \n- Wedding is in udaipur\n- Bride is Anika Beri, Groom is Tanmay Dhote, they met at a cafe three years ago.\n- Menu at wedding consists of pani puri, tikki, indian cuisine as well italian.\n- Dress code for haldi is yellow and for mehndi is green, while for wedding night, it\'s three piece suit.\nNow, you have to answer from these responses to the user\'s question.\nUser\'s question: $message'
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final chatResponse = responseData['choices'][0]['message']['content'];
      setState(() {
        chatHistory.add({'message': chatResponse, 'isUser': false});
      });
      debugPrint(chatResponse.toString());
      return chatResponse;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception(
          'Uh oh! Network Error\nYou are just a bit away, try again and beat the issue.');
    }
  }
}

class BottomSheetContainer extends StatefulWidget {
  final Function(String) sendMessageToGPT;

  const BottomSheetContainer(BuildContext context,
      {super.key, required this.sendMessageToGPT});

  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  final _askController = TextEditingController();
  int _selectedChipIndex = 0;
  final List<String> _options = [
    'How did you both meet?',
    'What are the venue details?',
    'How to reach there from my location?'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Card(
          // color: Colors.grey,
          elevation: 5.0,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Ask a question about the wedding',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 340,
                height: 50,
                child: Row(
                  children: [
                    TextField(
                      controller: _askController,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFDFDFDF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        hintText: 'Ask anything',
                        hintStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                        hintMaxLines: 1,
                        labelText: 'Ask me',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          widget.sendMessageToGPT(_askController.text);
                        },
                      ),
                    ),
                  ],
                ),
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
                          _askController.text = _options[_selectedChipIndex];
                        });
                      },
                      selectedColor: Colors.grey,
                      // Customize selected chip color
                      backgroundColor: Colors.grey[300],
                      // Customize chip background color
                      labelStyle: const TextStyle(
                          color: Colors.black), // Customize chip label color
                    );
                  },
                ).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
