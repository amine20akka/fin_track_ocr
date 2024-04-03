// ignore_for_file: use_build_context_synchronously

import 'package:fin_track_ocr/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfilePopupMenu extends StatelessWidget {
  final AuthService _authService = AuthService();
  final CircleAvatar profileImage;

  ProfilePopupMenu({super.key, required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Widget>(
      popUpAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 400)),
      icon: profileImage,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Widget>>[
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('View my profile'),
            onTap: () async {
              Navigator.pop(context); // Fermer le menu contextuel
            },
          ),
        ),
        PopupMenuItem<Widget>(
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Déconnectez l'utilisateur lorsque l'option Logout est sélectionnée
              await _authService.signOut();
              Navigator.pop(context); // Fermer le menu contextuel
            },
          ),
        ),
      ],
    );
  }
}
