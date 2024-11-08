import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kasirku_mobile/configs/env.dart';
import 'package:kasirku_mobile/utils/currency_formatter.dart';

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
      body: Screen(productId: productId)
    );
  }
}


class Screen extends StatefulWidget {
  final String productId;

  const Screen({super.key, required this.productId});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool _isLoading = true;

  String? id;
  String? productName;
  String? productCode;
  int? productStock;
  int? productPrice;
  String? productDescription;
  List<String> productVariants = [];
  String? productPhoto;
  String? productStatus;
  String? productCategoryName;

  @override
  void initState(){
    super.initState();
    Config.load().then((_){
        _fetchProductById();
      }
    );
  }

  Future<void> _fetchProductById() async {
    String apiUrl = '${Config.apiUrl}/api/products/show/${widget.productId}';

    setState(() {
        _isLoading = true;
      }
    );

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200){
        final Map<String, dynamic> data = json.decode(response.body);
        final productData = data['data'];

        setState(() {
            id = productData['id'];
            productName = productData['product_name'];
            productCode = productData['product_code'];
            productStock = productData['product_stock'];
            productPrice = productData['product_price'];
            productDescription = productData['product_description'];
            productPhoto = productData['product_photo'];
            productStatus = productData['product_status'];
            productCategoryName = productData['product_category']['product_category_name'];

            productVariants = (productData['product_variants'] as List).map((variant) => variant['variant'] as String).toList();

            _isLoading = false;
          }
        );
      }
    }
    catch (e) {
      setState(() {
          _isLoading = false;
        }
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching products: $e')
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productImageUrl = '${Config.apiUrl}/$productPhoto';
    return Scaffold(
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: productPhoto != null
                  ? Image.network(
                    productImageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported)
                  )
                  : const Icon(Icons.image_not_supported, size: 100)
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName!,
                        style: GoogleFonts.mulish(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black
                        )
                      ),
                      Text(
                        productCategoryName!,
                        style: GoogleFonts.mulish(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                        )
                      )
                    ]
                  ),
                  Text(
                    formatToRupiah(productPrice!),
                    style: GoogleFonts.mulish(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    )
                  )
                ]
              ),

              const SizedBox(height: 20.0),
              Text(
                'Variant',
                style: GoogleFonts.mulish(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                )
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productVariants.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8.0), // Jarak antar varian
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(
                        productVariants[index],
                        style: GoogleFonts.mulish(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        )
                      )
                    );
                  }
                )
              ),
              const SizedBox(height: 20.0),
              Text(
                'Description',
                style: GoogleFonts.mulish(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                )
              ),
              const SizedBox(height: 10.0),
              Text(
                productDescription!,
                textAlign: TextAlign.justify,
                style: GoogleFonts.mulish(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  height: 2
                )
              )
            ]
          )
        )
    );
  }
}
