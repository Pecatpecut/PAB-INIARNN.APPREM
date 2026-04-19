import 'package:flutter/material.dart';

class PremiumOrderCard extends StatelessWidget {
  final Map data;
  final VoidCallback? onTap;

  const PremiumOrderCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// 🔥 SAFE PARSE DATA
    final createdAt = DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
    final duration = data['duration_days'] ?? 30;
    final status = (data['status'] ?? 'pending').toString();
    final imageUrl = data['products']?['image'];

    final endDate = createdAt.add(Duration(days: duration));
    final now = DateTime.now();

    int remaining = endDate.difference(now).inDays;

    /// 🔥 FIX NEGATIF (PENTING)
    if (remaining < 0) remaining = 0;

    /// 🔥 STATUS LOGIC
    final isApproved = status == 'approved';
    final isPending = status == 'pending';
    final isExpired = isApproved && remaining == 0;
    final isActive = isApproved && remaining > 0;

    /// 🔥 PROGRESS
    double progress = duration > 0 ? (remaining / duration) : 0;
    if (progress < 0) progress = 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TOP SECTION
            Row(
              children: [

                /// 🔥 IMAGE (NO DUMMY ERROR)


Container(
  width: 50,
  height: 50,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.black,
  ),
  clipBehavior: Clip.hardEdge,
  child: imageUrl != null && imageUrl.toString().isNotEmpty
      ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported),
        )
      : const Icon(Icons.image),
),

                const SizedBox(width: 12),

                /// 🔥 TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['product_name'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${data['variant_type'] ?? '-'} • $duration Days",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔥 STATUS BADGE (FIX)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.2)
                        : isPending
                            ? Colors.orange.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    isActive
                        ? "ACTIVE"
                        : isPending
                            ? "PENDING"
                            : "EXPIRED",
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive
                          ? Colors.green
                          : isPending
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔥 LABEL
            Text(
              "Subscription Progress",
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 6),

            /// 🔥 PROGRESS BAR
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: theme.colorScheme.surface
                        .withValues(alpha: 0.3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: isPending ? 0 : progress,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: isExpired
                            ? [Colors.red, Colors.redAccent]
                            : [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 🔥 STATUS TEXT (FIX TOTAL)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                isPending
                    ? "Menunggu aktivasi"
                    : isExpired
                        ? "Masa premium telah berakhir"
                        : "$remaining Days Left",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isExpired
                      ? Colors.red
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}