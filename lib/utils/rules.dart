import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rule extends StatelessWidget {
  final String text;

  const Rule({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.arrow_circle_right_outlined,
        color: Colors.cyan,
      ),
      title: Text(
        text,
        style: GoogleFonts.robotoMono(),
      ),
    );
  }
}
