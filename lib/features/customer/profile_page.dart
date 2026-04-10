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
        print("ERROR FETCH USER: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

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

        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [

            /// 🔥 PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: theme.brightness == Brightness.dark
                      ? [
                          const Color(0xFF1B1B2F),
                          const Color(0xFF1F1F3A),
                        ]
                      : [
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          theme.colorScheme.surface,
                        ],
                ),
              ),
              child: Column(
                children: [

                  /// 🔥 FOTO (AUTO INITIAL)
                  CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : "U",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔥 NAME + EMAIL
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 DARK MODE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
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

            /// 🔥 MENU
            _menu(context, Icons.edit, "Edit Profile", '/edit-profile'),
            _menu(context, Icons.shopping_bag, "My Orders", '/orders'),
            _menu(context, Icons.verified_user, "Garansi", '/garansi'),
            _menu(context, Icons.rule, "Rules & Terms", '/rules'),
            _menu(context, Icons.public, "Social Media", '/social'),

            Space.h30,

            /// 🔥 LOGOUT
            PrimaryButton(
              text: "Logout",
              onTap: () async {
                await supabase.auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),

            Space.h20,
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
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.onSurface),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}