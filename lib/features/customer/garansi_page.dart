import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/claims_service.dart';
import '../../widgets/shared/status_badge.dart';

class GaransiPage extends StatefulWidget {
  const GaransiPage({super.key});

  @override
  State<GaransiPage> createState() => _GaransiPageState();
}

class _GaransiPageState extends State<GaransiPage> {
  final ClaimsService service = ClaimsService();

  List claims = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final data = await service.getUserClaims();

    setState(() {
      claims = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        title: const Text("Garansi Saya"),
        backgroundColor: Colors.transparent,
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [

          if (claims.isEmpty)
            const Center(child: Text("Belum ada garansi")),

          ...claims.map((c) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/garansi-detail',
                  arguments: c,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Garansi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        StatusBadge(status: c['status']),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Text(c['problem_description'] ?? "-"),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}