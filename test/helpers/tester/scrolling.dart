import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension ScrollingTester on WidgetTester {
  Future<void> jumpToBottom() async {
    final scrollable = state<ScrollableState>(find.byType(Scrollable));
    final position = scrollable.position;
    position.jumpTo(position.maxScrollExtent);
  }
}
