import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/navbar/bottom_navbar.dart';
import '../../widgets/cards/app_card.dart';
import '../../widgets/cards/app_logo.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shared/section_header.dart';
import '../../widgets/shared/spacing.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 0),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [

            /// 🔹 HEADER + SEARCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, User!",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  child: const Icon(Icons.search),
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

                  const Text("15 Days Remaining"),

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

            /// 🔹 WALLET
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Wallet"),
                  Space.h10,
                  Text(
                    "\$458.20",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔹 POPULAR APPS
            SectionHeader(
              title: "Popular Apps",
              actionText: "View All",
              onTap: () {
                Navigator.pushNamed(context, '/products');
              },
            ),

            Space.h10,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                AppLogo(path: "assets/images/profile.png"),
                AppLogo(path: "assets/images/profile.png"),
                AppLogo(path: "assets/images/profile.png"),
              ],
            ),

            Space.h20,

            /// 🔹 BEST SELLERS
            const SectionHeader(title: "Best Sellers"),

            Space.h10,

            ProductCard(
              image: "assets/images/profile.png",
              title: "Netflix Global",
              price: "\$4.99",
              onTap: () {
                Navigator.pushNamed(context, '/detail');
              },
            ),

            Space.h15,

            ProductCard(
              image: "assets/images/profile.png",
              title: "Spotify Individual",
              price: "\$1.99",
              onTap: () {
                Navigator.pushNamed(context, '/detail');
              },
            ),

            Space.h15,

            ProductCard(
              image: "assets/images/profile.png",
              title: "Adobe Creative Cloud",
              price: "\$12.99",
              onTap: () {
                Navigator.pushNamed(context, '/detail');
              },
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }
}