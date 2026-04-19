import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/navbar/bottom_navbar.dart';
import '../../widgets/cards/premium_product_tile.dart';

// service
import '../../services/product_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

String searchQuery = "";

class _ProductPageState extends State<ProductPage> {
  String selectedCategory = "All";

  final productService = ProductService();

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    try {
      final data = await productService.getProducts(
        category: selectedCategory == "All" ? null : selectedCategory,
      );
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR FETCH PRODUCT: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

    void onCategoryChanged(String category) {
      setState(() {
        selectedCategory = category;
        isLoading = true;
      });
      fetchProducts();
    }

  String _getPrice(Map product) {
    final variants = product['product_variants'] ?? [];

    if (variants.isEmpty) return "N/A";

    final price = variants[0]['price'];
    return "Rp $price";
  }

  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredProducts = products.where((product) {
  final name = (product['name'] ?? "").toLowerCase();
  final category = (product['category'] ?? "").toLowerCase();

      return name.contains(searchQuery) ||
            category.contains(searchQuery);
    }).toList();

        return Scaffold(
  backgroundColor: theme.colorScheme.surface,
  bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),

  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.primary.withValues(alpha: 0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),

    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 NAVBAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.blur_on, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "INIARNN.APPREM",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.surface.withValues(alpha: 0.4),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search subscriptions...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 TITLE
            Text(
              "Premium Modules",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Choose your premium apps",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 CATEGORY
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _chip("All"),
                  _chip("Streaming"),
                  _chip("Music"),
                  _chip("Study"),
                  _chip("Editing"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 CONTENT
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                      ? const Center(child: Text("Tidak ada produk"))
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return PremiumProductTile(
                              title: product['name'] ?? "-",
                              subtitle: _getSubtitle(product),
                              imageUrl: product['image'],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: product,
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    ),
  ),
);
    
  }

    String _getSubtitle(Map product) {
      final variants = product['product_variants'] ?? [];

      if (variants.isEmpty) return "No package";

      final v = variants[0];

      return "${v['duration_days']} Days • ${v['type']}";
    }
  /// 🔥 CATEGORY CHIP
  Widget _chip(String title) {
    final isActive = selectedCategory == title;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onCategoryChanged(title),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surface.withValues(alpha: 0.3),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}