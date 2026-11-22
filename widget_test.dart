import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusswap/main.dart';

void main() {
  testWidgets('CampusSwap opens login screen', (tester) async {
    await tester.pumpWidget(const CampusSwapApp());
    expect(find.text('CampusSwap'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('New here? Sign Up'), findsOneWidget);
  });

  testWidgets('Sign-up navigation reveals name field', (tester) async {
    await tester.pumpWidget(const CampusSwapApp());
    await tester.tap(find.text('New here? Sign Up'));
    await tester.pump();
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(4));
  });
}
