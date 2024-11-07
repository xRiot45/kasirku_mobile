import 'package:flutter/material.dart';
import 'package:kasirku_mobile/pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasirku Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
          );
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasirku Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Image(
            image: AssetImage('images/logo.png'),
            width: 200,
            height: 200,
          )
        ),
      )
    );
  }
}

