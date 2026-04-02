import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/cards/order_card.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// 🔥 DUMMY DATA (nanti dari Supabase)
    final orders = [
      {
        "title": "Netflix Premium",
        "date": "12 Feb 2026",
        "price": "Rp 45.000",
        "status": "success",
      },
      {
        "title": "Canva Pro",
        "date": "10 Feb 2026",
        "price": "Rp 15.000",
        "status": "pending",
      },
      {
        "title": "Spotify Premium",
        "date": "05 Feb 2026",
        "price": "Rp 20.000",
        "status": "expired",
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 TITLE
            const Text(
              "Your Orders",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Space.h20,

            /// 🔥 LIST ORDER
            ...orders.map((order) {
              return OrderCard(
                title: order["title"]!,
                date: order["date"]!,
                price: order["price"]!,
                status: order["status"]!,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/order-detail',
                    arguments: order,
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}