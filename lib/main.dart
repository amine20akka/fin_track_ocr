import 'package:fin_track_ocr/firebase_options.dart';
import 'package:fin_track_ocr/pages/authenticate/authenticate.dart';
// import 'package:fin_track_ocr/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that Flutter bindings have been initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Authentication(),
        // '/home': (context) => Home(u),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
