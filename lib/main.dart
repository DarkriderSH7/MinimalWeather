import 'package:flutter/material.dart';
import 'pages/homepage.dart'; // Import the HomePage widget file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Set HomePage as the main screen of the app
    );
  }
}
