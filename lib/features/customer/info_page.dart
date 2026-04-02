import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/navbar/bottom_navbar.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/shared/spacing.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 3),

      appBar: AppBar(
        title: const Text("Info & Rules"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 HEADER BRANDING
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "iniarnn.apprem",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Space.h10,
                  Text("apps premium by arnn 🐰"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 SOCIAL MEDIA
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Contact & Social Media",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  _item("WhatsApp", "wa.me/+6285247034305"),
                  _item("Instagram", "@arnn.apprem"),
                  _item("X / Twitter", "@pisceslif"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 RULES SINGKAT
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text("Rules",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  Text("• Wajib tanya stok sebelum order"),
                  Text("• Payment dilakukan di awal"),
                  Text("• Tidak ada refund"),
                  Text("• No rude buyer"),
                  Text("• Garansi berlaku sesuai ketentuan"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 TERMS & CONDITIONS
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text("Terms & Conditions",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  Text("• Dengan membeli, berarti setuju S&K"),
                  Text("• Proses 2–30 menit tergantung antrian"),
                  Text("• Tidak bisa cancel setelah diproses"),
                  Text("• Garansi jika mengikuti aturan"),
                  Text("• Tidak melayani service device"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 CATATAN
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [

                  Text("Important Notes",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  Text("• Jika tidak bisa login, coba:"),
                  Text("- Clear cache"),
                  Text("- Reinstall app"),
                  Text("- Gunakan device lain"),
                  Text("- Ikuti panduan seller"),
                ],
              ),
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}