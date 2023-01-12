import 'dart:convert';

import 'package:chatgpttutorial/api/api_key.dart';
import 'package:chatgpttutorial/model/message.dart';
import 'package:http/http.dart' as http;

Future<Message> callOpenApi(String text) async {
  const String url = "https://api.openai.com/v1/completions";
  final header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $cApiKey"
  };
  final body = json.encode({
    "model": "text-davinci-003",
    "prompt": text,
    "max_tokens": 100,
    "temperature": 0
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return Message(
          text: data["choices"][0]["text"].toString().replaceFirst("\n\n", ""),
          isMe: false,
          time: DateTime.now());
    } else {
      return Message(
          text: "Fehler bei der Anfrage", isMe: false, time: DateTime.now());
    }
  } catch (error) {
    return Message(
        text: "Fehler bei der Anfrage", isMe: false, time: DateTime.now());
  }
}
