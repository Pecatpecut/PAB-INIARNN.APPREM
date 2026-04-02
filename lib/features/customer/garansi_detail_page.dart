import 'package:flutter/material.dart';
import '../../core/constants.dart';

class GaransiDetailPage extends StatefulWidget {
  const GaransiDetailPage({super.key});

  @override
  State<GaransiDetailPage> createState() => _GaransiDetailPageState();
}

class _GaransiDetailPageState extends State<GaransiDetailPage> {
  final TextEditingController problemController = TextEditingController();
  bool uploaded = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    final data = args;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D18),

      appBar: AppBar(
        title: const Text("Detail Garansi"),
        backgroundColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 ORDER INFO
            Text(
              data["title"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 INPUT MASALAH
            const Text("Masalah", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 10),

            TextField(
              controller: problemController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contoh: Tidak bisa login...",
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 UPLOAD BUKTI
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
                        ? "Bukti berhasil diupload ✓"
                        : "Upload Screenshot",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// 🔥 SUBMIT
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Berhasil"),
                    content: const Text(
                        "Pengajuan garansi sedang diproses"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFACA3FF),
                      Color(0xFF6F5FEA),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Submit Garansi",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}