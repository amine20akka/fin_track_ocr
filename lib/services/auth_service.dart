import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return user;
      } else {
        return null; // L'utilisateur est déconnecté, donc retournez null
      }
    });
  }

  Future<String?> getUserEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        user = _auth.currentUser; // Get the updated user data
        return user!.email;
      } else {
        return null; // User is not signed in
      }
    } catch (e) {
      debugPrint('debug: ${e.toString()}');
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      debugPrint('debug: ${e.toString()}');
      return null;
    }
  }

  // register in with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create a new document for the user with the uid
      //await DatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);

      return user;
    } catch (e) {
      debugPrint('debug: ${e.toString()}');
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint('debug: ${e.toString()}');
      return null;
    }
  }
}
