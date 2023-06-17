import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../scores/score_add.dart';
import '../../utils/result.dart';
import '../quiz_screen.dart';

// ignore: must_be_immutable
class Boolean extends StatefulWidget {
  final PageController kPageController;

  const Boolean({super.key, required this.kPageController});

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

  @override
  void initState() {
    print(result);
    print(correctBooleanAnswersList);
    print(userBooleanAnswersList);
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
                                                        correctBooleanAnswersList
                                                            .length;
                                                    i++) {
                                                  if (userBooleanAnswersList[
                                                          i] ==
                                                      correctBooleanAnswersList[
                                                          i]) {
                                                    currentScore++;
                                                  } else if (userBooleanAnswersList[
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
                                              userBooleanAnswersList[index] ==
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
