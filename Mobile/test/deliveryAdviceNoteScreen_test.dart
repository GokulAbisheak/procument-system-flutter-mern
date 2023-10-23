import 'package:build_zone/presentation/deliveryAdviceNoteScreen/deliveryAdviceNoteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Delivery Advice Note Screen displaying without any issues',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: DeliveryAdviceNoteScreen(id: '652e92337e4c1dfed171f3fa'),
    ));

    // Verify that the DeliveryAdviceNoteScreen widget is rendered without any exceptions.
    expect(find.byType(DeliveryAdviceNoteScreen), findsOneWidget);

    // Verify that the "DELIVERY ADVICE NOTE" text is displayed.
    expect(find.text('DELIVERY ADVICE NOTE'), findsOneWidget);
  });
}
