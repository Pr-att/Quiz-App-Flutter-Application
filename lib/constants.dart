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
