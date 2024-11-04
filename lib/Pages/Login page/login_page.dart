import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:together/Objects/user_detail.dart';
import 'package:together/Provider/auth_credential_provider.dart';
import 'package:together/Services/firebase_authentication.dart';
import 'package:together/Services/firestore_service.dart';
import 'package:together/Widgets/emailPasswordWidget.dart';
import 'package:together/Widgets/google_sign_in_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignUp = false; // false is signup
  bool usingEmailToLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Gives the game vibe with a dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game Title
            const Text(
              'TOGETHER: THE GAME', // Replace with your game title
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontFamily: 'PressStart2P', // Retro pixel font
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 100), // Add spacing between title and button

            // Row for Sign Up and Login buttons
            _buildEmailLoginSection(),
            const SizedBox(
                height: 50), // Add spacing between buttons and Google button

            const GoogleSignInButton(),
          ],
        ),
      ),
    );
  }

  _buildEmailLoginSection() {
    if (!usingEmailToLogin) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSignUp = true; // Set to sign up
                usingEmailToLogin = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Customize color
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Sign Up'),
          ),
          const SizedBox(width: 20), // Spacing between buttons

          // Login Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                isSignUp = false; // Set to login
                usingEmailToLogin = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Customize color
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 20),
            ),
            child: const Text('Login'),
          ),
        ],
      );
    } else {
      return EmailPasswordWidget(
        isSignUp: isSignUp,
        onSubmit: (email, password) async {
          bool success;
          if (isSignUp) {
            // success = await Authenticate.signup(email, password);
          } else {
            // success = await Authenticate.login(email, password);
          }
          success = true;
          if (success) {
            // Handle successful login or signup (e.g., navigate to the home page)
            _checkAuthentication();
            print('Success: User is logged in.');
          } else {
            // Handle failure (e.g., show a snackbar with an error message)
            print('Error: Failed to log in or sign up.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to ${isSignUp ? 'sign up' : 'log in'}. Please try again.')),
            );
          }
        },
      );
    }
  }

  Future<void> _checkAuthentication() async {
    if (Authenticate.isLoggedIn()) {
      context.read<AuthCredentialProvider>().setLogined(true);
      UserDetail userDetails = await FireStore().getUserDetails();
      context.read<AuthCredentialProvider>().setUserDetails(userDetails);
      String userName = userDetails.name ??
          'User'; // Default to 'User' if displayName is null

      print("username is : $userName");

      // Show welcome message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Welcome, $userName!'), // Include user name in the message
        ),
      );
    } else {
      context.read<AuthCredentialProvider>().setLogined(false);

      // Show message if user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
    }
  }
}
