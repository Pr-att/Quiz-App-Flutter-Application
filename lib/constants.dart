import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showProgress(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    },
  );
}

TextStyle customStyleDark = GoogleFonts.robotoMono(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

TextStyle customStyleLight = GoogleFonts.robotoMono(
  fontSize: 25,
  fontWeight: FontWeight.w300,
);

TextStyle customStyleLightSmall = GoogleFonts.robotoMono(
  fontSize: 15,
  fontWeight: FontWeight.w300,
);

TextStyle customStyleDarkSmall = GoogleFonts.robotoMono(
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

bool isHighScore = false;

Map<String, String> categoryType = {
  '9': 'General Knowledge',
  '10': 'Entertainment: Books',
  '11': 'Entertainment: Film',
  '17': 'Science & Nature',
  '19': 'Science: Mathematics',
  '20': 'Mythology',
  '21': 'Sports',
  '26': 'Celebrities',
  '27': 'Animals',
  '31': 'Entertainment: Japanese Anime & Manga',
};
