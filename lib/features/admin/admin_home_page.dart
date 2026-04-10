import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/order_service.dart';
import '../../services/product_service.dart';
import '../../services/claims_service.dart';
import '../../services/admin_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final OrderService orderService = OrderService();
  final ProductService productService = ProductService();
  final ClaimsService claimsService = ClaimsService();
  final AdminService adminService = AdminService();

  int totalOrders = 0;
  int totalProducts = 0;
  int totalClaims = 0;
  int totalUsers = 0;
  int totalIncome = 0;

  List<int> monthlyIncome = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    final orders = await adminService.getTotalOrders();
    final users = await adminService.getTotalUsers();
    final income = await adminService.getTotalIncome();
    final monthly = await adminService.getMonthlyIncome();

    final products = await productService.getProducts();
    final claims = await claimsService.getClaims();

    setState(() {
      totalOrders = orders;
      totalUsers = users;
      totalIncome = income;
      monthlyIncome = monthly;

      totalProducts = products.length;
      totalClaims = claims.length;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin-add-product');
        },
        child: const Icon(Icons.add),
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

        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  children: [

                    /// 🔥 HEADER
                    Text(
                      "Admin Dashboard",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

/// 🔥 BUTTON ORDER MASUK (FIX KELIHATAN)
Container(
  width: double.infinity,
  margin: const EdgeInsets.only(bottom: 20),
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/admin-order');
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.colorScheme.primary,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.receipt_long),
        const SizedBox(width: 10),
        Text(
          "Lihat Order Masuk ($totalOrders)",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ),
),

                    /// 🔥 MAIN STATS
                    Row(
                      children: [
                        Expanded(child: _stat("Orders", "$totalOrders", Icons.receipt)),
                        const SizedBox(width: 12),
                        Expanded(child: _stat("Users", "$totalUsers", Icons.people)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _stat("Income", "Rp $totalIncome", Icons.attach_money)),
                        const SizedBox(width: 12),
                        Expanded(child: _stat("Products", "$totalProducts", Icons.inventory)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// 🔥 CHART INCOME
                    Text(
                      "Monthly Income",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _chart(),

                    const SizedBox(height: 25),

                    /// 🔥 QUICK MENU
                    Text(
                      "Management",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.secondary),
          const SizedBox(height: 10),
          Text(title),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _chart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: monthlyIncome.map((value) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: (value / 1000).clamp(5, 150).toDouble(),
              decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _menu(BuildContext context, String title, IconData icon, String route) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.3),
              theme.colorScheme.secondary.withValues(alpha: 0.2),
            ],
          ),
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