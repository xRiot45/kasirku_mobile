import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Product', 
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.bold,
            fontSize: 18.0
          )
        )
      ),
      body: Center(
        child: Text(productId)
      )
    );
  }
}
