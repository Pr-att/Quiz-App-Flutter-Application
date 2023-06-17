import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../scores/score_add.dart';
import '../../utils/result.dart';
import '../quiz_screen.dart';

class Multiple extends StatefulWidget {
  final PageController kPageController;

  const Multiple({super.key, required this.kPageController});

  @override
  State<Multiple> createState() => _MultipleState();
}

class _MultipleState extends State<Multiple> {
  List<String?> correctMultipleAnswersList = List.generate(
      result['results'].length,
      (index) => result['results'][index]['correct_answer']);

  List<String?> userMultipleChoiceAnswersList =
      List.generate(result['results'].length, (index) => null);

  @override
  void initState() {
    print(result);
    print(correctMultipleAnswersList);
    print(userMultipleChoiceAnswersList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget.kPageController,
        itemCount: result['results'].length,
        itemBuilder: (context, index) {
          var answers = result['results'][index]['incorrect_answers'];
          var position = Random().nextInt(3);
          var correctAnswer = result['results'][index]['correct_answer'];
          if (!answers.contains(correctAnswer)) {
            kFinalShuffledValue = position;
            answers.insert(position, correctAnswer);
          }

          var unescape = HtmlUnescape();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Q${index + 1}: ${unescape.convert(result['results'][index]['question'])}',
                        style: GoogleFonts.robotoMono(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        RadioListTile(
                          title: Text(
                            unescape.convert(answers[0]),
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: answers[0],
                          groupValue: userMultipleChoiceAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userMultipleChoiceAnswersList[index] = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            unescape.convert(answers[1]),
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: answers[1],
                          groupValue: userMultipleChoiceAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userMultipleChoiceAnswersList[index] = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            unescape.convert(answers[2]),
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: answers[2],
                          groupValue: userMultipleChoiceAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userMultipleChoiceAnswersList[index] = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            unescape.convert(answers[3]),
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: answers[3],
                          groupValue: userMultipleChoiceAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userMultipleChoiceAnswersList[index] = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                currentPage--;
                                widget.kPageController.animateToPage(
                                    currentPage,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut);
                                setState(() {});
                              },
                              child: const Text('Previous'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('high-score')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return Consumer<PlayerScore>(
                                    builder: (BuildContext context, value,
                                        Widget? child) {
                                      return ElevatedButton(
                                        onPressed: currentPage ==
                                                result['results'].length - 1
                                            ? () async {
                                                for (int i = 0;
                                                    i <
                                                        correctMultipleAnswersList
                                                            .length;
                                                    i++) {
                                                  if (userMultipleChoiceAnswersList[
                                                          i] ==
                                                      correctMultipleAnswersList[
                                                          i]) {
                                                    currentScore++;
                                                  } else if (userMultipleChoiceAnswersList[
                                                          i] ==
                                                      null) {
                                                    continue;
                                                  } else {
                                                    currentScore--;
                                                  }
                                                }
                                                await getResult(snapshot, value,
                                                    context, 'boolean');
                                              }
                                            : () {
                                                // if (kFinalShuffledValue ==
                                                //     kValue) {
                                                //   currentScore++;
                                                // } else {
                                                //   currentScore--;
                                                // }
                                                currentPage++;
                                                widget.kPageController
                                                    .animateToPage(currentPage,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        curve: Curves.easeIn);
                                                setState(() {});
                                              },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              userMultipleChoiceAnswersList[
                                                          index] ==
                                                      null
                                                  ? MaterialStateProperty.all(
                                                      Colors.brown[100])
                                                  : MaterialStateProperty.all(
                                                      Colors.purple[500]),
                                        ),
                                        child: currentPage <
                                                result['results'].length - 1
                                            ? const Text(
                                                'Next',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
