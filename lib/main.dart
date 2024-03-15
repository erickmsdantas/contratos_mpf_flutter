import 'package:contratos_mpf/authentication_screen.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'firebase_options.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await fba.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: 'project-452014915095'),
  ]);

  Intl.defaultLocale = 'pt_BR';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light, //MediaQuery.platformBrightnessOf(context),
      seedColor: const Color(0xFF629784),
      primary: const Color(0xFF629784),
      outline: const Color(0xFF629784),
    );

    return MaterialApp(
      title: 'Contratos',
      theme: ThemeData(useMaterial3: false, colorScheme: colorScheme),
      darkTheme: ThemeData(useMaterial3: false, colorScheme: colorScheme),
      themeMode: ThemeMode.light,
      home: const AuthenticationScreen(),
    );
  }
}
