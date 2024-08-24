import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  final BuildContext context;

  BaseProvider({required this.context});

  void showError(String errorMsg) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${errorMsg}'),
      )
    );
  }
}