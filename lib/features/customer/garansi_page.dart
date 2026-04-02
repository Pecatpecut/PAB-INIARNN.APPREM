import 'package:flutter/material.dart';
import '../../core/constants.dart';

// widgets
import '../../widgets/shared/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/shared/status_badge.dart';

class GaransiPage extends StatefulWidget {
  const GaransiPage({super.key});

  @override
  State<GaransiPage> createState() => _GaransiPageState();
}

class _GaransiPageState extends State<GaransiPage> {
  String selectedReason = "Cannot login";
  bool uploaded = false;

  final reasons = [
    "Cannot login",
    "Account expired early",
    "Wrong account",
    "Other problem",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    final title = args["title"] ?? "Product";
    final status = args["status"] ?? "pending";
    final date = args["date"] ?? "-";

    return Scaffold(
      backgroundColor: theme.colorScheme.background,

      appBar: AppBar(
        title: const Text("Claim Warranty"),
        backgroundColor: theme.colorScheme.surface,
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: ListView(
          children: [

            /// 🔥 ORDER INFO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StatusBadge(status: status),
                    ],
                  ),

                  Space.h10,

                  Text(
                    "Order Date: $date",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            Space.h20,

            /// 🔥 REASON
            const Text("Select Problem"),

            Space.h10,

            ...reasons.map((r) {
              return RadioListTile(
                value: r,
                groupValue: selectedReason,
                onChanged: (value) {
                  setState(() {
                    selectedReason = value.toString();
                  });
                },
                title: Text(r),
              );
            }).toList(),

            Space.h20,

            /// 🔥 DESCRIPTION
            const Text("Description"),

            Space.h10,

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Explain your problem...",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radius),
                  borderSide: BorderSide.none,
                ),
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
                        ? "✔ Proof Uploaded"
                        : "Upload Screenshot",
                  ),
                ),
              ),
            ),

            Space.h30,

            /// 🔥 SUBMIT
            PrimaryButton(
              text: "Submit Claim",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Success"),
                    content: const Text(
                        "Your warranty claim has been sent"),
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
            ),

            Space.h20,
          ],
        ),
      ),
    );
  }
}