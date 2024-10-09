import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:together/Pages/Game%20Screen/game_screen.dart';
import 'package:together/Pages/Login%20page/login_page.dart';
import 'package:together/Provider/auth_credential_provider.dart';
import 'package:together/Services/firebase_authentication.dart';
import 'package:together/Services/firestore_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _checkAuthenticationAndNavigate() async {
    if (Authenticate.isLoggedIn()) {
      context.read<AuthCredentialProvider>().setLogined(true);
      context
          .read<AuthCredentialProvider>()
          .setUserDetails(await FireStore().getUserDetails());
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } else {
      context.read<AuthCredentialProvider>().setLogined(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to schedule navigation after build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        _checkAuthenticationAndNavigate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Welcome to My Game',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
