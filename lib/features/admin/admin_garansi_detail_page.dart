import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/claims_service.dart';

class AdminGaransiDetailPage extends StatefulWidget {
  const AdminGaransiDetailPage({super.key});

  @override
  State<AdminGaransiDetailPage> createState() =>
      _AdminGaransiDetailPageState();
}

class _AdminGaransiDetailPageState
    extends State<AdminGaransiDetailPage> {

  final ClaimsService service = ClaimsService();

  final TextEditingController noteController =
      TextEditingController();

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

    final order = data['orders'] ?? {};

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Detail Garansi"),
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

            /// 🔥 INFO
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info("Product",
                      order['product_name'] ?? "Unknown"),
                  _info("Variant",
                      order['variant_type'] ?? "-"),
                  _info("Issue",
                      data['problem_description'] ?? "-"),

                  const SizedBox(height: 10),

                  if (data['admin_note'] != null)
                    _info("Admin Note", data['admin_note']),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 IMAGE
            if (data['proof_image'] != null &&
                data['proof_image'].toString().isNotEmpty)
              _card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    data['proof_image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// 🔥 SINGLE INPUT
            const Text("Admin Note"),
            const SizedBox(height: 5),

            _input(noteController, "Masukkan catatan admin"),

            const SizedBox(height: 20),

            /// 🔥 BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await service.updateClaim(
                        id: data['id'],
                        status: "approved",
                        note: noteController.text,
                      );

                      _showDialog("Approved");
                    },
                    child: const Text("Approve"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await service.updateClaim(
                        id: data['id'],
                        status: "rejected",
                        note: noteController.text,
                      );

                      _showDialog("Rejected");
                    },
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD
  Widget _card({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text("$title : $value"),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDialog(String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(status),
        content: Text("Garansi telah $status"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}