@Timeout(Duration(milliseconds: 500))

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFakeAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  late MockFakeAuthRepository fakeAuthRepository;
  late AccountScreenController accountController;
  setUp(
    () {
      fakeAuthRepository = MockFakeAuthRepository();
      accountController =
          AccountScreenController(fakeAuthRepository: fakeAuthRepository);
    },
  );
  group('Account Controller', () {
    test(
      'Intial state is null',
      () {
        expect(
          accountController.debugState,
          const AsyncData<void>(null),
        );
      },
    );

    test(
      'Test Sign Out Success',
      () async {
        when(fakeAuthRepository.signOut).thenAnswer((_) => Future.value());

        // expect later
        expectLater(
          accountController.stream,
          emitsInOrder(
            [
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ],
          ),
        );

        await accountController.signOut();

        expect(accountController.debugState, const AsyncData<void>(null));
        verify(accountController.signOut).called(1);
      },
    );

    test(
      'Test Sign Out Failed',
      () async {
        // Setup

        final exception = Exception('Sign out failed');

        when(fakeAuthRepository.signOut).thenThrow((_) => exception);

        // expect later
        expectLater(
          accountController.stream,
          emitsInOrder(
            [
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ],
          ),
        );

        // Run
        await accountController.signOut();

        // Except
        expect(accountController.debugState.hasError, true);
        verify(accountController.signOut).called(1);
      },
    );
  });
}
