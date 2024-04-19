import 'dart:io';

import 'package:fin_track_ocr/models/user.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/input_decoration_auth.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfile extends StatefulWidget {
  final String uid;

  const ViewProfile({super.key, required this.uid});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late double budget;
  late String? imageUrl;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageUrl = pickedFile.path;
        DatabaseService(uid: widget.uid).updateProfileImageUrl(imageUrl);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(249, 238, 232, 232),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: DatabaseService(uid: widget.uid).userData,
          builder: (context, AsyncSnapshot<UserData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshot.hasData) {
              firstName = snapshot.data!.firstName;
              lastName = snapshot.data!.lastName;
              budget = snapshot.data!.budget;
              imageUrl = snapshot.data!.profileImageUrl;

              return Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        gradient: myLinearGradient,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 30.0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'My profile',
                                style: GoogleFonts.poly(
                                  color: Colors.grey[200],
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Icon(
                                color: Colors.grey[200],
                                Icons.person,
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
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
                                  imageUrl = null;
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
                    const SizedBox(
                      height: 40.0,
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
                              initialValue: firstName,
                              decoration: textInputDecoration
                                  .copyWith(hintText: 'First Name')
                                  .copyWith(
                                      prefixIcon:
                                          const Icon(Icons.person_2_outlined)),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your first name'
                                  : null,
                              onChanged: (val) {
                                firstName = val;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: lastName,
                              decoration: textInputDecoration
                                  .copyWith(hintText: 'Last Name')
                                  .copyWith(
                                      prefixIcon:
                                          const Icon(Icons.person_2_outlined)),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your last name'
                                  : null,
                              onChanged: (val) {
                                lastName = val;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              initialValue: budget.toStringAsFixed(2),
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration
                                  .copyWith(hintText: 'Monthly Budget')
                                  .copyWith(suffixText: 'TND')
                                  .copyWith(
                                      prefixIcon: const Icon(
                                          Icons.monetization_on_outlined)),
                              validator: (value) => value!.isEmpty
                                  ? 'Please set your monthly budget'
                                  : null,
                              onChanged: (val) {
                                budget = double.tryParse(val) ?? 0;
                              },
                            ),
                            const SizedBox(height: 60.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.grey[800],
                                  ),
                                  label: Text(
                                    'Back to home',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 4, 103, 136),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await DatabaseService(uid: widget.uid)
                                          .updateUserData(
                                              firstName, lastName, budget);
                                      showDialog(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Success'),
                                            content: const Text(
                                                'New user data saved successfully!'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
