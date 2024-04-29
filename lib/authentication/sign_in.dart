import 'package:fin_track_ocr/pages/splash_screen/splash_screen.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/shared/input_decoration_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required void Function() this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
            backgroundColor: const Color.fromARGB(248, 243, 239, 239),
            body: Column(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.asset(
                          'assets/Budget.jpg',
                          width: 350.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 50.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(height: 20.0),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration:
                                          textInputDecoration.copyWith(hintText: 'Email'),
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
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'Password'),
                                      obscureText: true,
                                      validator: (value) => value!.isEmpty
                                          ? 'Please enter your password'
                                          : null,
                                      onChanged: (val) {
                                        password = val;
                                      },
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      error,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 174, 9, 31),
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(height: 30.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromARGB(255, 15, 65, 132),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _authService
                                              .signInWithEmailAndPassword(
                                                  email, password);
                                          if (result == null) {
                                            setState(() {
                                              error =
                                                  'Verify your password or/and your email !';
                                              loading = false;
                                            });
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text('You don\'t have an account ?'),
                                        TextButton(
                                          onPressed: () {
                                            widget.toggleView();
                                          },
                                          child: Text(
                                            'Register',
                                            style:
                                                TextStyle(color: Colors.lightBlue[900]),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          );
  }
}
