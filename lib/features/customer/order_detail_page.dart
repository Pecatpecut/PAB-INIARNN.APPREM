import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/shared/status_badge.dart';
import '../../widgets/buttons/primary_button.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    final title = args["title"] ?? "Product";
    final price = args["price"] ?? "Rp 0";
    final date = args["date"] ?? "-";
    final status = args["status"] ?? "pending";

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Order Detail"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 PRODUCT INFO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      StatusBadge(status: status),
                    ],
                  ),

                  Space.h10,

                  Text(
                    "Order Date: $date",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  Space.h10,

                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 ACCOUNT INFO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radius),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Account Information",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  SizedBox(height: 10),

                  Text("Email: user@email.com"),
                  Text("Password: ********"),
                  Text("Status: Active"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 ACTION BUTTONS
            PrimaryButton(
              text: "Claim Warranty",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/garansi',
                  arguments: args,
                );
              },
            ),

            Space.h10,

            PrimaryButton(
              text: "Contact Support",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contact admin via WhatsApp"),
                  ),
                );
              },
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }
}