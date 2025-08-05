import 'package:flutter_test/flutter_test.dart';
import 'package:notas_app/main.dart';

void main() {
  testWidgets('App should start without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NotasApp());

    // Verify that the app starts successfully
    expect(find.text('Notas App'), findsOneWidget);
  });
}
