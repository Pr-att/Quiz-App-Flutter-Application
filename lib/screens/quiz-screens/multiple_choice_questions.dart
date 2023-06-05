import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import '../../scores/score_add.dart';
import '../quiz_screen.dart';

class Multiple extends StatefulWidget {
  final PageController kPageController;
  const Multiple({super.key, required this.kPageController});

  @override
  State<Multiple> createState() => _MultipleState();
}

class _MultipleState extends State<Multiple> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView.builder(
        physics:  const NeverScrollableScrollPhysics(),
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
                        'Q${index + 1}: ${result['results'][index]['question']}',
                        style: GoogleFonts.robotoMono(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        RadioListTile(
                          title: Text(
                            answers[0],
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 0,
                          groupValue: kValue,
                          onChanged: (value) {
                            setState(() {
                              kValue = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            answers[1],
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 1,
                          groupValue: kValue,
                          onChanged: (value) {
                            setState(() {
                              kValue = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            answers[2],
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 2,
                          groupValue: kValue,
                          onChanged: (value) {
                            setState(() {
                              kValue = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            answers[3],
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 3,
                          groupValue: kValue,
                          onChanged: (value) {
                            setState(() {
                              kValue = value;
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
                                kValue = null;
                                widget.kPageController.animateToPage(currentPage,
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
                                            ? () {
                                                if (kFinalShuffledValue ==
                                                    kValue) {
                                                  currentScore++;
                                                } else {
                                                  currentScore--;
                                                }

                                                if (snapshot.data?.docs
                                                        .isNotEmpty ==
                                                    true) {
                                                  // Access the property safely
                                                  if (snapshot.data!.docs[0]
                                                          ['score'] <
                                                      currentScore) {
                                                    // Update the Firestore document
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'high-score')
                                                        .doc('alex')
                                                        .update({
                                                      'name': value.name
                                                          .toString()
                                                          .capitalize(),
                                                      'score': currentScore,
                                                    });
                                                  }

                                                  FirebaseFirestore.instance
                                                      .collection('scores')
                                                      .doc(value.name
                                                          .toString()
                                                          .capitalize())
                                                      .set({
                                                    'name': value.name,
                                                    'score': currentScore
                                                  });
                                                }
                                                Navigator.pushReplacementNamed(
                                                    context, '/result',
                                                    arguments: currentScore);
                                              }
                                            : () {
                                                if (kFinalShuffledValue ==
                                                    kValue) {
                                                  currentScore++;
                                                } else {
                                                  currentScore--;
                                                }
                                                currentPage++;
                                                kValue = null;
                                                widget.kPageController.animateToPage(
                                                    currentPage,
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    curve: Curves.easeIn);
                                                setState(() {});
                                              },
                                        style: ButtonStyle(
                                          backgroundColor: kValue == null
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
