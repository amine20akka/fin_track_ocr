import 'package:fin_track_ocr/pages/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/input_decoration_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required void Function() this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordVisible = true;
  bool _passwordConfirmed = false;
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  late String firstName;
  late String lastName;
  late String email;
  late String password;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SplashScreen()
        : Scaffold(
            backgroundColor: const Color.fromARGB(249, 238, 232, 232),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70.0,
                  ),
                  Image.asset(
                    'assets/fintrack-ocr-high-resolution-logo-transparent.png',
                    width: 320.0,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration
                                .copyWith(hintText: 'First Name')
                                .copyWith(
                                    prefixIcon:
                                        const Icon(Icons.person_2_outlined)),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your first name'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                firstName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration
                                .copyWith(hintText: 'Last Name')
                                .copyWith(
                                    prefixIcon:
                                        const Icon(Icons.person_2_outlined)),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your last name'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                lastName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration
                                .copyWith(hintText: 'Email')
                                .copyWith(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined)),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your email'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration
                                .copyWith(hintText: 'Password')
                                .copyWith(
                                    prefixIcon: const Icon(Icons.lock_outline))
                                .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(
                                        () {
                                          passwordVisible = !passwordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your password'
                                : null,
                            obscureText: passwordVisible,
                            onChanged: (val) {
                              password = val;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration
                                .copyWith(hintText: 'Confirm Password')
                                .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(
                                        () {
                                          passwordVisible = !passwordVisible;
                                        },
                                      );
                                    },
                                  ),
                                )
                                .copyWith(
                                    prefixIcon:
                                        const Icon(Icons.check_box_outlined)),
                            validator: (value) {
                              if (value != password) {
                                _passwordConfirmed = false;
                                return 'Please re-enter your password';
                              } else {
                                _passwordConfirmed = true;
                                return null;
                              }
                            },
                            obscureText: passwordVisible,
                          ),
                          const SizedBox(height: 40.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 15, 65, 132),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _passwordConfirmed) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService
                                    .registerWithEmailAndPassword(
                                        email, password);
                                if (result != null) {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  final DatabaseService databaseService =
                                      DatabaseService(uid: user!.uid);
                                  await databaseService.updateUserData(
                                      firstName, lastName);
                                  widget.toggleView();
                                } else {
                                  setState(() {
                                    error = 'Could not register!';
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
                          const SizedBox(
                            height: 20.0,
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
                                  style:
                                      TextStyle(color: Colors.lightBlue[900]),
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
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
