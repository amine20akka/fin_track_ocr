// ignore_for_file: use_build_context_synchronously

import 'package:fin_track_ocr/pages/Profile/view_profile.dart';
import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePopupMenu extends StatefulWidget {
  final String uid;
  final CircleAvatar profileImage;

  const ProfilePopupMenu({super.key, required this.profileImage, required this.uid});

  @override
  State<ProfilePopupMenu> createState() => _ProfilePopupMenuState();
}

class _ProfilePopupMenuState extends State<ProfilePopupMenu> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Widget>(
      popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 400)),
      icon: widget.profileImage,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Widget>>[
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('View my profile'),
            onTap: () {
              Navigator.pop(context);
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
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.pop(context);
              await _authService.signOut();
            },
          ),
        ),
      ],
    );
  }
}
