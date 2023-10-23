import 'package:build_zone/presentation/concernScreen/concernScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Concern Screen displaying without any issues',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: ConcernScreen(id: '652e92337e4c1dfed171f3fa'),
    ));

    // Verify that the PRScreen widget is rendered without any exceptions.
    expect(find.byType(ConcernScreen), findsOneWidget);

    
  });
}
