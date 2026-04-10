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

    /// 🔥 DATA DARI DETAIL
    final product = args["product"];
    final variant = args["variant"];

    final title = product["name"];
    final image = product["image"];

    final price = "Rp ${variant["price"]}";
    final subtitle =
        "${variant["duration_days"]} Days • ${variant["type"]}";

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: theme.colorScheme.surface,
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

        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Column(
            children: [

              Expanded(
                child: ListView(
                  children: [

                    /// 🔥 STEP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _StepItem("1", "Product", true),
                        _StepItem("2", "Payment", false),
                        _StepItem("3", "Confirm", false),
                      ],
                    ),

                    Space.h20,

                    /// 🔥 PRODUCT
                    CheckoutItemCard(
                      title: title,
                      subtitle: subtitle,
                      price: price,
                      image: image,
                    ),

                    Space.h20,

                    /// 🔥 EMAIL
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
                          _row("Service Fee", "Rp 0"),
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
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Email wajib diisi")),
                    );
                    return;
                  }

                  Navigator.pushNamed(
                    context,
                    '/payment',
                    arguments: {
                      "product": product,
                      "variant": variant,
                      "email": emailController.text,
                    },
                  );
                },
              ),

              Space.h20,
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 ROW SUMMARY
  Widget _row(String title, String value, {bool isBold = false}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔥 STEP ITEM (FIX ERROR KAMU)
class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final bool isActive;

  const _StepItem(this.number, this.title, this.isActive);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.primary,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}