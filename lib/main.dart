import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'auth/sign_up.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is initialized



  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyCPJY9nOLv2aWzoP4oDbCc0-KGbuNbGUG8",
    appId: "1:79767323076:android:df5b28bea71203c48ea491",
    messagingSenderId: "79767323076",
    projectId: "authenti-f04f8",
  );
  try {
    await Firebase.initializeApp(options: firebaseOptions);
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  runApp( MentalHealthApp());
}
class MentalHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUp(),
    );
  }
}
