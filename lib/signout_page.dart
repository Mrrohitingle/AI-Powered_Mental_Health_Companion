import 'package:flutter/material.dart';

class SignOutPage extends StatelessWidget {
  const SignOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Out'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Login or Welcome Page (replace with your login screen)
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
