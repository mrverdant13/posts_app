import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension ImagesTester on WidgetTester {
  Future<void> precacheImages() async {
    await pump();
    final contexts = elementList(find.byType(Image));
    for (final context in contexts) {
      final widget = context.widget as Image;
      await precacheImage(widget.image, context);
    }
  }

  Future<void> precacheImagesAndSettle() async {
    await precacheImages();
    await pumpAndSettle();
  }
}
