import 'package:flutter/material.dart';

SnackBar buildCustomSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  bool isWarning = false,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  final Color backgroundColor = isError
      ? colorScheme.errorContainer
      : (isWarning
            ? colorScheme.tertiaryContainer
            : colorScheme.primaryContainer);

  final Color borderColor = isError
      ? colorScheme.error
      : (isWarning ? colorScheme.tertiary : colorScheme.primary);

  final Color textColor = colorScheme.onSurface;

  return SnackBar(
    width: 350,
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: borderColor, width: 1),
    ),

    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
    elevation: 4,
    duration: const Duration(seconds: 3),

    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
    ),
  );
}
