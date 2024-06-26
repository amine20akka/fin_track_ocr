import 'dart:io';

import 'package:fin_track_ocr/pages/splash_screen/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/input_decoration_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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
  String password = '';
  String error = '';
  String? imageUrl;
  double budget = 0;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageUrl =
            pickedFile.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SplashScreen()
        : Scaffold(
            backgroundColor: const Color.fromARGB(249, 238, 232, 232),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  Image.asset(
                    'assets/fintrack-ocr-high-resolution-logo-transparent.png',
                    width: 320.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: imageUrl != null
                                  ? FileImage(File(imageUrl!))
                                  : const AssetImage(
                                      'assets/default_profile_image.png',
                                    ) as ImageProvider,
                            ),
                            if (imageUrl != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imageUrl =
                                          null; // Clear the imageUrl to remove the image
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.cancel,
                                      color: Color.fromARGB(255, 186, 38, 27),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 21, 21, 21),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Color.fromARGB(255, 221, 215, 215),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
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
                                    keyboardType: TextInputType.name,
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'First Name')
                                        .copyWith(
                                            prefixIcon:
                                                const Icon(Icons.person_2_outlined)),
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    // Vérifie si le nom contient uniquement des lettres alphabétiques
                                    if (!RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ]+$')
                                        .hasMatch(value)) {
                                      return 'Please enter only alphabetical characters';
                                    }
                                    // Vérifie si la longueur du nom est d'au moins 2 caractères
                                    if (value.length < 2) {
                                      return 'First name must be at least 2 characters';
                                    }
                                    return null; // Retourne null si la saisie est valide
                                  },
                                    onChanged: (val) {
                                      setState(() {
                                        firstName = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'Last Name')
                                        .copyWith(
                                            prefixIcon:
                                                const Icon(Icons.person_2_outlined)),
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                    // Vérifie si le nom contient uniquement des lettres alphabétiques
                                    if (!RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ]+$')
                                        .hasMatch(value)) {
                                      return 'Please enter only alphabetical characters';
                                    }
                                    // Vérifie si la longueur du nom est d'au moins 2 caractères
                                    if (value.length < 2) {
                                      return 'Last name must be at least 2 characters';
                                    }
                                    return null; // Retourne null si la saisie est valide
                                  },
                                    onChanged: (val) {
                                      setState(() {
                                        lastName = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'Email')
                                        .copyWith(
                                            prefixIcon:
                                                const Icon(Icons.email_outlined)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter an email';
                                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
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
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters long';
                                    }
                                    if (!RegExp(
                                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                        .hasMatch(value)) {
                                      return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
                                    }
                                    return null;
                                  },
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
                                                passwordVisible =
                                                    !passwordVisible;
                                              },
                                            );
                                          },
                                        ),
                                      )
                                      .copyWith(
                                          prefixIcon: const Icon(
                                              Icons.check_box_outlined)),
                                  validator: (value) {
                                    if (value != password || value!.isEmpty) {
                                      _passwordConfirmed = false;
                                      return 'Please re-enter your password';
                                    } else {
                                      _passwordConfirmed = true;
                                      return null;
                                    }
                                  },
                                  obscureText: passwordVisible,
                                ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    decoration: textInputDecoration
                                        .copyWith(hintText: 'Monthly Budget')
                                        .copyWith(
                                            prefixIcon:
                                                const Icon(Icons.monetization_on_outlined))
                                        .copyWith(
                                            suffixText: 'TND'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please set your monthly budget';
                                    } else if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    } else if (double.parse(value) <= 0) {
                                      return 'Please enter a budget greater than zero';
                                    }
                                    return null; // Retourne null si la validation réussit
                                  },
                                    onChanged: (value) {
                                      setState(() {
                                        budget = double.tryParse(value) ??
                                            0; // If parsing fails, set budget to 0
                                      });
                                    },
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
                                          await databaseService.createUser(
                                              firstName, lastName, imageUrl, budget);
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
                  ),
                ],
              ),
          );
  }
}
