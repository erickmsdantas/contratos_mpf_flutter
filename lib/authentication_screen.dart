import 'package:contratos_mpf/contratos/screens/contratos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui_auth;


class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
              return firebase_ui_auth.SignInScreen();
          }

          return ContratosScreen();
        });
  }
}