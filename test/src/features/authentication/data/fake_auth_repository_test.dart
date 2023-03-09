import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEmail = 'test@gmail.com';
  const testPassword = '1234';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );
  FakeAuthRepository makeFakeAuthRepository() =>
      FakeAuthRepository(hasDelay: false);
  group('FakeAuthRepository', () {
    test('Current user is null', () {
      final fakeAuthRepository = makeFakeAuthRepository();
      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    });

    test('Current user is not null after sign in', () async {
      final fakeAuthRepository = makeFakeAuthRepository();
      await fakeAuthRepository.signInWithEmailAndPassword(
          testEmail, testPassword);
      expect(fakeAuthRepository.currentUser, testUser);
      expect(fakeAuthRepository.authStateChanges(), emits(testUser));
    });

    test('Current user is not null after user register', () async {
      final fakeAuthRepository = makeFakeAuthRepository();
      await fakeAuthRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(fakeAuthRepository.currentUser, testUser);
      expect(fakeAuthRepository.authStateChanges(), emits(testUser));
    });

    test('Current user is null after sign out', () async {
      final fakeAuthRepository = makeFakeAuthRepository();
      await fakeAuthRepository.signInWithEmailAndPassword(
          testEmail, testPassword);

      await fakeAuthRepository.signOut();

      expect(fakeAuthRepository.currentUser, null);
      expect(fakeAuthRepository.authStateChanges(), emits(null));
    });

    test('Sign in after dispose throw an exception', () async {
      final fakeAuthRepository = makeFakeAuthRepository();
      fakeAuthRepository.dispose();
      expect(
          () => fakeAuthRepository.signInWithEmailAndPassword(
                testEmail,
                testPassword,
              ),
          throwsStateError);
    });
  });
}
