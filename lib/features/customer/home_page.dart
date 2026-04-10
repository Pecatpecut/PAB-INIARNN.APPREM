import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/navbar/bottom_navbar.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/cards/app_logo.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shared/section_header.dart';
import '../../widgets/shared/spacing.dart';

// service
import '../../services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final productService = ProductService();

  String userName = "User";
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchProducts();
  }

  Future fetchUser() async {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final data = await supabase
          .from('users')
          .select('name')
          .eq('id', user.id)
          .single();

      setState(() {
        userName = data['name'] ?? "User";
      });
    }
  }

  Future fetchProducts() async {
    final data = await productService.getProducts();

    setState(() {
      products = data;
      isLoading = false;
    });
  }

  String _getPrice(Map product) {
    final variants = product['product_variants'] ?? [];
    if (variants.isEmpty) return "N/A";

    return "Rp ${variants[0]['price']}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),

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
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.padding),
            children: [

              /// 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello, $userName 👋",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),

              Space.h20,

              /// 🔹 SUBSCRIPTION CARD
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        AppLogo(path: "assets/images/profile.png"),
                        SizedBox(width: 10),
                        Text("Netflix Premium",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),

                    Space.h15,

                    Text(
                      "15 Days Remaining",
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),

                    Space.h10,

                    LinearProgressIndicator(
                      value: 0.6,
                      color: theme.colorScheme.primary,
                    ),

                    Space.h15,

                    PrimaryButton(
                      text: "Extend",
                      onTap: () {
                        Navigator.pushNamed(context, '/products');
                      },
                    ),
                  ],
                ),
              ),

              Space.h20,

              /// 🔥 POPULAR APPS (DARI DATABASE)
              SectionHeader(
                title: "Popular Apps",
                actionText: "View All",
                onTap: () {
                  Navigator.pushNamed(context, '/products');
                },
              ),

              Space.h10,

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: products.take(3).map<Widget>((p) {
                        return const AppLogo(
                          path: "assets/images/profile.png",
                        );
                      }).toList(),
                    ),

              Space.h20,

              /// 🔥 BEST SELLERS (DARI DATABASE)
              const SectionHeader(title: "Best Sellers"),

              Space.h10,

              isLoading
                  ? const SizedBox()
                  : Column(
                      children: products.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ProductCard(
                            image: "assets/images/profile.png",
                            title: product['name'] ?? "-",
                            price: _getPrice(product),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: product,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),

              Space.h20,
            ],
          ),
        ),
      ),
    );
  }
}