import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme_provider.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 PROFILE INFO
            Column(
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      AssetImage('assets/images/profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  "iniarnn.apprem",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "user@email.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            Space.h30,

            /// 🔥 DARK MODE TOGGLE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Mode"),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 EDIT PROFILE BUTTON
            _menu(context, Icons.edit, "Edit Profile", '/edit-profile'),

            _menu(context, Icons.shopping_bag, "My Orders", '/orders'),
            _menu(context, Icons.verified_user, "Garansi", '/garansi'),
            _menu(context, Icons.rule, "Rules & Terms", '/rules'),
            _menu(context, Icons.public, "Social Media", '/social'),

            Space.h30,

            /// 🔥 LOGOUT
            PrimaryButton(
              text: "Logout",
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
      BuildContext context, IconData icon, String title, String route) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}