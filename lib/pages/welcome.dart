import 'package:flutter/material.dart';
import 'package:kasirku_mobile/pages/homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasirku Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Screen()
    );
  }
}

class Screen extends StatefulWidget{
  const Screen({super.key});
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(image: AssetImage('images/welcome.png'),
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start',
                    style: GoogleFonts.mulish(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }
}