import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/life_model.dart';
import 'screens/days_view.dart';
import 'screens/progress_view.dart';
import 'screens/setup_screen.dart';
import 'services/life_calculator.dart';

void main() {
  runApp(const TTLApp());
}

class TTLApp extends StatefulWidget {
  const TTLApp({super.key});

  @override
  State<TTLApp> createState() => _TTLAppState();
}

class _TTLAppState extends State<TTLApp> {
  late Future<LifeModel?> _lifeFuture;

  @override
  void initState() {
    super.initState();
    _lifeFuture = _loadLifeModel();
  }

  Future<LifeModel?> _loadLifeModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool setupComplete = prefs.getBool('setup_complete') ?? false;
    if (!setupComplete) {
      return null;
    }

    final String? dobString = prefs.getString('dob');
    final int? lifespanYears = prefs.getInt('lifespan_years');
    if (dobString == null || lifespanYears == null) {
      return null;
    }

    final DateTime dob = DateTime.parse(dobString);
    return LifeCalculator.calculate(
      dateOfBirth: dob,
      lifespanYears: lifespanYears,
    );
  }

  void _handleSetupComplete() {
    setState(() {
      _lifeFuture = _loadLifeModel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTL',
      theme: _buildTheme(brightness: Brightness.light),
      darkTheme: _buildTheme(brightness: Brightness.dark),
      home: FutureBuilder<LifeModel?>(
        future: _lifeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final LifeModel? lifeModel = snapshot.data;
          if (lifeModel == null) {
            return SetupScreen(onComplete: _handleSetupComplete);
          }

          return MainScreen(lifeModel: lifeModel);
        },
      ),
    );
  }

  ThemeData _buildTheme({required Brightness brightness}) {
    final bool isDark = brightness == Brightness.dark;
    const Color lightBackground = Color(0xFFFAFAF7);
    const Color lightPrimaryText = Color(0xFF1F2933);
    const Color lightSecondaryText = Color(0xFF6B7280);
    const Color lightDivider = Color(0xFFE5E7EB);
    const Color lightAccent = Color(0xFF6366F1);

    const Color darkBackground = Color(0xFF0F172A);
    const Color darkPrimaryText = Color(0xFFE5E7EB);
    const Color darkSecondaryText = Color(0xFF94A3B8);
    const Color darkDivider = Color(0xFF1E293B);
    const Color darkAccent = Color(0xFF818CF8);

    final Color background = isDark ? darkBackground : lightBackground;
    final Color primaryText = isDark ? darkPrimaryText : lightPrimaryText;
    final Color secondaryText = isDark ? darkSecondaryText : lightSecondaryText;
    final Color divider = isDark ? darkDivider : lightDivider;
    final Color accent = isDark ? darkAccent : lightAccent;
    final Color buttonTextColor = isDark ? darkPrimaryText : lightBackground;

    final TextTheme baseTextTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 96,
        fontWeight: FontWeight.w600,
        height: 1.0,
        letterSpacing: -1.5,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
        primary: accent,
        background: background,
        onBackground: primaryText,
        onSurface: primaryText,
        onSurfaceVariant: secondaryText,
      ),
      textTheme: baseTextTheme.apply(bodyColor: primaryText, displayColor: primaryText),
      dividerColor: divider,
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: buttonTextColor,
          textStyle: baseTextTheme.bodyLarge,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryText,
          textStyle: baseTextTheme.bodyLarge,
          side: BorderSide(color: divider),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: divider),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.lifeModel});

  final LifeModel lifeModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          DaysView(lifeModel: lifeModel),
          ProgressView(lifeModel: lifeModel),
        ],
      ),
    );
  }
}
