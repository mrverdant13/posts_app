import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

@RoutePage(
  name: 'RootWrapperRoute',
)
class RootWrapper extends StatelessWidget {
  const RootWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
