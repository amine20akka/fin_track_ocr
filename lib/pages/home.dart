import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: const Color.fromARGB(249, 238, 232, 232),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 174, 9, 31),
              elevation: 0.0,
              actions: [
                SizedBox(
                  width: MediaQuery.of(context).size.width, // Largeur maximale
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/fintrack-ocr-favicon-black.png',
                        width: 100,
                        height: 50,
                      ),
                      const Text(
                        'FinTrack OCR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.person),
                  label: const Text('Logout'),
                ),
                    ],
                  ),
                ),
              ],
            ),
            body: const Text('Home'),
    );
  }
}