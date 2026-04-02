import 'package:flutter/material.dart';
import '../../core/constants.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rules & Terms"),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: const [

            Text(
              "Terms & Conditions",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text("• Payment dilakukan di awal"),
            Text("• No refund"),
            Text("• Wajib mengikuti rules"),
            Text("• Garansi berlaku sesuai ketentuan"),

            SizedBox(height: 20),

            Text(
              "Important Notes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text("• Tidak melayani service device"),
            Text("• Jika tidak bisa login, cek device"),
            Text("• Harap sabar sesuai antrian"),
          ],
        ),
      ),
    );
  }
}