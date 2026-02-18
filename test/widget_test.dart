import 'package:flutter_test/flutter_test.dart';
import 'package:punch_in/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PunchInApp());
    await tester.pumpAndSettle();

    // Verify the login screen renders
    expect(find.text('PunchIn'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
