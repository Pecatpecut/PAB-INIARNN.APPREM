import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map data;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final productName = data['product_name'] ?? '-';
    final variantType = data['variant_type'] ?? '-';
    final duration = data['duration_days'] ?? 0;
    final price = data['price'] ?? 0;
    final status = data['status'] ?? 'pending';

    final imageUrl =
        data['products'] != null ? data['products']['image'] : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color(0xFF1B1B2F),
                    const Color(0xFF1F1F3A),
                  ]
                : [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    Theme.of(context).colorScheme.surface,
                  ],
          ),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER
            Row(
              children: [

                /// 🔥 IMAGE DARI SUPABASE
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
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
                            productName[0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                Text(
              "Premium Subscription",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
                ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔥 BADGE
            Row(
              children: [
                _badge(
                  text: "$duration Days",
                  color: Colors.purpleAccent,
                ),
                const SizedBox(width: 8),
                _badge(
                  text: status.toUpperCase(),
                  color: _statusColor(status),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔥 VARIANT BOX
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    variantType,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                  ),
                  ),
                  Text(
                    "Rp $price",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'success':
        return Colors.greenAccent;
      case 'pending':
        return Colors.orangeAccent;
      case 'expired':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}