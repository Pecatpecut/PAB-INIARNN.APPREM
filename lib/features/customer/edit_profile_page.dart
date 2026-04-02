import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 FOTO PROFIL
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/profile.png'),
              ),
            ),

            Space.h20,

            _input("Name"),
            Space.h10,

            _input("Email"),
            Space.h10,

            _input("Phone Number"),
            Space.h10,

            _input("Password", isPassword: true),

            Space.h30,

            /// 🔥 BUTTON SAVE
            PrimaryButton(
              text: "Save Changes",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}