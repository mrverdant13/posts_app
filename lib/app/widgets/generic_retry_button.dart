import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/l10n/l10n.dart';

class GenericRetryButton extends StatelessWidget {
  const GenericRetryButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final l10n = context.l10n;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.error,
      ),
      child: Text(l10n.genericRetryButtonLabel),
    );
  }
}
