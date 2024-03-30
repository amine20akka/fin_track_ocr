import 'package:fin_track_ocr/pages/authenticate/register.dart';
import 'package:fin_track_ocr/pages/authenticate/sign_in.dart';
import 'package:fin_track_ocr/pages/home.dart';
import 'package:fin_track_ocr/pages/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final AuthService _authService = AuthService();

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  // Instanciez votre service d'authentification
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService
          .user, // Utilisez le flux d'utilisateur de votre service d'authentification
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // Affichez le SplashScreen pendant que l'application vérifie l'état d'authentification
        } else {
          if (snapshot.hasData) {
            // L'utilisateur est authentifié, renvoyez Home avec l'uid
            return Home(uid: snapshot.data!.uid);
          } else {
            if (showSignIn) {
              return SignIn(toggleView: toggleView);
            } else {
              return Register(toggleView: toggleView);
            }
          }
        }
      },
    );
  }
}