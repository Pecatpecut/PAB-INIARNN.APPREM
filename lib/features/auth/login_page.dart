import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/auth_service.dart';
import '../../core/theme_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // ✅ Animasi fade + slide sama seperti RegisterPage
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Tutup keyboard
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackBar("Email & password wajib diisi", isError: true);
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
      if (!mounted) return;

      String message = "Terjadi kesalahan, coba lagi";
      if (e.toString().contains("Invalid login credentials")) {
        message = "Email atau password salah";
      } else if (e.toString().contains("missing email")) {
        message = "Email wajib diisi";
      }

      _showSnackBar(message, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ SnackBar konsisten dengan RegisterPage
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0A0A14),
                    const Color(0xFF111124),
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                  ]
                : [
                    Colors.white,
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // ─────────────────────────────
                      // NAVBAR — konsisten dengan Register
                      // ─────────────────────────────
                      Row(
                        children: [
                          Icon(
                            Icons.blur_on,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "INIARNN.APPREM",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          // ✅ Toggle dark/light tetap ada di Login
                          GestureDetector(
                            onTap: () {
                              Provider.of<ThemeProvider>(
                                context,
                                listen: false,
                              ).toggleTheme();
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // ─────────────────────────────
                      // LOGO — sama persis dengan Register
                      // ─────────────────────────────
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Aura luar
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  theme.colorScheme.primary
                                      .withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Foto profil
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.4),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ─────────────────────────────
                      // HEADING
                      // ─────────────────────────────
                      Text(
                        "iniarnn.apprem",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "˗ˏˋ apps premium by arnn 🐰 ࿐ྂ",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      // ─────────────────────────────
                      // FORM CARD — identik dengan Register
                      // ─────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    Colors.white.withValues(alpha: 0.06),
                                    Colors.white.withValues(alpha: 0.02),
                                  ]
                                : [
                                    Colors.white,
                                    Colors.grey.shade50,
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.04),
                          ),
                          boxShadow: isDark
                              ? [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.07),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Header card
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Masuk ke akun kamu untuk melanjutkan.",
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),

                            const SizedBox(height: 24),

                            _label("EMAIL ADDRESS"),
                            _input(
                              "your@email.com",
                              controller: _emailController,
                              icon: Icons.mail_outline,
                              inputType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            _label("PASSWORD"),
                            _input(
                              "Masukkan password",
                              controller: _passwordController,
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),

                            const SizedBox(height: 28),

                            // Button / Loading — AnimatedSwitcher sama dengan Register
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _isLoading
                                  ? Center(
                                      key: const ValueKey('loading'),
                                      child: SizedBox(
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              "Sedang masuk...",
                                              style: TextStyle(
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.6),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : _button(theme, isDark),
                            ),

                            const SizedBox(height: 16),

                            // Register link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Belum punya akun?",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '/register',
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Daftar",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // WIDGET HELPERS — identik dengan Register
  // ─────────────────────────────────────

  Widget _label(String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.4,
          color: theme.colorScheme.primary.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  Widget _input(
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: inputType,
      style: TextStyle(
        fontSize: 14,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: isDark
            ? Colors.black.withValues(alpha: 0.35)
            : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: isPassword
            ? GestureDetector(
                onTapDown: (_) =>
                    setState(() => _isPasswordVisible = true),
                onTapUp: (_) =>
                    setState(() => _isPasswordVisible = false),
                onTapCancel: () =>
                    setState(() => _isPasswordVisible = false),
                child: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              )
            : null,
      ),
    );
  }

  Widget _button(ThemeData theme, bool isDark) {
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
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Masuk Sekarang",
            style: TextStyle(
              color: isDark ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}