import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryLight = Color(0xFF6750A4);
  static const Color primaryContainerLight = Color(0xFFEADDFF);
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color secondaryContainerLight = Color(0xFFE8DEF8);
  static const Color tertiaryLight = Color(0xFF7D5260);
  static const Color tertiaryContainerLight = Color(0xFFFFD8E4);
  static const Color errorLight = Color(0xFFB3261E);
  static const Color backgroundLight = Color(0xFFF6F5F5);
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1C1B1F);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);

  // Couleurs du thème sombre
  static const Color primaryDark = Color(0xFFD0BCFF);
  static const Color primaryContainerDark = Color(0xFF4F378B);
  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color secondaryContainerDark = Color(0xFF4A4458);
  static const Color tertiaryDark = Color(0xFFEFB8C8);
  static const Color tertiaryContainerDark = Color(0xFF633B48);
  static const Color errorDark = Color(0xFFF2B8B5);
  static const Color backgroundDark = Color(0xFF1C1B1F);
  static const Color surfaceDark = Color(0xFF2D2C31);
  static const Color onPrimaryDark = Color(0xFF381E72);
  static const Color onSecondaryDark = Color(0xFF332D41);
  static const Color onTertiaryDark = Color(0xFF492532);
  static const Color onErrorDark = Color(0xFF601410);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);

  // Thème clair
  static ThemeData lightTheme() {
    final base = ThemeData.light();
    final textTheme = _getTextTheme(base.textTheme, onSurfaceLight);

    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: onPrimaryLight,
        primaryContainer: primaryContainerLight,
        onPrimaryContainer: primaryLight,
        secondary: secondaryLight,
        onSecondary: onSecondaryLight,
        secondaryContainer: secondaryContainerLight,
        onSecondaryContainer: secondaryLight,
        tertiary: tertiaryLight,
        onTertiary: onTertiaryLight,
        tertiaryContainer: tertiaryContainerLight,
        onTertiaryContainer: tertiaryLight,
        error: errorLight,
        onError: onErrorLight,
        errorContainer: Color(0xFFF9DEDC),
        onErrorContainer: Color(0xFF410E0B),
        background: backgroundLight,
        onBackground: onBackgroundLight,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        surfaceVariant: Color(0xFFE7E0EC),
        onSurfaceVariant: Color(0xFF49454F),
        outline: Color(0xFF79747E),
        shadow: Colors.black.withOpacity(0.15),
        inverseSurface: Color(0xFF313033),
        onInverseSurface: Color(0xFFF4EFF4),
        inversePrimary: Color(0xFFD0BCFF),
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: onSurfaceLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: onPrimaryLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          side: BorderSide(color: primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFCAC4D0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFCAC4D0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorLight, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: TextStyle(color: onSurfaceLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        indicatorColor: primaryContainerLight,
        labelTextStyle: MaterialStateProperty.all(
          textTheme.labelMedium,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: primaryLight,
        unselectedItemColor: onSurfaceLight.withOpacity(0.6),
      ),
      useMaterial3: true,
    );
  }

  // Thème sombre
  static ThemeData darkTheme() {
    final base = ThemeData.dark();
    final textTheme = _getTextTheme(base.textTheme, onSurfaceDark);

    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: onPrimaryDark,
        primaryContainer: primaryContainerDark,
        onPrimaryContainer: Color(0xFFEADDFF),
        secondary: secondaryDark,
        onSecondary: onSecondaryDark,
        secondaryContainer: secondaryContainerDark,
        onSecondaryContainer: Color(0xFFE8DEF8),
        tertiary: tertiaryDark,
        onTertiary: onTertiaryDark,
        tertiaryContainer: tertiaryContainerDark,
        onTertiaryContainer: Color(0xFFFFD8E4),
        error: errorDark,
        onError: onErrorDark,
        errorContainer: Color(0xFF8C1D18),
        onErrorContainer: Color(0xFFF9DEDC),
        background: backgroundDark,
        onBackground: onBackgroundDark,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        surfaceVariant: Color(0xFF49454F),
        onSurfaceVariant: Color(0xFFCAC4D0),
        outline: Color(0xFF938F99),
        shadow: Colors.black,
        inverseSurface: Color(0xFFE6E1E5),
        onInverseSurface: Color(0xFF313033),
        inversePrimary: primaryLight,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: onSurfaceDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: onPrimaryDark,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryDark,
          side: BorderSide(color: primaryDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF49454F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF49454F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorDark, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceDark,
        contentTextStyle: TextStyle(color: onSurfaceDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: primaryContainerDark,
        labelTextStyle: MaterialStateProperty.all(
          textTheme.labelMedium,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryDark,
        unselectedItemColor: onSurfaceDark.withOpacity(0.6),
      ),
      useMaterial3: true,
    );
  }

  // Méthode pour obtenir les styles de texte avec Google Fonts
  static TextTheme _getTextTheme(TextTheme base, Color textColor) {
    return GoogleFonts.poppinsTextTheme(base).copyWith(
      displayLarge: GoogleFonts.poppins(
        textStyle: base.displayLarge!.copyWith(color: textColor),
      ),
      displayMedium: GoogleFonts.poppins(
        textStyle: base.displayMedium!.copyWith(color: textColor),
      ),
      displaySmall: GoogleFonts.poppins(
        textStyle: base.displaySmall!.copyWith(color: textColor),
      ),
      headlineLarge: GoogleFonts.poppins(
        textStyle: base.headlineLarge!.copyWith(color: textColor),
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: base.headlineMedium!.copyWith(color: textColor),
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: base.headlineSmall!.copyWith(color: textColor),
      ),
      titleLarge: GoogleFonts.poppins(
        textStyle: base.titleLarge!.copyWith(color: textColor),
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: base.titleMedium!.copyWith(color: textColor),
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: base.titleSmall!.copyWith(color: textColor),
      ),
      bodyLarge: GoogleFonts.poppins(
        textStyle: base.bodyLarge!.copyWith(color: textColor),
      ),
      bodyMedium: GoogleFonts.poppins(
        textStyle: base.bodyMedium!.copyWith(color: textColor),
      ),
      bodySmall: GoogleFonts.poppins(
        textStyle: base.bodySmall!.copyWith(color: textColor),
      ),
      labelLarge: GoogleFonts.poppins(
        textStyle: base.labelLarge!.copyWith(color: textColor),
      ),
      labelMedium: GoogleFonts.poppins(
        textStyle: base.labelMedium!.copyWith(color: textColor),
      ),
      labelSmall: GoogleFonts.poppins(
        textStyle: base.labelSmall!.copyWith(color: textColor),
      ),
    );
  }
}

// Classe pour gérer le thème de l'application
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setLightMode() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}

