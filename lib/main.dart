import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:together/Pages/Game%20Screen/game_screen.dart';
import 'package:together/Pages/Splash%20Page/splash_page.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'Provider/auth_credential_provider.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthCredentialProvider())),
      ],
      child: MaterialApp(
        title: 'Together : The Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
