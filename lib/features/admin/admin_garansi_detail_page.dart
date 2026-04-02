import 'package:flutter/material.dart';
import '../../core/constants.dart';

class AdminGaransiDetailPage extends StatefulWidget {
  const AdminGaransiDetailPage({super.key});

  @override
  State<AdminGaransiDetailPage> createState() =>
      _AdminGaransiDetailPageState();
}

class _AdminGaransiDetailPageState
    extends State<AdminGaransiDetailPage> {

  final TextEditingController solusiController =
      TextEditingController();
  final TextEditingController rejectController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      appBar: AppBar(
        title: const Text("Detail Garansi"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [

          _info("Product", data["product"]),
          _info("User", data["user"]),
          _info("Issue", data["issue"]),

          const SizedBox(height: 20),

          /// 🔥 APPROVE (SOLUSI)
          const Text("Solusi"),
          const SizedBox(height: 5),

          _input(solusiController, "Masukkan solusi"),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              _showDialog(context, "Approved");
            },
            child: const Text("Approve"),
          ),

          const SizedBox(height: 20),

          /// 🔥 REJECT
          const Text("Alasan Reject"),
          const SizedBox(height: 5),

          _input(rejectController, "Masukkan alasan"),

          const SizedBox(height: 15),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              _showDialog(context, "Rejected");
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text("$title : $value"),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF181826),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(status),
        content: Text("Garansi telah $status"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}