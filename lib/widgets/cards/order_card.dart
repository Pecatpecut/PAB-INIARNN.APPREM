import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String status;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.onTap,
  });

  Color getStatusColor() {
    switch (status) {
      case "success":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "expired":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    switch (status) {
      case "success":
        return "Success";
      case "pending":
        return "Pending";
      case "expired":
        return "Expired";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TOP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getStatusText(),
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(date, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 10),

            Text(price,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}