import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/navbar/bottom_navbar.dart';
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
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    /// 🔥 NAVBAR TOP
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  const AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(width: 10),
            Text(
              "INIARNN.APPREM",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),

        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
      ],
    ),

    const SizedBox(height: 20),

    /// 🔥 STATUS
    Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "STATUS: ONLINE",
            style: TextStyle(fontSize: 10, color: Colors.green),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.circle, size: 8, color: Colors.green),
      ],
    ),

    const SizedBox(height: 10),

    /// 🔥 HELLO USER (KINETIC STYLE)
    RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Hello, ",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          TextSpan(
            text: userName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 8),

    Text(
      "Your subscription fleet is currently operating at peak efficiency.",
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    ),
  ],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: products.take(3).map<Widget>((p) {
          final imageUrl = p['image'];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: p,
              );
            },
            child: Column(
              children: [

                /// 🔥 LOGO DARI SUPABASE
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,

                          /// 🔥 LOADING
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },

                          /// 🔥 ERROR FALLBACK
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        )
                      : Center(
                          child: Text(
                            p['name'][0], // huruf pertama
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 6),

                /// 🔥 NAMA APP
                SizedBox(
                  width: 70,
                  child: Text(
                    p['name'] ?? "-",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
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
        children: products.take(5).map((product) {
          final imageUrl = product['image'];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: product,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.9),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.1),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 TOP (LOGO + CATEGORY)
                  Row(
                    children: [

                      /// LOGO
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.black,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image),
                      ),

                      const SizedBox(width: 12),

                      /// CATEGORY
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (product['category'] ?? 'ENTERTAINMENT')
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// 🔥 TITLE
                  Text(
                    product['name'] ?? "-",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// 🔥 PRICE
                  Text(
                    "Starting from ${_getPrice(product)}",
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 🔥 BUTTON
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "VIEW DETAILS",
                        style: TextStyle(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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