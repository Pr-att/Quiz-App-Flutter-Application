import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/constants.dart';

var data;
var noOfPlayers;
bool showUpperStackCelebration = false;

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({super.key});

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Visibility(
              visible: true,
              child: Lottie.asset(
                'asset/lottie/celebrations(1).json',
                repeat: true,
                fit: BoxFit.cover,
                frameRate: FrameRate.max,
              ),
            ),
            ListView(
              children: [
                Visibility(
                  visible: true,
                  child: Lottie.asset(
                    'asset/lottie/celebrations(1).json',
                    repeat: true,
                    fit: BoxFit.cover,
                    frameRate: FrameRate.max,
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
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber[50]!,
                          Colors.orange[100]!,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
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
                                          color: CupertinoColors.black),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${snapshot.data!.docs[0]['name'].toString().capitalize()}:${snapshot.data!.docs[0]['score']}",
                                      style: customStyleDark.copyWith(
                                          color: CupertinoColors.systemPurple),
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
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                String question = '';
                                String category = '';
                                String level = '';
                                try {
                                  question =
                                      snapshot.data?.docs[index]['question'];
                                  category =
                                      snapshot.data?.docs[index]['category'];
                                  level = snapshot.data?.docs[index]['level'];
                                } catch (e) {
                                  level = 'NA';
                                  question = 'NA';
                                  category = 'NA';
                                }
                                return ListTile(
                                  dense: true,
                                  trailing: Text(
                                    "${snapshot.data!.docs[index]['score']}",
                                    style: customStyleDarkSmall.copyWith(
                                        color: CupertinoColors.black),
                                  ),
                                  // How to set text on the bottom of the list tile

                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.docs[index]['name']
                                              .toString()
                                              .capitalize(),
                                          style: customStyleDarkSmall.copyWith(
                                              color: CupertinoColors.black),
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.circleInfo,
                                            size: 20,
                                            color: Colors.grey.shade600,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text('Details'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Name: ',
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['name']
                                                                .toString()
                                                                .capitalize(),
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Score: ',
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['score']
                                                                .toString(),
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Level: ',
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            level.toString(),
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Category: ',
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            category.toString(),
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'Question: ',
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            question.toString(),
                                                            style:
                                                                customStyleDarkSmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: Text(
                                    '${index + 1})',
                                    style: customStyleDarkSmall.copyWith(
                                        color: CupertinoColors.black),
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
                  visible:
                      isHighScore == true && showUpperStackCelebration == true,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset(
                      'asset/lottie/celebrations(1).json',
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 40,
              right: 0.0,
              child: Transform.rotate(
                angle: 0.5,
                child: SvgPicture.asset(
                  'asset/images/crown.svg',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
