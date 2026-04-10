import 'package:flutter/material.dart';
import '../../core/constants.dart';

class PremiumProductTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;

  const PremiumProductTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: BorderRadius.circular(AppConstants.radius),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          color: theme.colorScheme.surface.withValues(alpha: 0.6),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [

            /// 🔥 LOGO
            Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      )
                      : Center(
                    child: Text(
                      title[0], // huruf pertama
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

            const SizedBox(width: 15),

            /// 🔥 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 ARROW
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    )
    );
  }
}