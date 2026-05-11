import 'package:flutter/material.dart';

import '../widgets/snack_bar_widget.dart';

class AppNotify {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isWarning = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      buildCustomSnackBar(
        context,
        message,
        isError: isError,
        isWarning: isWarning,
      ),
    );
  }
}
