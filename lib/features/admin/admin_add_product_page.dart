import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

class AdminAddProductPage extends StatefulWidget {
  const AdminAddProductPage({super.key});

  @override
  State<AdminAddProductPage> createState() =>
      _AdminAddProductPageState();
}

class _AdminAddProductPageState
    extends State<AdminAddProductPage> {

  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  String selectedCategory = "Streaming";

  XFile? pickedFile;
  Uint8List? imageBytes;

  final categories = [
    "Streaming",
    "Music",
    "Tools",
    "Other",
  ];

  /// 🔥 PICK IMAGE
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        pickedFile = picked;
        imageBytes = bytes;
      });
    }
  }

  /// 🔥 UPLOAD IMAGE
  Future<String?> uploadImage() async {
    if (pickedFile == null) return null;

    final fileName =
        'product_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final bytes = await pickedFile!.readAsBytes();

    await supabase.storage
        .from('product-images')
        .uploadBinary(fileName, bytes);

    return supabase.storage
        .from('product-images')
        .getPublicUrl(fileName);
  }

  /// 🔥 SAVE PRODUCT + VARIANT
  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    try {
      final imageUrl = await uploadImage();

      /// 🔥 INSERT PRODUCT
      final product = await supabase.from('products').insert({
        "name": nameController.text,
        "description": descController.text,
        "image": imageUrl,
        "category": selectedCategory,
        "is_active": true,
      }).select().single();

      /// 🔥 INSERT VARIANT
      await supabase.from('product_variants').insert({
        "product_id": product['id'],
        "type": "Default",
        "price": int.parse(priceController.text),
        "duration_days": int.parse(durationController.text),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );

      Navigator.pop(context);

    } catch (e) {
      print("ERROR ADD PRODUCT: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan produk")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
        ),

        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [

            /// 🔥 IMAGE UPLOAD
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  border: Border.all(),
                ),
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12),
                        child: Image.memory(imageBytes!,
                            fit: BoxFit.cover),
                      )
                    : const Center(
                        child: Text("Upload Product Image"),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 CARD FORM
            _card(
              child: Column(
                children: [

                  _input(nameController, "Product Name"),
                  _input(descController, "Description"),

                  /// CATEGORY
                  DropdownButtonFormField(
                    value: selectedCategory,
                    items: categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() =>
                          selectedCategory = value.toString());
                    },
                    decoration: const InputDecoration(
                      labelText: "Category",
                    ),
                  ),

                  const SizedBox(height: 10),

                  _input(priceController, "Price",
                      isNumber: true),
                  _input(durationController, "Duration (days)",
                      isNumber: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 SAVE BUTTON
            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: const Text("Save Product"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD UI
  Widget _card({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius:
            BorderRadius.circular(AppConstants.radius),
      ),
      child: child,
    );
  }

  /// 🔥 INPUT
  Widget _input(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.radius),
          ),
        ),
      ),
    );
  }
}