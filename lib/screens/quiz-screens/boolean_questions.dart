import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../scores/score_add.dart';
import '../../utils/result.dart';
import '../quiz_screen.dart';

class Boolean extends StatefulWidget {
  const Boolean({Key? key}) : super(key: key);

  @override
  State<Boolean> createState() => _BooleanState();
}

class _BooleanState extends State<Boolean> {
  List<String?> correctBooleanAnswersList = List.generate(
      result['results'].length,
      (index) => result['results'][index]['correct_answer']);

  List<String?> userBooleanAnswersList =
      List.generate(result['results'].length, (index) => null);

  var unescape = HtmlUnescape();
  final kPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: kPageController,
        itemCount: result['results'].length,
        itemBuilder: (context, index) {
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
                            'True',
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 'True',
                          groupValue: userBooleanAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userBooleanAnswersList[index] = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(
                            'False',
                            style: GoogleFonts.robotoMono(fontSize: 20),
                          ),
                          value: 'False',
                          groupValue: userBooleanAnswersList[index],
                          onChanged: (value) {
                            setState(() {
                              userBooleanAnswersList[index] = value;
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
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: Colors.red[300],
                                shape: const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.brown, width: 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Provider.of<QuizQuestion>(context,
                                        listen: false)
                                    .previousPage();
                                kPageController.animateToPage(
                                    Provider.of<QuizQuestion>(context,
                                            listen: false)
                                        .page,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut);
                                setState(() {});
                              },
                              child: const Text(
                                'Previous',
                                style: TextStyle(color: Colors.black),
                              ),
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
                                        onPressed: Provider.of<QuizQuestion>(
                                                        context,
                                                        listen: false)
                                                    .page ==
                                                result['results'].length - 1
                                            ? () async {
                                                for (int i = 0;
                                                    i <
                                                        correctBooleanAnswersList
                                                            .length;
                                                    i++) {
                                                  if (userBooleanAnswersList[
                                                          i] ==
                                                      correctBooleanAnswersList[
                                                          i]) {
                                                    Provider.of<QuizQuestion>(
                                                            context,
                                                            listen: false)
                                                        .correctAnswer();
                                                  } else if (userBooleanAnswersList[
                                                          i] ==
                                                      null) {
                                                    continue;
                                                  } else {
                                                    Provider.of<QuizQuestion>(
                                                            context,
                                                            listen: false)
                                                        .wrongAnswer();
                                                  }
                                                }
                                                await getResult(snapshot, value,
                                                    context, 'boolean');
                                              }
                                            : () {
                                                Provider.of<QuizQuestion>(
                                                        context,
                                                        listen: false)
                                                    .nextPage();
                                                kPageController.animateToPage(
                                                    Provider.of<QuizQuestion>(
                                                            context,
                                                            listen: false)
                                                        .page,
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    curve: Curves.easeIn);
                                                setState(() {});
                                              },
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(5),
                                          shadowColor:
                                              MaterialStateProperty.all(
                                                  Colors.red[300]),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.brown,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              userBooleanAnswersList[index] ==
                                                      null
                                                  ? null
                                                  : MaterialStateProperty.all(
                                                      Colors.blueGrey[300]),
                                        ),
                                        child: Provider.of<QuizQuestion>(
                                                        context,
                                                        listen: false)
                                                    .page <
                                                result['results'].length - 1
                                            ? const Text(
                                                'Next',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            : const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      );
                                    },
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible: userBooleanAnswersList[index] != null,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity:
                              userBooleanAnswersList[index] != null ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  userBooleanAnswersList[index] = null;
                                });
                              },
                              label: Text(
                                'Clear',
                                style: GoogleFonts.robotoMono(),
                              ),
                              icon: const Icon(Icons.clear),
                              backgroundColor: Colors.red[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            Provider.of<QuizQuestion>(context, listen: false).setPage(index);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    kPageController.dispose();
    super.dispose();
  }
}
