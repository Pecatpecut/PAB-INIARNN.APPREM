import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Social Media"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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

            /// 🔥 HEADER
            Text(
              "Connect With Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            Space.h10,

            Text(
              "Hubungi kami melalui platform berikut untuk bantuan atau informasi lebih lanjut.",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),

            Space.h20,

            /// 🔥 SOCIAL ITEMS
            _item(
              context,
              icon: Icons.chat,
              title: "WhatsApp",
              subtitle: "+62 852-4703-4305",
              color: Colors.green,
              url: "https://wa.me/6285247034305",
            ),

            _item(
              context,
              icon: Icons.camera_alt,
              title: "Instagram",
              subtitle: "@arnn.apprem",
              color: Colors.purple,
              url: "https://instagram.com/arnn.apprem",
            ),

            _item(
              context,
              icon: Icons.alternate_email,
              title: "X (Twitter)",
              subtitle: "@pisceslif",
              color: Colors.blue,
              url: "https://twitter.com/pisceslif",
            ),

            Space.h30,
          ],
        ),
      ),
    );
  }

  /// 🔥 SOCIAL CARD
  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String url,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [
                    const Color(0xFF1B1B2F),
                    const Color(0xFF1F1F3A),
                  ]
                : [
                    color.withValues(alpha: 0.15),
                    theme.colorScheme.surface,
                  ],
          ),
        ),
        child: Row(
          children: [

            /// 🔥 ICON
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 14),

            /// 🔥 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 ARROW
            Icon(
              Icons.open_in_new,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}