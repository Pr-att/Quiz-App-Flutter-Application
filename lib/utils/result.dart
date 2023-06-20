import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/constants.dart';

import '../scores/score_add.dart';
import '../screens/result_screen.dart';

getResult(snapshot, value, BuildContext context, isMultipleChoice) async {
  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  if (isMultipleChoice ==
      Provider.of<QuizQuestion>(context, listen: false).category) {
    if (snapshot.data?.docs.isNotEmpty == true) {
      if (snapshot.data!.docs[0]['score'] <
          Provider.of<QuizQuestion>(context, listen: false).score) {
        isHighScore = true;
        showUpperStackCelebration = true;
        // Update the Firestore document
        await FirebaseFirestore.instance
            .collection('high-score')
            .doc('alex')
            .update({
          'name': value.name.toString().capitalize(),
          'score': Provider.of<QuizQuestion>(context, listen: false).score
        });
      }

      await FirebaseFirestore.instance
          .collection('scores')
          .doc(value.name.toString().capitalize())
          .set({
        'name': value.name,
        'score': Provider.of<QuizQuestion>(context, listen: false).score
      });
    }
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, '/result',
        arguments: Provider.of<QuizQuestion>(context, listen: false).score);
  } else {
    if (snapshot.data?.docs.isNotEmpty == true) {
      // Access the property safely
      if (snapshot.data!.docs[0]['score'] <
          Provider.of<QuizQuestion>(context, listen: false).score) {
        isHighScore = true;
        showUpperStackCelebration = true;

        // Update the Firestore document
        await FirebaseFirestore.instance
            .collection('high-score')
            .doc('alex')
            .update({
          'name': value.name.toString().capitalize(),
          'score': Provider.of<QuizQuestion>(context, listen: false).score,
        });
      }

      await FirebaseFirestore.instance
          .collection('scores')
          .doc(value.name.toString().capitalize())
          .set({
        'name': value.name,
        'score': Provider.of<QuizQuestion>(context, listen: false).score
      });
    }
    Navigator.of(context).pop();

    Navigator.pushReplacementNamed(
      context,
      '/result',
    );
  }
}
