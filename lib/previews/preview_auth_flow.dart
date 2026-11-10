
import 'package:flutter/material.dart';

import '../features/auth/landing/landing_page.dart';
import '../features/auth/register/register_page.dart';
import '../features/auth/login/login_page.dart';

void main() {
  runApp(const PreviewAuthFlow());
}

class PreviewAuthFlow extends StatelessWidget {
  const PreviewAuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preview Auth IniClUniv',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(
              onRegister: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
              onLogin: () {
                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },
            ),

        '/register': (context) => RegisterPage(
              onLogin: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
            ),

        '/login': (context) => LoginPage(
              onRegister: () {
                Navigator.pushNamed(
                  context,
                  '/register',
                );
              },
            ),
      },
    );
  }
}
