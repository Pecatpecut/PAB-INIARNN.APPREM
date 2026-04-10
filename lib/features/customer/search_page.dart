import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/shared/spacing.dart';
import '../../services/product_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final productService = ProductService();

  String query = "";
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    try {
      final data = await productService.getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String _getPrice(Map product) {
    final variants = product['product_variants'] ?? [];
    if (variants.isEmpty) return "N/A";
    return "Rp ${variants[0]['price']}";
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((p) =>
            p["name"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [

            /// 🔍 SEARCH INPUT
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search apps...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            Space.h20,

            /// 🔥 RESULT
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text("Tidak ditemukan"))
                      : ListView(
                          children: filtered.map((p) {
                            return Column(
                              children: [
                                ProductCard(
                                  image: "assets/images/profile.png", // tetap pakai profile
                                  title: p["name"] ?? "-",
                                  price: _getPrice(p),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: p,
                                    );
                                  },
                                ),
                                Space.h15,
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}