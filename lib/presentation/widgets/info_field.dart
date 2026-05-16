import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final bool isValid;
  final bool isWarning;
  final bool isEnable;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    required this.isValid,
    this.isWarning = false,
    this.isEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color backgroundColor = switch (this) {
      _ when !isEnable => colorScheme.surfaceContainerHighest,
      _ when isValid => colorScheme.primaryContainer,
      _ when isWarning => colorScheme.tertiaryContainer,
      _ => colorScheme.errorContainer,
    };

    final Color borderColor = switch (this) {
      _ when !isEnable => colorScheme.surfaceDim,
      _ when isValid => colorScheme.primary,
      _ when isWarning => colorScheme.tertiary,
      _ => colorScheme.error,
    };

    final Color textColor = colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
