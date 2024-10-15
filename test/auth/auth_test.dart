import 'package:brainshare/services/auth/auth_provider.dart' as auth;
import 'package:brainshare/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_test.mocks.dart';
import 'package:flutter/widgets.dart';

@GenerateNiceMocks([MockSpec<auth.AuthProvider>(), MockSpec<AuthService>(), MockSpec<User>()])

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockAuthService mockAuthService;
  late MockUser mockAuthUser;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockAuthUser = MockUser();
    mockAuthService = MockAuthService();
    when(mockAuthProvider.currentUser).thenReturn(mockAuthUser);
    when(mockAuthService.currentUser).thenReturn(mockAuthProvider.currentUser);
  });

  test('Test current user', () {
    final user = mockAuthProvider.currentUser;
    expect(user, mockAuthUser);
  });

  group("Create tests", () {
    test('Should create a user successfully', () async {
      when(mockAuthProvider.createUser(
        username: "username",
        email: "username@gmail.com",
        password: "username",
      )).thenAnswer((_) async => Future.value());

      await mockAuthProvider.createUser(
        username: "username",
        email: "username@gmail.com",
        password: "username",
      );

      verify(mockAuthProvider.createUser(
        username: "username",
        email: "username@gmail.com",
        password: "username",
      )).called(1);
    });

    test('Should throw an exception when there is an invalid field', () async {
      when(mockAuthProvider.createUser(
        username: "username",
        email: 'invalid-email',
        password: "username",
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
            () => mockAuthProvider.createUser(
          username: "username",
          email: 'invalid-email',
          password: "username",
        ),
        throwsA(isA<FirebaseAuthException>().having((e) => e.code, "invalid-email code", "invalid-email")),
      );
    });
  });


  group("Login tests", () {
    test('Should login successfully', () async {
      when(mockAuthProvider.logIn(
        email: "username@gmail.com",
        password: "username",
      )).thenAnswer((_) async => Future.value());

      await mockAuthProvider.logIn(
        email: "username@gmail.com",
        password: "username",
      );

      verify(mockAuthProvider.logIn(
        email: "username@gmail.com",
        password: "username",
      )).called(1);
    });

    test('Should throw an exception when credential are wrong', () async {
      when(mockAuthProvider.logIn(
        email: "username@gmail.com",
        password: "123",
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
              () => mockAuthProvider.logIn(
            email: "username@gmail.com",
            password: "123",
          ),
          throwsA(isA<FirebaseAuthException>().having((e) => e.code, "code", equals('wrong-password')))
      );
    });
  });
}

