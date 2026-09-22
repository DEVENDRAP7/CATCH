import 'package:catch_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home shows the Catch wordmark and bottom nav', (tester) async {
    await tester.pumpWidget(const CatchApp());
    await tester.pumpAndSettle();

    expect(find.text('Catch'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
