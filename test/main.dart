import 'package:flutter_test/flutter_test.dart';
import 'package:insightme/Core/widgets/entryHint.dart';

void main() {
  testWidgets('entry shows text', (WidgetTester tester) async {
    await tester.pumpWidget(entryHint());
    expect(find.text('Create new entries '), findsOneWidget);
  });
}
