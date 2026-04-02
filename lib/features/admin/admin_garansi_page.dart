import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminGaransiPage extends StatelessWidget {
  const AdminGaransiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      appBar: AppBar(
        title: const Text("Garansi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [

          _card(context, "Netflix Premium", "Alex", "Problem Login"),
          _card(context, "Spotify", "Sarah", "Account Error"),
        ],
      ),
    );
  }

  Widget _card(
      BuildContext context, String product, String user, String issue) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/admin-garansi-detail',
          arguments: {
            "product": product,
            "user": user,
            "issue": issue,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF242434),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("User: $user"),
            Text("Issue: $issue"),
          ],
        ),
      ),
    );
  }
}