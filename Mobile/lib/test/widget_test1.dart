import 'package:build_zone/presentation/prScreen/prScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PRScreen should build without any exceptions', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: PRScreen(),
    ));

    // Verify that the PRScreen widget is rendered without any exceptions.
    expect(find.byType(PRScreen), findsOneWidget);
  });


}