import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/quiz-screens/boolean_questions.dart';
import 'package:quiz_app/screens/quiz-screens/multiple_choice_questions.dart';

import '../utils/result.dart';
import '../utils/rules.dart';
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

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showCupertinoDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?',
                style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold)),
            content: Text('Do you want to quit the quiz?',
                style: GoogleFonts.robotoMono()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<QuizQuestion>(context, listen: false).restart();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
        return shouldPop;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: SingleChildScrollView(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          'Rules and Regulations',
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Rule(
                                          text:
                                              'The quiz consists of a total of ${Provider.of<QuizQuestion>(context, listen: false).amount} questions.',
                                        ),
                                        const Rule(
                                            text:
                                                'For a correct answer, the user will receive +2 point.'),
                                        const Rule(
                                            text:
                                                'For an incorrect answer, the user will receive -1 point.'),
                                        const Rule(
                                            text:
                                                'For an unanswered question, the user will receive 0 points.'),
                                        const Rule(
                                            text:
                                                'The quiz will automatically submit when the time runs out.'),
                                        const Rule(
                                            text:
                                                'The user can go back and forth between questions at any time.'),
                                        const Rule(
                                            text:
                                                'The user can mark or unmark questions as they wish.'),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Marking Scheme',
                                          style: GoogleFonts.trispace(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Rule(
                                            text:
                                                'The user will be given 15 seconds to answer each question. So total time for the quiz will be ${int.parse(Provider.of<QuizQuestion>(context, listen: false).amount) * 15} seconds.'),
                                        const Rule(
                                            text:
                                                'The user\'s total score will be calculated by adding up the points they '
                                                'have earned for correct answers.'),
                                        const Rule(
                                          text:
                                              'The user\'s final score will be displayed at the end of the quiz.',
                                        ),
                                        const Rule(
                                            text:
                                                'The user\'s score will be saved so that they can view it again later.'),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'ALl the Best!',
                                              style: GoogleFonts.trispace(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Lottie.asset(
                                              'asset/lottie/all-the-best.json',
                                              height: 100,
                                              width: 100,
                                              repeat: false,
                                              frameRate: FrameRate.max,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.info_outlined,
                  weight: 100,
                  size: 35,
                ),
              ),
            ],
            title: Text(
              'Let\'s QuizIt',
              style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
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
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return CountdownTimer(
                              seconds: int.parse(Provider.of<QuizQuestion>(
                                          context,
                                          listen: false)
                                      .amount) *
                                  15,
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
              Provider.of<QuizQuestion>(context, listen: false).type ==
                      'multiple'
                  ? const Multiple()
                  : const Boolean(),
            ],
          )),
    );
  }
}
