import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/plan_card.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  int selectedIndex = 1;

  final plans = [
    {
      "title": "3 Days",
      "price": "\$0.99",
      "features": ["Shared Account", "1080p"],
    },
    {
      "title": "1 Month (Best Value)",
      "price": "\$8.50",
      "features": ["Private Account", "Ultra HD", "4 Screens"],
    },
    {
      "title": "7 Days",
      "price": "\$2.75",
      "features": ["Private Profile", "HD Quality"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    final title = args?["title"] ?? "Netflix Premium";

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [

            Expanded(
              child: ListView(
                children: [

                  /// 🔥 TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Space.h10,

                  const Text(
                    "Experience premium features with high quality access.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  Space.h20,

                  /// 🔥 TAGS
                  Wrap(
                    spacing: 10,
                    children: const [
                      Chip(label: Text("Ultra HD 4K")),
                      Chip(label: Text("Spatial Audio")),
                      Chip(label: Text("Ad-Free")),
                    ],
                  ),

                  Space.h20,

                  /// 🔥 FEATURES
                  const Text("Features",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  const Text("• Instant Delivery"),
                  const Text("• Full Warranty"),
                  const Text("• 24/7 Support"),
                  const Text("• Multi-platform"),

                  Space.h20,

                  /// 🔥 PLAN LIST
                  const Text("Select Plan",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h10,

                  ...List.generate(plans.length, (index) {
                    final plan = plans[index];

                    return PlanCard(
                      title: plan["title"] as String,
                      price: plan["price"] as String,
                      features:
                          List<String>.from(plan["features"] as List),
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),

            /// 🔥 ORDER BUTTON
            PrimaryButton(
              text: "Order Now",
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/checkout',
                  arguments: plans[selectedIndex],
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