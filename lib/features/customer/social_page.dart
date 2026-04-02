import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Media"),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [

            _item("WhatsApp", "wa.me/+6285247034305"),
            _item("Instagram", "@arnn.apprem"),
            _item("X (Twitter)", "@pisceslif"),

          ],
        ),
      ),
    );
  }

  Widget _item(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Row(
        children: [
          const Icon(Icons.link),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle),
            ],
          )
        ],
      ),
    );
  }
}