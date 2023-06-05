import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import '../../scores/score_add.dart';
import '../quiz_screen.dart';

// ignore: must_be_immutable
class Boolean extends StatefulWidget {
  final PageController kPageController;
  late String correctBoolAnswer;
  Boolean(
      {super.key,
      required this.kPageController,
      required this.correctBoolAnswer});

  @override
  State<Boolean> createState() => _BooleanState();
}

class _BooleanState extends State<Boolean> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget.kPageController,
        itemCount: result['results'].length,
        itemBuilder: (context, index) {
          widget.correctBoolAnswer = result['results'][index]['correct_answer'];

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
                            'True',
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 'True',
                          groupValue: kValue,
                          onChanged: (value) {
                            setState(() {
                              kValue = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            'False',
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 'False',
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
                                            ? () {
                                                if (kCorrectBoolAnswer ==
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
                                                  context,
                                                  '/result',
                                                );
                                              }
                                            : () {
                                                if (kCorrectBoolAnswer ==
                                                    kValue) {
                                                  currentScore++;
                                                } else {
                                                  currentScore--;
                                                }
                                                currentPage++;
                                                kValue = null;
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
