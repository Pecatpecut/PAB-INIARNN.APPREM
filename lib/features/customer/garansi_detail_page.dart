import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/shared/status_badge.dart';

class GaransiDetailPage extends StatelessWidget {
  const GaransiDetailPage({super.key});

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

            /// 🔥 STATUS + HEADER
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status Garansi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      StatusBadge(status: data['status']),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 🔥 MASALAH USER
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Masalah",
                    style:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(data['problem_description'] ?? "-"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 🔥 BUKTI IMAGE
            if (data['proof_image'] != null &&
                data['proof_image'].toString().isNotEmpty)
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bukti",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12),
                      child: Image.network(
                        data['proof_image'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            /// 🔥 ADMIN NOTE
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Respon Admin",
                    style:
                        TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  if (data['admin_note'] != null &&
                      data['admin_note']
                          .toString()
                          .isNotEmpty)
                    Text(data['admin_note'])
                  else
                    Text(
                      "Menunggu respon admin...",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 STATUS MESSAGE (UX BONUS)
            if (data['status'] == 'approved')
              _statusInfo(
                  "Garansi disetujui. Silakan cek instruksi dari admin.",
                  Colors.green),

            if (data['status'] == 'rejected')
              _statusInfo(
                  "Garansi ditolak. Periksa alasan dari admin.",
                  Colors.red),

            if (data['status'] == 'pending')
              _statusInfo(
                  "Garansi sedang diproses oleh admin.",
                  Colors.orange),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD STYLE
  Widget _card({required Widget child}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                theme.colorScheme.surface.withValues(alpha: 0.7),
            borderRadius:
                BorderRadius.circular(AppConstants.radius),
          ),
          child: child,
        );
      },
    );
  }

  /// 🔥 STATUS INFO BOX
  Widget _statusInfo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}