import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_ui_test/app.dart';

void main() {
  testWidgets('App shows chat list title', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('WhatsApp'), findsOneWidget);
  });
}
