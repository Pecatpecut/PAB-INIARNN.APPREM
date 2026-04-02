import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/shared/spacing.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";

  final List<Map<String, String>> products = [
    {
      "title": "Netflix Premium",
      "price": "Rp 30.000",
      "image": "assets/images/profile.png",
    },
    {
      "title": "Spotify Premium",
      "price": "Rp 20.000",
      "image": "assets/images/profile.png",
    },
    {
      "title": "Canva Pro",
      "price": "Rp 15.000",
      "image": "assets/images/profile.png",
    },
    {
      "title": "Adobe Creative Cloud",
      "price": "Rp 50.000",
      "image": "assets/images/profile.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((p) =>
            p["title"]!.toLowerCase().contains(query.toLowerCase()))
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
              child: filtered.isEmpty
                  ? const Center(child: Text("Tidak ditemukan"))
                  : ListView(
                      children: filtered.map((p) {
                        return Column(
                          children: [
                            ProductCard(
                              image: p["image"]!,
                              title: p["title"]!,
                              price: p["price"]!,
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
            )
          ],
        ),
      ),
    );
  }
}