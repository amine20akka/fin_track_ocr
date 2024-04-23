import 'dart:io';

import 'package:fin_track_ocr/models/user.dart';
import 'package:fin_track_ocr/authentication/authenticate.dart';
import 'package:fin_track_ocr/pages/Profile/view_profile.dart';
import 'package:fin_track_ocr/pages/home/transactions_history.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:fin_track_ocr/services/database_service.dart';
import 'package:fin_track_ocr/shared/linear_gradient.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final String uid;
  const MyDrawer({super.key, required this.uid});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: _authService.getUserEmail(),
            builder: (context, emailSnapshot) {
              if (emailSnapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (emailSnapshot.hasData) {
                return Drawer(
                  backgroundColor: const Color.fromARGB(249, 238, 232, 232),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100.0),
                    children: <Widget>[
                      DrawerHeader(
                        padding: EdgeInsets.zero,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: UserAccountsDrawerHeader(
                          margin: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            gradient: myLinearGradient,
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 16,
                            backgroundImage:
                                snapshot.data!.profileImageUrl != null
                                    ? FileImage(
                                        File(snapshot.data!.profileImageUrl!))
                                    : const AssetImage(
                                        'assets/default_profile_image.png',
                                      ) as ImageProvider,
                          ),
                          accountName: Text(
                            '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          accountEmail: Text(emailSnapshot.data!),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('My profile', style: TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewProfile(
                                uid: widget.uid,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text(
                          'Transactions history',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return TransactionsHistory(uid: widget.uid,);
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          await _authService.signOut();
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const Authentication();
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 420.0,),
                      const Divider(
                        thickness: 1.0,
                        indent: 2.0,
                        endIndent: 2.0,
                      ),
                      ListTile(
                        leading: const Icon(Icons.arrow_back),
                        title: const Text('Close menu', style: TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}
