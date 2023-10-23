import 'package:build_zone/presentation/prScreen/prScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PRScreen displays a list of purchase requisitions',
      (WidgetTester tester) async {
   
    await tester.pumpWidget(MaterialApp(
      home: PRScreen(),
    ));

    // Verify that the PRScreen widget displays a list of purchase requisitions.
    expect(find.text("Purchase Requisitions"),
        findsOneWidget); // Check for the title
    expect(find.text("Unknown Product"),
        findsNWidgets(2)); // Check for product name
    expect(find.text("Unknown"), findsNWidgets(2)); // Check for date
    expect(find.text("Pending"), findsNWidgets(2)); // Check for status
  });
}// TODO Implement this library.