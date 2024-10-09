// EmailPasswordWidget.dart

import 'package:flutter/material.dart';

class EmailPasswordWidget extends StatefulWidget {
  final bool isSignUp;
  final Function(String email, String password) onSubmit;

  const EmailPasswordWidget(
      {Key? key, required this.isSignUp, required this.onSubmit})
      : super(key: key);

  @override
  _EmailPasswordWidgetState createState() => _EmailPasswordWidgetState();
}

class _EmailPasswordWidgetState extends State<EmailPasswordWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final email = emailController.text.trim();
            final password = passwordController.text.trim();
            widget.onSubmit(email, password);
          },
          child: Text(widget.isSignUp ? 'Sign Up' : 'Login'),
        ),
      ],
    );
  }
}
