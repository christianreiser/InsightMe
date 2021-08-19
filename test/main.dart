import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insightme/Core/widgets/entryHint.dart';
import 'package:insightme/main.dart';

void main() {
  testWidgets('show entry hint', (WidgetTester tester) async {
    await tester.pumpWidget(entryHint());
    expect(find.text('Create new entries '), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('Initial home screen', (WidgetTester tester) async {
    await tester.pumpWidget(LifeTrackerApp());
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Optimize'), findsOneWidget);
    // await tester.pumpAndSettle();
    // await tester.runAsync(() async {
    //   // await Future.delayed(Duration(milliseconds: 100));
    //   expect(find.text('Create new entries '), findsOneWidget);
    // });
  });
}
