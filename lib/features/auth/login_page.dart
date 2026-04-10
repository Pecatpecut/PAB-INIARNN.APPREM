import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final _authService = AuthService();

    Future<void> _login() async {
      /// 🔥 VALIDASI DULU (WAJIB)
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email & password wajib diisi")),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final role = await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }

      } catch (e) {
        /// 🔥 ERROR HANDLE YANG LEBIH RAPI
        String message = "Terjadi kesalahan";

        if (e.toString().contains("Invalid login credentials")) {
          message = "Email atau password salah";
        } else if (e.toString().contains("missing email")) {
          message = "Email wajib diisi";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

      } finally {
        setState(() => _isLoading = false);
      }
    }

  @override
  Widget build(BuildContext context) {
            final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withValues(alpha:0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: ListView(
              children: [

                const SizedBox(height: 40),

                /// 🔥 LOGO + BRAND
                Column(
                  children: [

                    /// 🔥 LOGO
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha:0.05),
                      ),
                      child: Image.asset(
                        'assets/images/profile.png',
                        height: 70,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "iniarnn.apprem",
                      style: TextStyle(
                        color: Color(0xFFACA3FF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "˗ˏˋ apps premium by arnn 🐰 ࿐ྂ",
                      style: TextStyle (color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🔥 TITLE
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔥 CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.05),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radius),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [

                      _input("Email", controller: _emailController),
                      const SizedBox(height: 16),
                      _input("Password", controller: _passwordController, isPassword: true),

                      const SizedBox(height: 20),

                      _isLoading
                          ? const CircularProgressIndicator()
                      : _button(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Color(0xFFACA3FF)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _input(
  String hint, {
    
  bool isPassword = false,
  required TextEditingController controller,
}) {
  final theme = Theme.of(context);

  return TextField(
    controller: controller,
    obscureText: isPassword ? !_isPasswordVisible : false,
    style: TextStyle(color: theme.colorScheme.onSurface),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radius),
        borderSide: BorderSide.none,
      ),

      suffixIcon: isPassword
          ? GestureDetector(
              onTapDown: (_) {
                setState(() => _isPasswordVisible = true);
              },
              onTapUp: (_) {
                setState(() => _isPasswordVisible = false);
              },
              onTapCancel: () {
                setState(() => _isPasswordVisible = false);
              },
              child: Icon(
                _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: theme.colorScheme.onSurface,
              ),
            )
          : null,
    ),
  );
}
  Widget _button() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _login,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ]
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6F5FEA).withValues(alpha:0.6),
              blurRadius: 20,
            )
          ],
        ),
        child: const Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}