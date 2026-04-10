import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/admin_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {

  final adminService = AdminService();

  int totalOrders = 0;
  int totalUsers = 0;
  int totalIncome = 0;
  List<int> monthlyIncome = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final orders = await adminService.getTotalOrders();
    final users = await adminService.getTotalUsers();
    final income = await adminService.getTotalIncome();
    final monthly = await adminService.getMonthlyIncome();

    setState(() {
      totalOrders = orders;
      totalUsers = users;
      totalIncome = income;
      monthlyIncome = monthly;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      /// ❌ FAB DIHAPUS

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

                    /// 🔥 ORDER MASUK (INI YANG KAMU BUTUH)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/admin-order');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long,
                                size: 40, color: Colors.black),
                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Order Masuk",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "$totalOrders transaksi",
                                    style: const TextStyle(
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.black),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 STATS
                    Row(
                      children: [
                        Expanded(child: _card("Orders",
                            "$totalOrders", Icons.receipt)),
                        const SizedBox(width: 12),
                        Expanded(child: _card("Users",
                            "$totalUsers", Icons.people)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _card("Income",
                            "Rp $totalIncome", Icons.attach_money)),
                        const SizedBox(width: 12),
                        Expanded(child: _card("Active",
                            "$totalOrders", Icons.trending_up)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// 🔥 CHART
                    Text(
                      "Monthly Income",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 15),

                    _chart(monthlyIncome),

                    const SizedBox(height: 30),
                  ],
                ),
        ),
      ),
    );
  }

  /// 🔥 CARD (UPGRADE UI)
  Widget _card(String title, String value, IconData icon) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.secondary),
          const SizedBox(height: 10),
          Text(title),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _chart(List<int> data) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((value) {
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
}