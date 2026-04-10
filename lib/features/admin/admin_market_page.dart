import 'package:flutter/material.dart';
import '../../services/product_service.dart';

class AdminMarketPage extends StatefulWidget {
  const AdminMarketPage({super.key});

  @override
  State<AdminMarketPage> createState() => _AdminMarketPageState();
}

class _AdminMarketPageState extends State<AdminMarketPage> {
  final productService = ProductService();

  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final data = await productService.getProducts();

    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin-add-product');
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      p['image'] ?? '',
                      width: 40,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                    title: Text(p['name'] ?? '-'),
                    subtitle: Text(p['category'] ?? '-'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/admin-product-detail',
                        arguments: p,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}