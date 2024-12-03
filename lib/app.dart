import 'package:flutter/material.dart';
import 'package:posts_app/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      home: Builder(
        builder: (context) {
          final l10n = context.l10n;
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appTitle),
            ),
            body: Center(
              child: Text(l10n.appTitle),
            ),
          );
        },
      ),
    );
  }
}
