import 'package:chatgpttutorial/api/open_ai_api.dart';
import 'package:chatgpttutorial/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat GPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "ChatGPT",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: messages[index].isMe
                          ? const Icon(
                              Icons.person,
                              color: Colors.black,
                            )
                          : const Icon(Icons.computer, color: Colors.black),
                      title: Text(messages[index].text),
                    );
                  }),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _textController,
                        minLines: 1,
                        maxLines: 5,
                        placeholder: "Schreibe etwas...",
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        if (_textController.text.isNotEmpty) {
                          setState(() {
                            messages.add(Message(
                                text: _textController.text,
                                isMe: true,
                                time: DateTime.now()));
                          });
                          String text = _textController.text;
                          _textController.clear();

                          // Call API
                          Message responseMessage = await callOpenApi(text);
                          setState(() {
                            messages.add(responseMessage);
                          });
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
