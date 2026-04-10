import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shared/status_badge.dart';
import '../../services/claims_service.dart';

class GaransiPage extends StatefulWidget {
  const GaransiPage({super.key});

  @override
  State<GaransiPage> createState() => _GaransiPageState();
}

class _GaransiPageState extends State<GaransiPage> {
  final supabase = Supabase.instance.client;
  final claimsService = ClaimsService();
  final descriptionController = TextEditingController();

  String selectedReason = "Cannot login";
  XFile? pickedFile;
  Uint8List? imageBytes; 

  final reasons = [
    "Cannot login",
    "Account expired early",
    "Wrong account",
    "Other problem",
  ];

  // Upload gambar ke Storage
  Future<String?> uploadImage() async {
    if (pickedFile == null) return null;

    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final bytes = await pickedFile!.readAsBytes();
    final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('claim-proofs')
        .uploadBinary(fileName, bytes);

    return supabase.storage
        .from('claim-proofs')
        .getPublicUrl(fileName);
  }

  // Pilih gambar dari galeri
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final data =
        ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    final productName = data["product_name"] ?? "-";
    final status = data["status"] ?? "pending";
    final date = data["created_at"] ?? "-";
    final price = data["price"] ?? 0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Claim Warranty"),
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [

            /// 🔥 HEADER CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: theme.brightness == Brightness.dark
                      ? [
                          const Color(0xFF1B1B2F),
                          const Color(0xFF1F1F3A),
                        ]
                      : [
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          theme.colorScheme.surface,
                        ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StatusBadge(status: status),
                    ],
                  ),

                  Space.h10,

                  Text(
                    "Order • $date",
                    style:
                        const TextStyle(color: Colors.white54),
                  ),

                  Space.h10,

                  Text(
                    "Rp $price",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 REASON
            Text(
              "Select Problem",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),//

            Space.h10,

            Column(
                children: reasons.map((r) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.surface
                          .withValues(alpha: 0.7),
                    ),
                    child: RadioListTile<String>(
                      value: r,
                      groupValue: selectedReason,
                      onChanged: (value) {
                      setState(() => selectedReason = value!);
                    },
                      title: Text(r),
                    ),
                  );
                }).toList(),
              ),

            Space.h20,

            /// 🔥 DESCRIPTION
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            Space.h10,

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Explain your problem...",
                filled: true,
                fillColor:
                    theme.colorScheme.surface.withValues(alpha: 0.7),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Space.h20,

            /// 🔥 UPLOAD (sementara dummy)
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radius),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radius),
                        child: Image.memory(imageBytes!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : Center(
                        child: Text(
                          "Upload Screenshot",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
              ),
            ),

            Space.h30,

            /// 🔥 SUBMIT
            PrimaryButton(
              text: "Submit Claim",
              onTap: () async {
                final user = supabase.auth.currentUser;

                if (user == null) return;

                try {
                  final imageUrl = await uploadImage();

                  await claimsService.createClaim(
                    orderId: data['id'],
                    userId: user.id,
                    description:
                        "$selectedReason - ${descriptionController.text}",
                    imageUrl: imageUrl,    
                  );

                  if (!mounted) return;

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Success"),
                      content: const Text(
                          "Your warranty claim has been sent"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                } catch (e) {
                  print("ERROR CLAIM: $e");

                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to submit claim"),
                    ),
                  );
                }
              },
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }
}