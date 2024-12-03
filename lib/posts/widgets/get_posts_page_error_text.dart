import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:posts_api/posts_api.dart';
import 'package:posts_app/l10n/l10n.dart';

class GetPostsPageErrorText extends StatelessWidget {
  const GetPostsPageErrorText({
    required this.error,
    super.key,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    return Text(
      switch (error) {
        final GetPostsPageFailure failure => switch (failure) {
            GetPostsPageFailureUnexpected() =>
              l10n.genericUnexpectedFailureMessage,
          },
        _ => l10n.genericUnexpectedErrorMessage,
      },
      textAlign: TextAlign.center,
      style: textTheme.bodyLarge?.copyWith(
        color: colorScheme.error,
      ),
    );
  }
}
