import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kasirku_mobile/configs/env.dart';
import 'dart:convert';
import 'package:kasirku_mobile/utils/currency_formatter.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  int _currentPage = 1;
  int _totalPages = 1;
  final int _limit = 10;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  @override
  void initState() {
    super.initState();
    Config.load().then((_) {
        _fetchProducts();
      });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (_searchController.text.isEmpty) {
          _fetchProducts();
        } else {
          _fetchProducts(searchTerm: _searchController.text);
        }
      });
  }

  Future<void> _fetchProducts({String searchTerm = '', int page = 1}) async {
    String apiUrl = '${Config.apiUrl}/api/products?limit=$_limit&page=$page';
    if (searchTerm.isNotEmpty) {
      apiUrl += '&product_name=$searchTerm';
    }
    setState(() {
        _isLoading = true;
      });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
            _products = data['data'] ?? [];
            _currentPage = data['currentPage'] ?? 1;
            _totalPages = data['totalPages'] ?? 1;
            _hasNextPage = data['hasNextPage'] != null && data['hasNextPage'];
            _hasPreviousPage = data['hasPreviousPage'] != null && data['hasPreviousPage'];

            _isLoading = false;
          });
      } else {
        setState(() {
            _isLoading = false;
          });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      setState(() {
          _isLoading = false;
        });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching products: $e'),
        ),
      );
    }
  }

  void _goToNextPage() {
    if (_hasNextPage) {
      setState(() {
          _currentPage++;
          _isLoading = true;
        });
      _fetchProducts(page: _currentPage);
    }
  }

  void _goToPreviousPage() {
    if (_hasPreviousPage) {
      setState(() {
          _currentPage--;
          _isLoading = true;
        });
      _fetchProducts(page: _currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: Color.fromARGB(255, 199, 199, 199),
                    backgroundImage: AssetImage('images/blank.png'),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!!',
                        style: GoogleFonts.mulish(
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -6),
                        child: Text(
                          'Customers',
                          style: GoogleFonts.mulish(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _searchController,
                style: GoogleFonts.mulish(
                  fontSize: 14.0,
                  color: const Color.fromARGB(255, 102, 102, 102),
                ),
                decoration: InputDecoration(
                  hintText: 'Search Products',
                  hintStyle: GoogleFonts.mulish(
                    fontSize: 14.0,
                    color: const Color.fromARGB(255, 154, 154, 154),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    final productImageUrl = '${Config.apiUrl}/${product['product_photo'] ?? ''}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: product['product_photo'] != null
                            ? Image.network(
                              productImageUrl,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                            )
                            : const Icon(Icons.image_not_supported, size: 100),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['product_name'] ?? 'No Name',
                                style: GoogleFonts.mulish(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                product['product_category']?['product_category_name'] ?? 'No Category',
                                style: GoogleFonts.mulish(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatToRupiah(product['product_price'] ?? 0),
                                style: GoogleFonts.mulish(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  AnimatedOpacity(
                    opacity: _hasPreviousPage ? 1.0 : 0.5, // Change opacity based on _hasPreviousPage
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _hasPreviousPage ? _goToPreviousPage : null, // Disable button if _hasPreviousPage is false
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Page Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Page $_currentPage / $_totalPages',
                      style: GoogleFonts.mulish(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Next Button
                  AnimatedOpacity(
                    opacity: _hasNextPage ? 1.0 : 0.5, // Change opacity based on _hasNextPage
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: _hasNextPage ? _goToNextPage : null, // Disable button if _hasNextPage is false
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
    );
  }
}

