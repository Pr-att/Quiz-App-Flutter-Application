import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/quiz-screens/boolean_questions.dart';
import 'package:quiz_app/screens/quiz-screens/multiple_choice_questions.dart';
import 'package:quiz_app/utils/result.dart';

import '../utils/timer.dart';

dynamic response;
dynamic result;
dynamic kFinalShuffledValue;
dynamic kCorrectBoolAnswer;

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

var currentPage = 0;
dynamic kValue;
var currentScore = 0;

class _QuizScreenState extends State<QuizScreen> {
  final PageController kPageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Let\'s Quiz',
            style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('high-score')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return Consumer<PlayerScore>(
                        builder: (BuildContext context, value, Widget? child) {
                          return CountdownTimer(
                            seconds: int.parse(Provider.of<QuizQuestion>(
                                        context,
                                        listen: false)
                                    .amount) *
                                30,
                            onTimerFinished: () async {
                              await getResult(
                                  snapshot,
                                  value,
                                  context,
                                  Provider.of<QuizQuestion>(context,
                                          listen: false)
                                      .type);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Provider.of<QuizQuestion>(context, listen: false).type == 'multiple'
                ? Multiple(
                    kPageController: kPageController,
                  )
                : Boolean(
                    kPageController: kPageController,
                    correctBoolAnswer: kCorrectBoolAnswer,
                  )
          ],
        ));
  }

  @override
  void dispose() {
    kPageController.dispose();
    super.dispose();
  }
}
