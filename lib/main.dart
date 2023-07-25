import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/scores/score_add.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/options_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/scoreboard.dart';
import 'package:quiz_app/utils/firebaseAPI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAPI().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerScore()),
        ChangeNotifierProvider(create: (_) => QuizQuestion()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/options': (context) => const OptionScreen(),
        '/result': (context) => const ResultScreen(),
        '/scoreboard': (context) => const ScoreBoard(),
      },
      title: 'QuizIt',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(
        useMaterial3: true,
        scheme: FlexScheme.indigoM3,
      ),
      darkTheme: FlexThemeData.dark(
        useMaterial3: true,
        scheme: FlexScheme.indigoM3,
      ),
    );
  }
}
