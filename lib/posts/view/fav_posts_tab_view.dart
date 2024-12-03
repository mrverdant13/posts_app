import 'package:app_ui/app_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/l10n/l10n.dart';

@RoutePage(
  name: 'FavPostsRoute',
)
class FavPostsTabView extends StatelessWidget {
  const FavPostsTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Text(
          l10n.comingSoonMessage,
          style: textTheme.headlineMedium,
        ),
      ),
    );
  }
}
