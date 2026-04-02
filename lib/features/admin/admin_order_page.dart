import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminOrderPage extends StatelessWidget {
  const AdminOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final orders = [
      {
        "name": "Alex",
        "product": "Netflix Premium",
        "duration": "1 Month",
        "price": "\$8.50",
      },
      {
        "name": "Sarah",
        "product": "Spotify",
        "duration": "1 Month",
        "price": "\$3.49",
      },
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.padding),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return _orderCard(context, order);
        },
      ),
    );
  }

  Widget _orderCard(BuildContext context, Map order) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(order["product"],
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 5),

          Text("User: ${order["name"]}"),
          Text("Duration: ${order["duration"]}"),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order["price"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/admin-order-detail',
                    arguments: order,
                  );
                },
                child: const Text("Detail"),
              ),
            ],
          )
        ],
      ),
    );
  }
}