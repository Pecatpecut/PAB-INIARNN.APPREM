import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/checkout_item_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final TextEditingController emailController = TextEditingController();

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

    final title = "Netflix Premium"; // nanti bisa dinamis
    final price = args["price"] ?? "\$0.00";

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [

            Expanded(
              child: ListView(
                children: [

                  /// 🔥 STEP INDICATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _StepItem("1", "Product", true),
                      _StepItem("2", "Payment", false),
                      _StepItem("3", "Confirm", false),
                    ],
                  ),

                  Space.h20,

                  /// 🔥 PRODUCT CARD
                  CheckoutItemCard(
                    title: title,
                    subtitle: args["title"] ?? "Plan",
                    price: price,
                    image: 'assets/images/netflix.png',
                  ),

                  Space.h20,

                  /// 🔥 EMAIL INPUT
                  const Text("Email Address"),

                  Space.h10,

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "you@example.com",
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            AppConstants.radius),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  Space.h20,

                  /// 🔥 SUMMARY
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radius),
                    ),
                    child: Column(
                      children: [

                        _row("Subtotal", price),
                        _row("Service Fee", "\$0"),
                        const Divider(),

                        _row("Total", price, isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 BUTTON
            PrimaryButton(
              text: "Proceed to Payment",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    "price": price,
                  },
                );
              },
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔥 STEP WIDGET
class _StepItem extends StatelessWidget {
  final String number;
  final String label;
  final bool active;

  const _StepItem(this.number, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor:
              active ? const Color(0xFF6F5FEA) : Colors.grey,
          child: Text(number,
              style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}