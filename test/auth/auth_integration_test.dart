import 'package:brainshare/view/auth/recover_password_view.dart';
import 'package:brainshare/view/auth/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignUpView Integration Test', () {
    testWidgets('Display error dialog when terms are not agreed', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      final usernameField = find.widgetWithIcon(TextField, Icons.person);
      final emailField = find.widgetWithIcon(TextField, Icons.mail);
      final passwordField = find.widgetWithIcon(TextField, Icons.lock);
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');

      await tester.enterText(usernameField, 'testuser');
      await tester.enterText(emailField, 'testuser@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      await tester.tap(signUpButton);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('You must agree with the terms and conditions to continue!'), findsOneWidget);

    });
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUpView(),
    );
  }
}
