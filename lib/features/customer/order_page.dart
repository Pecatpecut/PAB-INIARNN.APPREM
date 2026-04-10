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
        isLoading = false;
      });
    } catch (e) {
      print("ERROR ORDER: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : orders.isEmpty
                  ? _emptyState()
                  : _orderList(),
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

        ...orders.map((order) {
          return OrderCard(
            data: order,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/order-detail',
                arguments: order,
              );
            },
          );
        }).toList(),
      ],
    );
  }
}