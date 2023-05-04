import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

var data;
var noOfPlayers;

class ResultScreen extends StatelessWidget {
  ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Lottie.asset('asset/lottie/celebration.json', repeat: true, fit: BoxFit.cover,),
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
                        playerScore.name,
                        style: customStyleDark,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Score: $currentScore",
                    style: customStyleDark,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text("Restart", style: customStyleDarkSmall,),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('high-score')
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
                                      style: customStyleLight,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${snapshot.data!.docs[0]['name']}:${snapshot.data!.docs[0]['score']}",
                                      style: customStyleDark,
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('scores')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
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
                                          "${snapshot.data!.docs[index]['name']}'s score:",
                                          style: customStyleDarkSmall,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${snapshot.data!.docs[index]['score']}",
                                          style: customStyleLightSmall,
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
          ],
        ),
      ),
    );
  }
}
