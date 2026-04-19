import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../core/theme_provider.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/navbar/bottom_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  String name = "User";
  String email = "email@example.com";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        final data = await supabase
            .from('users')
            .select('name, email')
            .eq('id', user.id)
            .single();

        setState(() {
          name = data['name'] ?? "User";
          email = data['email'] ?? user.email ?? "-";
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔥 NAVBAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/profile.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "INIARNN.APPREM",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                    /// ICON KANAN
                    Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// 🔥 PROFILE (LOGO DI TENGAH)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.surface.withValues(alpha: 0.4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      /// 🔥 LOGO (GANTI AVATAR)
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  email,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 DARK MODE
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surface.withValues(alpha: 0.4),
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

                const SizedBox(height: 20),

                /// 🔥 MENU
                Expanded(
                  child: ListView(
                    children: [
                      _menu(context, Icons.edit, "Edit Profile", '/edit-profile'),
                      _menu(context, Icons.shopping_bag, "My Orders", '/orders'),
                      _menu(context, Icons.verified_user, "Garansi", '/garansi'),
                      _menu(context, Icons.rule, "Rules & Terms", '/rules'),
                      _menu(context, Icons.public, "Social Media", '/social'),

                      const SizedBox(height: 30),

                      PrimaryButton(
                        text: "Logout",
                        onTap: () async {
                          await supabase.auth.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menu(
      BuildContext context, IconData icon, String title, String route) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface.withValues(alpha: 0.4),
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