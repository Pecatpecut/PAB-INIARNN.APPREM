import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Duration timeLeft = const Duration(hours: 23, minutes: 59, seconds: 59);
  Timer? timer;
  bool uploaded = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeLeft.inSeconds > 0) {
        setState(() {
          timeLeft -= const Duration(seconds: 1);
        });
      }
    });
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    final data = args;
    final price = data["price"] ?? "Rp 0";

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 STATUS + TIMER
            Column(
              children: [
                const Icon(Icons.access_time, size: 50),
                Space.h10,
                const Text(
                  "Waiting for Payment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Space.h10,
                Text(
                  "Expires in ${formatTime(timeLeft)}",
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Space.h20,

            /// 🔥 QRIS CARD (PREMIUM)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radius),
              ),
              child: Column(
                children: [
                  const Text("QRIS Payment",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  Space.h15,

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/qris.png',
                      height: 150,
                    ),
                  ),

                  Space.h15,

                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 SUMMARY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radius),
              ),
              child: Column(
                children: [
                  _row("Subtotal", price),
                  _row("Service Fee", "Rp 0"),
                  const Divider(),
                  _row("Total", price, bold: true),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 INSTRUKSI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius:
                    BorderRadius.circular(AppConstants.radius),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How to Pay",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("1. Open e-wallet"),
                  Text("2. Scan QR Code"),
                  Text("3. Complete payment"),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 UPLOAD PROOF
            GestureDetector(
              onTap: () {
                setState(() {
                  uploaded = true;
                });
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    uploaded
                        ? "✔ Uploaded successfully"
                        : "Upload Proof of Payment",
                  ),
                ),
              ),
            ),

            Space.h30,

            /// 🔥 BUTTON
            PrimaryButton(
              text: "Confirm Payment",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Success"),
                    content:
                        const Text("Pesanan sedang diproses"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/orders');
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}