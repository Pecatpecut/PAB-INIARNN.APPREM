import 'package:flutter/material.dart';
import '../../services/product_service.dart';

class AdminAddVariantPage extends StatefulWidget {
  const AdminAddVariantPage({super.key});

  @override
  State<AdminAddVariantPage> createState() =>
      _AdminAddVariantPageState();
}

class _AdminAddVariantPageState extends State<AdminAddVariantPage> {
  final service = ProductService();

  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  Map? variant;
  late Map product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map;

    product = args;
    variant = args['variant'];

    /// 🔥 AUTO FILL (EDIT MODE)
    if (variant != null) {
      typeController.text = variant!['type'];
      priceController.text = variant!['price'].toString();
      durationController.text =
          variant!['duration_days'].toString();
    }
  }

  Future<void> submit() async {
    if (variant == null) {
      /// ADD
      await service.supabase.from('product_variants').insert({
        "product_id": product['id'],
        "type": typeController.text,
        "price": int.parse(priceController.text),
        "duration_days": int.parse(durationController.text),
        "is_active": true,
      });
    } else {
      /// UPDATE
      await service.updateVariant(variant!['id'], {
        "type": typeController.text,
        "price": int.parse(priceController.text),
        "duration_days": int.parse(durationController.text),
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(variant == null ? "Add Variant" : "Edit Variant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: "Type"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: "Duration"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}