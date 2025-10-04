import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) contentBuilder;
  final VoidCallback? onConfirm;

  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.contentBuilder,
    required this.onConfirm,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            contentBuilder(context),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              if (onConfirm != null)
                ElevatedButton(
                  onPressed: () {
                    onConfirm!();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Confirm"),
                )
            ]),
          ],
        ),
      ),
    );
  }
}
