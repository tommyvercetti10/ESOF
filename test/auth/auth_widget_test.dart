import 'package:brainshare/view/auth/recover_password_view.dart';
import 'package:brainshare/view/auth/sign_in_view.dart';
import 'package:brainshare/view/auth/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  testWidgets('Displays login view', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInView()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithIcon(TextField, Icons.mail), findsOneWidget);
    expect(find.widgetWithIcon(TextField, Icons.lock), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(1));
  });


  testWidgets('Displays signUp view', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.widgetWithIcon(TextField, Icons.mail), findsOneWidget);
    expect(find.widgetWithIcon(TextField, Icons.lock), findsOneWidget);
    expect(find.widgetWithIcon(TextField, Icons.person), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(1));
  });


  testWidgets('Displays recover password view', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RecoverPasswordView()));

    expect(find.byType(TextField), findsNWidgets(1));
    expect(find.byType(ElevatedButton), findsNWidgets(1));
  });



}


