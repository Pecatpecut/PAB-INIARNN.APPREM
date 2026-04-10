import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/claims_service.dart';

class AdminGaransiPage extends StatefulWidget {
  const AdminGaransiPage({super.key});

  @override
  State<AdminGaransiPage> createState() => _AdminGaransiPageState();
}

class _AdminGaransiPageState extends State<AdminGaransiPage> {
  final ClaimsService _service = ClaimsService();

  List claims = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

Future<void> fetch() async {
  try {
    final data = await _service.getClaims();

    setState(() {
      claims = data;
      isLoading = false;
    });
  } catch (e) {
    print("ERROR GARANSI: $e");

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
                      "Garansi Management",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 LIST CLAIM
                    ...claims.map((c) => _card(c)).toList(),
                  ],
                ),
        ),
      ),
    );
  }

  /// 🔥 CARD
  Widget _card(Map c) {
    final theme = Theme.of(context);

    final status = c['status'] ?? 'pending';

    final order = c['orders'] ?? {};

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/admin-garansi-detail',
          arguments: c,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppConstants.radius),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 PRODUCT + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['product_name'] ?? 'Unknown Product',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _statusBadge(status),
              ],
            ),

            const SizedBox(height: 8),

            Text("Variant: ${order['variant_type'] ?? '-'}"),

            const SizedBox(height: 8),

            Text(
              c['problem_description'] ?? '-',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 10),

            /// 🔥 IMAGE (JIKA ADA)
            if (c['proof_image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  c['proof_image'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 🔥 STATUS BADGE
  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}