import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import '../utils/quiz_question.dart';

var _difficulty;
var _type;
var _category;

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  var _noOfQuestionsController;
  var _nameController;

  @override
  void initState() {
    _noOfQuestionsController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Customize your Quiz",
                  style: customStyleDark,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
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
                  controller: _noOfQuestionsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Questions in multiples of 5',
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
                    if (_nameController.text.isEmpty ||
                        _noOfQuestionsController.text.isEmpty ||
                        // int.parse(_noOfQuestionsController.text) % 5 != 0 ||
                        _noOfQuestionsController.text == '0' ||
                        _difficulty == null ||
                        _category == null ||
                        _type == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Correctly Fill the Form'),
                        ),
                      );
                      return;
                    }

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
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/quiz');
                  },
                  child: const Text('Start Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noOfQuestionsController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
