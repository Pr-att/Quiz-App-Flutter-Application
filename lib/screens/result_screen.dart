import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:url_launcher/url_launcher.dart';

import 'options_screen.dart';

var data;
var noOfPlayers;
bool showUpperStackCelebration = false;

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool kSurveyRequest = false;

  surveyRequest() async {
    await FirebaseFirestore.instance
        .collection('survey')
        .doc('survey')
        .get()
        .then((value) {
      if (value.exists) {
        kSurveyRequest = value['on'];
        if (kSurveyRequest) {
          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              showSnackBar(context,
                  'Would you kindly take a moment to participate in our survey?');
            });
          });
        }
      }
    });
  }

  @override
  void initState() {
    surveyRequest();
    Timer(const Duration(seconds: 7), () {
      setState(() {
        showUpperStackCelebration = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ListView(
                children: [
                  Visibility(
                    visible: isHighScore,
                    child: Lottie.asset(
                      'asset/lottie/celebrations(1).json',
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Visibility(
                    visible: isHighScore,
                    child: Lottie.asset(
                      'asset/lottie/celebrations(1).json',
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Visibility(
                    visible: isHighScore,
                    child: Lottie.asset(
                      'asset/lottie/celebrations(1).json',
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<PlayerScore>(
                      builder: (context, playerScore, child) {
                        return Text(
                          playerScore.name.toString().capitalize(),
                          style: customStyleDark,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Score: ${Provider.of<QuizQuestion>(context, listen: false).score}",
                      style: customStyleDark,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shadowColor: Colors.red[300],
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.brown, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<QuizQuestion>(context, listen: false)
                                .restart();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OptionScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Restart",
                            style: customStyleDarkSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        gradient: SweepGradient(
                          startAngle: 0.0,
                          endAngle: 7.0,
                          colors: [
                            Colors.amber[100]!,
                            Colors.orange[300]!,
                            Colors.amber[100]!,
                            Colors.amber[100]!,
                            Colors.orange[300]!,
                            Colors.amber[100]!,
                            Colors.orange[300]!,
                            Colors.amber[100]!,
                            Colors.orange[300]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('scores')
                              .orderBy("score", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Highest Score",
                                        style: customStyleDark.copyWith(
                                            color: Colors.black),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${snapshot.data!.docs[0]['name'].toString().capitalize()}:${snapshot.data!.docs[0]['score']}",
                                        style: customStyleDark.copyWith(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Scores', style: customStyleDark),
                    ),
                    // SearchBar(),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('scores')
                          .orderBy("score", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple[50]!,
                                    Colors.grey[100]!,
                                    Colors.purple[50]!,
                                    Colors.grey[100]!,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${index + 1})',
                                            style: customStyleDarkSmall
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "${snapshot.data?.docs[index]['name']}",
                                            style: customStyleDarkSmall
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(' : ',
                                            style: customStyleDarkSmall
                                                .copyWith(color: Colors.black)),
                                        const Expanded(child: SizedBox()),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${snapshot.data!.docs[index]['score']}",
                                            style: customStyleDarkSmall
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isHighScore == true &&
                        showUpperStackCelebration == true,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Lottie.asset(
                        'asset/lottie/celebrations(1).json',
                        repeat: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isHighScore == true &&
                        showUpperStackCelebration == true,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Lottie.asset(
                        'asset/lottie/celebrations(2).json',
                        height: 300,
                        width: 300,
                        repeat: true,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchInWebViewOrVC(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),
      showCloseIcon: true,
      duration: const Duration(seconds: 10),
      backgroundColor: Colors.teal[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Yes',
        disabledTextColor: Colors.black,
        textColor: Colors.blueGrey[900],
        onPressed: () async {
          await _launchInWebViewOrVC(
            Uri.parse('https://forms.gle/txD7XwDgnh61W8UQA'),
          );
          //Do whatever you want
        },
      ),
    ),
  );
}
