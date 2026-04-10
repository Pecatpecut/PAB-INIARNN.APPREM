import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Rules & Terms"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      /// 🔥 NAVBAR

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

            /// 🔥 HEADER
            Text(
              "Terms & Conditions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            Space.h10,

            Text(
              "Harap membaca dan memahami ketentuan sebelum melakukan pembelian.",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            Space.h20,

            /// 🔥 TERMS CARD
            _card(
              context,
              icon: Icons.rule,
              title: "General Rules",
              items: [
                "Payment dilakukan di awal",
                "Tidak menerima refund",
                "Wajib mengikuti semua aturan",
                "Garansi berlaku sesuai ketentuan",
              ],
            ),

            Space.h20,

            /// 🔥 NOTES CARD
            _card(
              context,
              icon: Icons.info_outline,
              title: "Important Notes",
              items: [
                "Tidak melayani service device",
                "Jika tidak bisa login, cek device terlebih dahulu",
                "Harap sabar sesuai antrian",
              ],
            ),

            Space.h20,

            /// 🔥 WARNING CARD
            _card(
              context,
              icon: Icons.warning_amber_rounded,
              title: "Warning",
              items: [
                "Dilarang mengganti password tanpa izin",
                "Pelanggaran dapat menyebabkan akun diblokir",
                "Tidak bertanggung jawab atas kelalaian user",
              ],
            ),

            Space.h30,
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD SECTION
  Widget _card(BuildContext context,
      {required IconData icon,
      required String title,
      required List<String> items}) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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

          /// 🔥 TITLE
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          Space.h10,

          /// 🔥 LIST ITEM
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}