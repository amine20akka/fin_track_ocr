import 'package:fin_track_ocr/pages/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required void Function() this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  late String email;
  late String password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SplashScreen()
        : Scaffold(
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
                    ],
                  ),
                ),
              ],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (value) => value!.length < 6
                            ? 'Enter a password 6+ characters long'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 15, 65, 132),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _authService
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error =
                                    'Could not sign in with those credentials !';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('You already have an account ?'),
                          TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.lightBlue[900]),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        error,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 174, 9, 31),
                            fontSize: 14.0),
                      ),
                    ],
                  ),
                )),
          );
  }
}
