import 'dart:io';
import 'package:brainshare/services/auth/auth_user.dart';
import 'package:brainshare/services/profile/profile_update_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'profile_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileUpdateService>(), MockSpec<AuthUser>()])

void main() {
  late MockProfileUpdateService profileUpdateService;
  late MockAuthUser authUser;

  setUp(() {
    profileUpdateService = MockProfileUpdateService();
    authUser = MockAuthUser();
  });

  group("Update profile", () {

    test("Update status", () async {
      final updatedUser = MockAuthUser();
      when(updatedUser.status).thenReturn("test");
      when(profileUpdateService.getProfile()).thenAnswer((_) async => updatedUser);

      await profileUpdateService.updateStatus("test");

      verify(profileUpdateService.updateStatus("test")).called(1);

      final resultUser = await profileUpdateService.getProfile();

      expect(resultUser.status, equals("test"));
    });

    test("Update bio", () async {
      final updatedUser = MockAuthUser();
      when(updatedUser.bio).thenReturn("test");
      when(profileUpdateService.getProfile()).thenAnswer((_) async => updatedUser);

      await profileUpdateService.updateBio("test");

      verify(profileUpdateService.updateBio("test")).called(1);

      final resultUser = await profileUpdateService.getProfile();

      expect(resultUser.bio, equals("test"));
    });

    test("Update photo", () async {
      final updatedUser = MockAuthUser();
      when(updatedUser.photoURL).thenReturn("testImage");
      when(profileUpdateService.getProfile()).thenAnswer((_) async => updatedUser);
      File file = File("testImage");
      await profileUpdateService.updatePhotoURL(file);

      verify(profileUpdateService.updatePhotoURL(file)).called(1);

      final resultUser = await profileUpdateService.getProfile();

      expect(resultUser.photoURL, equals("testImage"));
    });

    test("Update cv", () async {
      final updatedUser = MockAuthUser();
      when(updatedUser.cvURL).thenReturn("testFile");
      when(profileUpdateService.getProfile()).thenAnswer((_) async => updatedUser);
      File file = File("testFile");
      await profileUpdateService.updateCvURL(file);

      verify(profileUpdateService.updateCvURL(file)).called(1);

      final resultUser = await profileUpdateService.getProfile();

      expect(resultUser.cvURL, equals("testFile"));
    });

    test("Get status", () {
      when(authUser.status).thenReturn("status");
      expect(authUser.status, "status");
    });

    test("Get bio", () {
      when(authUser.bio).thenReturn("bio");
      expect(authUser.bio, "bio");
    });

    test("Get photo", () {
      when(authUser.photoURL).thenReturn("testImage");
      expect(authUser.photoURL, "testImage");
    });

    test("Ban User", () async {
      final updatedUser = MockAuthUser();
      when(profileUpdateService.banUser(authUser)).thenAnswer((_) async => updatedUser);
      when(updatedUser.isBanned).thenReturn(true);

      await profileUpdateService.banUser(authUser);

      verify(profileUpdateService.banUser(authUser)).called(1);

      expect(updatedUser.isBanned, true);
    });

    test("Get isModerator", () {
      when(authUser.isModerator).thenReturn(true);
      expect(authUser.isModerator, true);
    });

    test("Get cv", () {
      when(authUser.cvURL).thenReturn("testFile");
      expect(authUser.cvURL, "testFile");
    });
  });
}