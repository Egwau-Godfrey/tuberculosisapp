import 'package:flutter/material.dart';
import 'package:tuberculosisapp/pages/changeEmail.dart';
import 'package:tuberculosisapp/pages/changeName.dart';
import 'package:tuberculosisapp/pages/changePassword.dart';
import 'package:tuberculosisapp/pages/country.dart';
import 'package:tuberculosisapp/pages/help.dart';
import 'package:tuberculosisapp/pages/history.dart';
import 'package:tuberculosisapp/pages/homeScreen.dart';
import 'package:tuberculosisapp/pages/landingUI.dart';
import 'package:tuberculosisapp/pages/login.dart';
import 'package:tuberculosisapp/pages/privacy.dart';
import 'package:tuberculosisapp/pages/profiles.dart';
import 'package:tuberculosisapp/pages/settings.dart';
import 'package:tuberculosisapp/pages/signup.dart';
import 'package:tuberculosisapp/pages/termsAndConditions.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ValueNotifier<bool> _isDarkModeEnabled = ValueNotifier(false);

  // Light theme configuration
  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    // Add more theme properties here if needed
  );

  // Dark theme configuration
  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    // Add more theme properties here if needed
  );
  

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isDarkModeEnabled,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routes: {
            '/': (context) => Login(),
            'SignUp': (context) => const SignUp(),
            'landingUi': (context) => LandingUI(isDarkModeNotifier: _isDarkModeEnabled),
            'HomeScreen': (context) => const Homescreen(),
            "Profiles": (context) => const Profiles(),
            "Settings": (context) => Settings(isDarkModeNotifier: _isDarkModeEnabled),
            "History": (context) => const History(),
            "Country": (context) => const Country(),
            "ChangeName": (context) => const ChangeName(),
            "ChangeEmail": (context) => const ChangeEmail(),
            "ChangePassword": (context) => const ChangePassword(),
            "HelpAndFAQ": (context) => const HelpAndFAQ(),
            "Privacy": (context) => const Privacy(),
            "TermsAndCondition": (context) => const TermsAndConditions(),
          },
        );
      },
    );
  }
}