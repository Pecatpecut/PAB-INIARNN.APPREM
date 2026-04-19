import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'core/theme_provider.dart';
import 'core/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  /// 🔥 LOAD ENV
  await dotenv.load(fileName: ".env");

  /// 🔥 INIT SUPABASE
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  /// 🔥 CEK USER LOGIN
  final user = Supabase.instance.client.auth.currentUser;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(
        initialRoute: user == null ? '/login' : '/home',
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// 🔥 THEME SYSTEM
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.currentTheme,

      /// 🔥 ROUTING
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}