import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/navbar/bottom_navbar.dart';
import '../../widgets/cards/product_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> products = [
    {
      "title": "Netflix Premium",
      "price": "\$4.99",
      "category": "Streaming",
    },
    {
      "title": "Spotify Premium",
      "price": "\$1.99",
      "category": "Music",
    },
    {
      "title": "YouTube Premium",
      "price": "\$2.99",
      "category": "Streaming",
    },
    {
      "title": "Canva Pro",
      "price": "\$3.99",
      "category": "Editing",
    },
    {
      "title": "Adobe CC",
      "price": "\$12.99",
      "category": "Editing",
    },
    {
      "title": "Coursera Plus",
      "price": "\$5.99",
      "category": "Study",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredProducts = selectedCategory == "All"
        ? products
        : products
            .where((p) => p["category"] == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 TITLE
              const Text(
                "Premium Modules",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Choose your premium apps",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// 🔥 CATEGORY CHIPS
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

              /// 🔥 LIST PRODUCT
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ProductCard(
                        image: "assets/images/profile.png",
                        title: product["title"],
                        price: product["price"],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: product,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 CATEGORY CHIP
  Widget _chip(String title) {
    final isActive = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? const Color(0xFF6F5FEA)
              : Colors.grey.withOpacity(0.2),
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