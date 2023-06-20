import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
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
                        if (value!.length < 5) {
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
                      icon: const Icon(Icons.flutter_dash),
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
                      icon: const Icon(Icons.flutter_dash),
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
                      icon: const Icon(Icons.flutter_dash),
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
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
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
