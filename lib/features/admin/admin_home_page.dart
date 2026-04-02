import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); /// nanti dulu ya lagi cape admin anjing 
    

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.padding),
          children: [

            /// 🔥 HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SYSTEM OVERVIEW",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFACA3FF), Color(0xFF6F5FEA)],
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 25),

            /// 🔥 STATS (BENTO)
            Row(
              children: [
                Expanded(child: _statCard("Transactions", "12,842", Icons.receipt)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("Income", "\$42.9K", Icons.attach_money)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _statCard("Users", "4,129", Icons.people)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("Pending", "23", Icons.pending)),
              ],
            ),

            const SizedBox(height: 25),

            /// 🔥 CHART (DUMMY)
            _chartCard(),

            const SizedBox(height: 25),

            /// 🔥 SYSTEM HEALTH
            _systemHealth(),

            const SizedBox(height: 25),

            /// 🔥 QUICK NAV (FLOW KAMU)
            const Text(
              "Management",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _menu(context, "Orders", Icons.receipt, '/admin-order'),
                _menu(context, "Products", Icons.apps, '/admin-product'),
                _menu(context, "Garansi", Icons.verified, '/admin-garansi'),
                _menu(context, "Add Product", Icons.add_box, '/admin-add-product'),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// 🔥 STAT CARD
  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242434),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 CHART (FAKE UI)
  Widget _chartCard() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181826),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Revenue Velocity",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                10,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: (index + 2) * 10,
                    decoration: BoxDecoration(
                      color: index == 8
                          ? Colors.tealAccent
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 SYSTEM HEALTH
  Widget _systemHealth() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181826),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("System Health",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Server Uptime: 80%"),
          SizedBox(height: 5),
          Text("Database Sync: Optimal"),
        ],
      ),
    );
  }

  /// 🔥 MENU NAV
  Widget _menu(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF242434),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}