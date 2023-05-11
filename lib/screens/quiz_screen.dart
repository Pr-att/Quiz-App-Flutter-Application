import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/scores/score_add.dart';
import '../utils/timer.dart';

var response;
var result;
var _finalShuffledValue;
var _correctBoolAnswer;

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

var currentPage = 0;
var _value;
var currentScore = 0;

class _QuizScreenState extends State<QuizScreen> {

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

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
                  CountdownTimer(
                    seconds: 60,
                    onTimerFinished: () {
                      print("Timer finished!");
                    },
                  ),
                ],
              ),
            ),
            Provider.of<QuizQuestion>(context, listen: false).type == 'multiple'
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: result['results'].length,
                      itemBuilder: (context, index) {
                        var answers =
                            result['results'][index]['incorrect_answers'];
                        var position = Random().nextInt(3);
                        var correctAnswer =
                            result['results'][index]['correct_answer'];
                        if (!answers.contains(correctAnswer)) {
                          _finalShuffledValue = position;
                          answers.insert(position, correctAnswer);
                        }

                        print(correctAnswer);
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      RadioListTile(
                                        title: Text(
                                          answers[0],
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 0,
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: Text(
                                          answers[1],
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 1,
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: Text(
                                          answers[2],
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 2,
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: Text(
                                          answers[3],
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 3,
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
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
                                              _value = null;
                                              _controller.animateToPage(
                                                  currentPage,
                                                  duration: const Duration(
                                                      milliseconds: 100),
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
                                                  builder:
                                                      (BuildContext context,
                                                          value,
                                                          Widget? child) {
                                                    return ElevatedButton(
                                                      onPressed: currentPage ==
                                                              result['results']
                                                                      .length -
                                                                  1
                                                          ? () {
                                                              if (_finalShuffledValue ==
                                                                  _value) {
                                                                currentScore++;
                                                              } else {
                                                                currentScore--;
                                                              }

                                                              if (snapshot.data!
                                                                          .docs[0]
                                                                      [
                                                                      'score'] <
                                                                  currentScore) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'high-score')
                                                                    .doc('alex')
                                                                    .update({
                                                                  'name': value
                                                                      .name
                                                                      .toString()
                                                                      .capitalize(),
                                                                  'score':
                                                                      currentScore
                                                                });
                                                              }

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'scores')
                                                                  .doc(value
                                                                      .name
                                                                      .toString())
                                                                  .set({
                                                                'name':
                                                                    value.name,
                                                                'score':
                                                                    currentScore
                                                              });
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                      context,
                                                                      '/result',
                                                                      arguments:
                                                                          currentScore);
                                                            }
                                                          : () {
                                                              if (_finalShuffledValue ==
                                                                  _value) {
                                                                currentScore++;
                                                              } else {
                                                                currentScore--;
                                                              }
                                                              currentPage++;
                                                              _value = null;
                                                              _controller.animateToPage(
                                                                  currentPage,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          100),
                                                                  curve: Curves
                                                                      .easeIn);
                                                              setState(() {});
                                                            },
                                                      style: ButtonStyle(
                                                        backgroundColor: _value ==
                                                                null
                                                            ? MaterialStateProperty
                                                                .all(Colors
                                                                    .brown[100])
                                                            : MaterialStateProperty
                                                                .all(Colors
                                                                        .purple[
                                                                    500]),
                                                      ),
                                                      child: currentPage <
                                                              result['results']
                                                                      .length -
                                                                  1
                                                          ? const Text(
                                                              'Next',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : const Text(
                                                              'Submit',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: result['results'].length,
                      itemBuilder: (context, index) {
                        _correctBoolAnswer =
                            result['results'][index]['correct_answer'];

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
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      RadioListTile(
                                        title: Text(
                                          'True',
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 'True',
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: Text(
                                          'False',
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 20),
                                        ),
                                        value: 'False',
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
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
                                              _value = null;
                                              _controller.animateToPage(
                                                  currentPage,
                                                  duration: const Duration(
                                                      milliseconds: 100),
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
                                                  builder:
                                                      (BuildContext context,
                                                          value,
                                                          Widget? child) {
                                                    return ElevatedButton(
                                                      onPressed: currentPage ==
                                                              result['results']
                                                                      .length -
                                                                  1
                                                          ? () {
                                                              if (_correctBoolAnswer ==
                                                                  _value) {
                                                                currentScore++;
                                                              } else {
                                                                currentScore--;
                                                              }

                                                              if (snapshot.data!
                                                                          .docs[0]
                                                                      [
                                                                      'score'] <
                                                                  currentScore) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'high-score')
                                                                    .doc('alex')
                                                                    .update({
                                                                  'name': value
                                                                      .name
                                                                      .toString()
                                                                      .capitalize(),
                                                                  'score':
                                                                      currentScore
                                                                });
                                                              }
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'scores')
                                                                  .doc(value
                                                                      .name
                                                                      .toString()
                                                                      .capitalize())
                                                                  .set({
                                                                'name':
                                                                    value.name,
                                                                'score':
                                                                    currentScore
                                                              });

                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                context,
                                                                '/result',
                                                              );
                                                            }
                                                          : () {
                                                              if (_correctBoolAnswer ==
                                                                  _value) {
                                                                currentScore++;
                                                              } else {
                                                                currentScore--;
                                                              }
                                                              currentPage++;
                                                              _value = null;
                                                              _controller.animateToPage(
                                                                  currentPage,
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          100),
                                                                  curve: Curves
                                                                      .easeIn);
                                                              setState(() {});
                                                            },
                                                      style: ButtonStyle(
                                                        backgroundColor: _value ==
                                                                null
                                                            ? MaterialStateProperty
                                                                .all(Colors
                                                                    .brown[100])
                                                            : MaterialStateProperty
                                                                .all(Colors
                                                                        .purple[
                                                                    500]),
                                                      ),
                                                      child: currentPage <
                                                              result['results']
                                                                      .length -
                                                                  1
                                                          ? const Text(
                                                              'Next',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : const Text(
                                                              'Submit',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                  ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
