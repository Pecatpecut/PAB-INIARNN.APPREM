import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminProductDetailPage extends StatelessWidget {
  const AdminProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      appBar: AppBar(
        title: const Text("Product Detail"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [

          /// PRODUCT INFO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF242434),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Netflix",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Streaming Service"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin-add-product');
            },
            child: const Text("Edit Product"),
          ),

          const SizedBox(height: 20),

          const Text("Variants",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 10),

          _variant("1 Month", "\$9.99"),
          _variant("12 Months", "\$99.99"),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/admin-add-variant');
            },
            child: const Text("Add Variant"),
          ),
        ],
      ),
    );
  }

  Widget _variant(String name, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF181826),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$name - $price"),
          Row(
            children: const [
              Icon(Icons.edit),
              SizedBox(width: 10),
              Icon(Icons.delete, color: Colors.red),
            ],
          )
        ],
      ),
    );
  }
}