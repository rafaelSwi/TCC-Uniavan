import 'package:flutter/material.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/models/compact/project.dart';
import 'package:MegaObra/crud/compact/project.dart';

class SimpleMegaObraDebugPage extends StatefulWidget {
  const SimpleMegaObraDebugPage({super.key});

  @override
  State<SimpleMegaObraDebugPage> createState() => _SimpleMegaObraDebugPageState();
}

class _SimpleMegaObraDebugPageState extends State<SimpleMegaObraDebugPage> {
  void collectAndPrintSomeStuff() async {
    if (!mounted) {
      return;
    }
    Future<ProjectCompactView?> compactViewFuture = getCompactProjectById(context, 284);

    // Await the future to get the ProjectCompactView or null
    ProjectCompactView? compactView = await compactViewFuture;

    // Check if the compactView is not null before accessing its properties
    if (compactView != null) {
      print("*** debug message: ${compactView.creator.cpf.toString()}");
    } else {
      print("No data found for the given ID.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        MegaObraButton(
          width: 380,
          height: 95,
          text: "clique meu camarada",
          padding: const EdgeInsets.all(30.0),
          function: collectAndPrintSomeStuff,
        )
      ],
    ));
  }
}
