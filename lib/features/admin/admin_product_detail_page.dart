import 'package:flutter/material.dart';
import '../../services/product_service.dart';

class AdminProductDetailPage extends StatefulWidget {
  const AdminProductDetailPage({super.key});

  @override
  State<AdminProductDetailPage> createState() =>
      _AdminProductDetailPageState();
}

class _AdminProductDetailPageState
    extends State<AdminProductDetailPage> {
  final service = ProductService();

  late Map product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    product =
        ModalRoute.of(context)!.settings.arguments as Map;
  }

  Future<void> deleteProduct() async {
    await service.deleteProduct(product['id']);
    Navigator.pop(context);
  }

  Future<void> deleteVariant(String id) async {
    await service.deleteVariant(id);

    setState(() {
      product['product_variants']
          .removeWhere((v) => v['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final variants = product['product_variants'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteProduct,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/admin-add-variant',
            arguments: product,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Image.network(product['image'] ?? '', height: 120),
            const SizedBox(height: 10),
            Text(product['description'] ?? '-'),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Variants",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: variants.length,
                itemBuilder: (context, index) {
                  final v = variants[index];

                  return Card(
                    child: ListTile(
                      title: Text(v['type']),
                      subtitle: Text(
                          "Rp ${v['price']} • ${v['duration_days']} hari"),

                      /// 🔥 DELETE VARIANT
                      onLongPress: () => deleteVariant(v['id']),

                      /// 🔥 EDIT VARIANT
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/admin-add-variant',
                          arguments: {
                            ...product,
                            "variant": v,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}