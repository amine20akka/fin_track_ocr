import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(249, 238, 232, 232),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Image(
            image: AssetImage(
                'assets/fintrack-ocr-high-resolution-logo-transparent.png'),
            width: 330.0,
          ),
          SizedBox(height: 40.0,),
          SpinKitFoldingCube(
            color: Color.fromARGB(255, 15, 64, 129),
            size: 35.0,
          ),
        ]),
      ),
    );
  }
}
