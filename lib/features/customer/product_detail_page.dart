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

  late List<Map<String, dynamic>> variants;
  int selectedIndex = 0;

  late Map product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    product = ModalRoute.of(context)?.settings.arguments as Map;

    variants = List<Map<String, dynamic>>.from(
      product['product_variants'] ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = product['name'] ?? "-";
    final image = product['image'];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

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

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              children: [

                /// 🔙 BACK
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back,
                          color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),

                Expanded(
                  child: ListView(
                    children: [

                      /// 🔥 LOGO
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: theme.colorScheme.surface,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: image != null
                                ? Image.network(image, fit: BoxFit.cover)
                                : const Icon(Icons.image, size: 40),
                          ),

                          Space.h15,

                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),

                          Space.h10,

                          Text(
                            product['description'] ?? "-",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),

                      Space.h20,

                      /// 🔥 TAG
                      Wrap(
                        spacing: 10,
                        children: [
                          _tag(context, "Premium"),
                          _tag(context, "Fast Delivery"),
                          _tag(context, "Warranty"),
                        ],
                      ),

                      Space.h20,

                      /// 🔥 PLAN
                      Text(
                        "Choose Plan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      Space.h10,

                      /// 🔥 VARIANTS
                      ...List.generate(variants.length, (index) {
                        final v = variants[index];

                        return PlanCard(
                          title: "${v['duration_days']} Days",
                          price: "Rp ${v['price']}",
                          features: [
                            v['type'] ?? '-',
                            "Active Plan",
                          ],
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

                /// 🔥 BUTTON
                PrimaryButton(
                  text: "Order Now",
                  onTap: () {
                    final selectedVariant = variants[selectedIndex];

                    Navigator.pushNamed(
                      context,
                      '/checkout',
                      arguments: {
                        "product": product,
                        "variant": selectedVariant,
                      },
                    );
                  },
                ),

                Space.h20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}