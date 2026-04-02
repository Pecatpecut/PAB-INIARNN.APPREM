import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminProductPage extends StatelessWidget {
  const AdminProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      appBar: AppBar(
        title: const Text("Product Catalog"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6F5FEA),
        onPressed: () {
          Navigator.pushNamed(context, '/admin-add-product');
        },
        child: const Icon(Icons.add),
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [

          _productCard(
            context,
            name: "Netflix",
            desc: "Premium Streaming",
            variants: "4 Variants",
            price: "\$14.99",
          ),

          _productCard(
            context,
            name: "Spotify",
            desc: "Music Subscription",
            variants: "2 Variants",
            price: "\$9.99",
          ),
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context,
      {required String name,
      required String desc,
      required String variants,
      required String price}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242434),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),

          const SizedBox(height: 5),
          Text(desc, style: const TextStyle(color: Colors.white54)),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(variants),
              Text(price, style: const TextStyle(color: Colors.tealAccent)),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/admin-product-detail',
                    );
                  },
                  child: const Text("Manage"),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }
}