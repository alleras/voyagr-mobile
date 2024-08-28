import 'package:flutter/material.dart';
import 'package:voyagr_mobile/util/globals.dart';

class BaseProvider extends ChangeNotifier {
  final BuildContext context;

  BaseProvider({required this.context});

  void showInformation(String msg) {
    Globals.globalKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(msg),
      )
    );
  }

  void showError(String errorMsg) {
    Globals.globalKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Error: $errorMsg'),
      )
    );
  }
}