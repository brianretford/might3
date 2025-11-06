import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:might3/main.dart';

void main() {
  testWidgets('App launches and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Top 3 Tasks'), findsOneWidget);
  });
  
  testWidgets('Add task button is present', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Look for the add button icon (CupertinoIcons)
    expect(find.byIcon(CupertinoIcons.add_circled_solid), findsAtLeastOneWidget);
  });
}
