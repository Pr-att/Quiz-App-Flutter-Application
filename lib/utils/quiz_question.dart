import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../scores/score_add.dart';
import '../screens/quiz_screen.dart';

const kURI = 'https://opentdb.com/api.php?';

class Question extends StatelessWidget {
  const Question({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return question(context);
      },
    );
  }
}

question(BuildContext context) async {
  response = await http.get(
    Uri.parse('$kURI'
        'amount=${Provider.of<QuizQuestion>(context, listen: false).amount}'
        '&category=${Provider.of<QuizQuestion>(context, listen: false).category}'
        '&difficulty=${Provider.of<QuizQuestion>(context, listen: false).difficulty}'
        '&type=${Provider.of<QuizQuestion>(context, listen: false).type}'),
  );
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }
  print(response.statusCode);
}
