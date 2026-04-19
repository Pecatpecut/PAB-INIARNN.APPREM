import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/cards/order_card.dart';
import '../../widgets/navbar/bottom_navbar.dart';

// service
import '../../services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

List filteredOrders = [];
String selectedFilter = 'all';
String searchQuery = '';

class _OrderPageState extends State<OrderPage> {
  final orderService = OrderService();

  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future fetchOrders() async {
  try {
    final data = await orderService.getOrders();

    setState(() {
      orders = data;
      filteredOrders = data;
      isLoading = false;
    });
  } catch (e) {
    print("ERROR ORDER: $e");

    setState(() {
      isLoading = false;
    });
  }
}

void applyFilter() {
  final now = DateTime.now();

  List temp = orders.where((order) {
    final status = (order['status'] ?? 'pending').toString();

    final createdAt =
        DateTime.tryParse(order['created_at'] ?? '') ?? now;
    final duration = order['duration_days'] ?? 30;
    final endDate = createdAt.add(Duration(days: duration));

    int remaining = endDate.difference(now).inDays;
    if (remaining < 0) remaining = 0;

    final isActive = status == 'approved' && remaining > 0;
    final isPending = status == 'pending';
    final isExpired = status == 'approved' && remaining == 0;

    /// 🔥 FILTER STATUS
    bool matchFilter = false;

    if (selectedFilter == 'all') matchFilter = true;
    if (selectedFilter == 'active') matchFilter = isActive;
    if (selectedFilter == 'pending') matchFilter = isPending;
    if (selectedFilter == 'expired') matchFilter = isExpired;

    /// 🔥 SEARCH (product name)
    final name =
        (order['product_name'] ?? '').toString().toLowerCase();

    final matchSearch =
        name.contains(searchQuery.toLowerCase());

    return matchFilter && matchSearch;
  }).toList();

  setState(() {
    filteredOrders = temp;
  });
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

          return Scaffold(
  backgroundColor: theme.colorScheme.surface,
  bottomNavigationBar: const CustomBottomNavbar(currentIndex: 2),

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 NAVBAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.blur_on, size: 20),
                    const SizedBox(width: 8),
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
                const Icon(Icons.search),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔥 SEARCH BAR
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.colorScheme.surface.withValues(alpha: 0.4),
              ),
              child:  Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      applyFilter();
                    },
                    decoration: const InputDecoration(
                      hintText: "Search orders...",
                      border: InputBorder.none,
                    ),
                    ),
                  )
                ],
              ),
            ),


            SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filterButton("All", "all"),
                  _filterButton("Active", "active"),
                  _filterButton("Pending", "pending"),
                  _filterButton("Expired", "expired"),
                ],
              ),

            const SizedBox(height: 20),

            /// 🔥 CONTENT (INI PENTING)
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orders.isEmpty
                      ? _emptyState()
                      : _orderList(),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 60),
          const SizedBox(height: 10),
          const Text(
            "Kamu belum melakukan pembelian",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text(
            "Yuk beli produk premium sekarang!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label, String value) {
  final isSelected = selectedFilter == value;

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedFilter = value;
      });
      applyFilter();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    ),
  );
}

  Widget _orderList() {
    return ListView(
      children: [
        const Text(
          "Your Orders",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        Space.h20,

        ...filteredOrders.map((order) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [

                /// 🔥 CARD ORDER (ASLI)
                PremiumOrderCard(
                  data: order,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/order-detail',
                      arguments: order,
                    );
                  },
                ),

                const SizedBox(height: 8),

              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}