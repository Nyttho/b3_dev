import 'package:flutter/material.dart';
import 'package:b3_dev/screens/splash_screen.dart';
import 'package:b3_dev/services/mock_auth_service.dart';
import 'package:b3_dev/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// Global instance of our mock auth service that can be accessed throughout the app
final mockAuthService = MockAuthService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Ajout d'une configuration pour permettre les images HTTP
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Universe Chat',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Classe pour permettre les connexions HTTP non sécurisées
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).colorScheme.secondary,
      ),
    );
  }
}

