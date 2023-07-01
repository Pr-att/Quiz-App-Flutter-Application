import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

import '../utils/quiz_question.dart';
import '../utils/rules.dart';

var _difficulty;
var _type;
var _category;
bool reported = false;

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noOfQuestionsController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  late StreamSubscription subscription;
  bool? connected;

  @override
  void initState() {
    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      if (hasInternet) {
        setState(() {
          connected = true;
        });
      } else {
        setState(() {
          connected = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'QuizIT',
            style: GoogleFonts.trispace(fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              iconSize: 30,
              onPressed: () {
                if (connected!) {
                  Navigator.pushReplacementNamed(context, '/scoreboard');
                }
              },
              icon: Icon(
                Icons.leaderboard,
                color: Colors.amber.shade600,
              ),
            ),
            IconButton(
              iconSize: 30,
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
                                    const Rule(
                                        text:
                                            'The user will be given 15 seconds to answer each question. So total time for the '
                                            'quiz will be (no. of questions * 15) seconds.'),
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
                                          repeat: true,
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
                  },
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.black,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'asset/images/quiz.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                    Text(
                      "Customize your Quiz",
                      style: customStyleDark,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        var alphabetCount = 0;
                        for (int i = 0; i < value!.length; i++) {
                          int charCode = value.codeUnitAt(i);
                          if ((charCode >= 65 && charCode <= 90) ||
                              (charCode >= 97 && charCode <= 122)) {
                            alphabetCount++;
                          }
                        }
                        if (alphabetCount < 5) {
                          return 'Name must be at-least 5 characters long';
                        }
                        return null;
                      },
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: 'Enter Your Name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid no. of questions';
                        }
                        return null;
                      },
                      controller: _noOfQuestionsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        labelText: 'Enter no. of questions',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButton(
                      value: _difficulty,
                      isExpanded: true,
                      style: GoogleFonts.robotoMono(color: Colors.black),
                      icon: SvgPicture.asset(
                        'asset/images/level.svg',
                        height: 30,
                        width: 30,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      hint: const Text('Select Difficulty'),
                      items: const [
                        DropdownMenuItem(
                          value: 'easy',
                          child: Text('Easy'),
                        ),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(
                          value: 'hard',
                          child: Text('Hard'),
                        ),
                      ],
                      onChanged: (value) {
                        _difficulty = value!;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButton(
                      value: _category,
                      isExpanded: true,
                      style: GoogleFonts.robotoMono(color: Colors.black),
                      icon: SvgPicture.asset(
                        'asset/images/category.svg',
                        height: 25,
                        width: 25,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      hint: const Text('Select Category'),
                      items: const [
                        DropdownMenuItem(
                          value: '9',
                          child: Text('General Knowledge'),
                        ),
                        DropdownMenuItem(
                          value: '10',
                          child: Text('Entertainment: Books'),
                        ),
                        DropdownMenuItem(
                          value: '11',
                          child: Text('Entertainment: Film'),
                        ),
                        DropdownMenuItem(
                          value: '17',
                          child: Text('Science & Nature'),
                        ),
                        DropdownMenuItem(
                          value: '19',
                          child: Text('Science: Mathematics'),
                        ),
                        DropdownMenuItem(
                          value: '20',
                          child: Text('Mythology'),
                        ),
                        DropdownMenuItem(
                          value: '21',
                          child: Text('Sports'),
                        ),
                        DropdownMenuItem(
                          value: '26',
                          child: Text('Celebrities'),
                        ),
                        DropdownMenuItem(
                          value: '27',
                          child: Text('Animals'),
                        ),
                        DropdownMenuItem(
                          value: '31',
                          child: Text('Entertainment: Japanese Anime & Manga'),
                        ),
                      ],
                      onChanged: (value) {
                        _category = value!;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButton(
                      value: _type,
                      isExpanded: true,
                      style: GoogleFonts.robotoMono(color: Colors.black),
                      icon: SvgPicture.asset(
                        'asset/images/type.svg',
                        height: 30,
                        width: 30,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      hint: const Text('Select Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 'multiple',
                          child: Text('Multiple Choice'),
                        ),
                        DropdownMenuItem(
                          value: 'boolean',
                          child: Text('True/False'),
                        ),
                      ],
                      onChanged: (value) {
                        _type = value!;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (connected == true) {
                          if (_formKey.currentState!.validate() &&
                              _difficulty != null &&
                              _category != null &&
                              _type != null) {
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: Container(
                                    child: Lottie.asset(
                                  'asset/lottie/loading.json',
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  frameRate: FrameRate.max,
                                )),
                              ),
                            );
                            Provider.of<PlayerScore>(context, listen: false)
                                .setName(_nameController.text);
                            Provider.of<QuizQuestion>(context, listen: false)
                                .setAmount(_noOfQuestionsController.text);
                            Provider.of<QuizQuestion>(context, listen: false)
                                .setCategory(_category);
                            Provider.of<QuizQuestion>(context, listen: false)
                                .setDifficulty(_difficulty);
                            Provider.of<QuizQuestion>(context, listen: false)
                                .setType(_type);

                            result = await question(context);

                            if (result['response_code'] != 0) {
                              Navigator.pop(context);
                              questionError(context);
                            } else {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/quiz');
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color:
                                connected == true ? Colors.green : Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Icon(
                        connected == true
                            ? Icons.start_rounded
                            : Icons.error_outline_rounded,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      connected == true ? 'Start' : 'No Internet Connection',
                      style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          color: connected == true ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    _noOfQuestionsController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

void questionError(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: AlertDialog(
                  title: const Text(
                    'Sorry, but the customization settings you\'ve chosen don\'t currently have matching quiz '
                    'results. Try these tips:',
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Rule(text: 'Adjust difficulty level.'),
                        const Rule(text: 'Explore different categories.'),
                        const Rule(
                            text: 'Experiment with the number of questions.'),
                        const SizedBox(height: 10),
                        Text(
                          'Explore various combinations and discover new quizzes. Need assistance? Let us know!',
                          style: GoogleFonts.robotoMono(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Visibility(
                      visible: !reported,
                      child: TextButton(
                        onPressed: () async {
                          await reportQuestionMissing(context);
                        },
                        child: const Text('Report'),
                      ),
                    ),
                    Visibility(
                      visible: reported,
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> reportQuestionMissing(BuildContext context) async {
  Future.delayed(const Duration(seconds: 3), () {
    reported = true;
    Navigator.pop(context);
  });
}
