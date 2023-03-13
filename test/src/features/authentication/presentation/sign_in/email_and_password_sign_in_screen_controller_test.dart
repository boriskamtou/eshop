@Timeout(Duration(milliseconds: 500))

import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_and_password_sign_in_screen_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = "test@gmail.com";
  const testPassword = "1234";

  late MockFakeAuthRepository authRepository;

  setUp(
    () {
      authRepository = MockFakeAuthRepository();
    },
  );
  group('Submit', () {
    test(
      ''''
    Given the formType signIn
    When signInWithEmailAndPassword succeeds
    Then return true and state is AsyncData
    ''',
      () async {
        // Setup
        when(
          () => authRepository.signInWithEmailAndPassword(
            testEmail,
            testPassword,
          ),
        ).thenAnswer(
          (_) => Future.value(),
        );
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );
        // Expect later
        expectLater(
          controller.stream,
          emitsInOrder([
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncLoading<void>(),
            ),
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            ),
          ]),
        );
        // Run
        final result = await controller.submit(testEmail, testPassword);
        // Expect
        expect(result, true);
      },
    );

    test(
      ''''
    Given the formType signIn
    When signInWithEmailAndPassword fails
    Then return true and state is AsyncError
    ''',
      () async {
        // Setup
        final authRepository = MockFakeAuthRepository();
        final exception = Exception("Failed to log user");
        when(() => authRepository.signInWithEmailAndPassword(
            testEmail, testPassword)).thenThrow(exception);
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );
        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading<void>(),
              ),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              }),
            ],
          ),
        );
        // Run
        final result = await controller.submit(testEmail, testPassword);
        // Expect
        expect(result, false);
      },
    );

    test(
      ''''
    Given the formType register
    When createUserWithEmailAndPassword succeeds
    Then return true and state is AssycData
    ''',
      () async {
        // Setup
        final authRepository = MockFakeAuthRepository();
        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenAnswer((_) => Future.value());
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncData<void>(null),
              ),
            ],
          ),
        );
        // Run
        final result = await controller.submit(testEmail, testPassword);
        // Expect
        expect(result, true);
      },
    );

    test(
      ''''
    Given the formType register
    When createUserWithEmailAndPassword fails
    Then return true and state is AsyncError
    ''',
      () async {
        // Setup
        final authRepository = MockFakeAuthRepository();
        final exception = Exception("Failed to log user");
        when(() => authRepository.createUserWithEmailAndPassword(
            testEmail, testPassword)).thenThrow(exception);
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );
        expectLater(
          controller.stream,
          emitsInOrder(
            [
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading<void>(),
              ),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.register);
                expect(state.value.hasError, true);
                return true;
              }),
            ],
          ),
        );
        // Run
        final result = await controller.submit(testEmail, testPassword);
        // Expect
        expect(result, false);
      },
    );
  });

  group(
    'Update form',
    () {
      test('Update FormType Register', () {
        // Setup
        final authRepository = MockFakeAuthRepository();
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.register,
        );

        // Run
        controller.updateFormType(EmailPasswordSignInFormType.register);

        // Expect
        expect(
          controller.debugState,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.register,
            value: const AsyncData<void>(null),
          ),
        );
      });

      test('Update FormType SignIn', () {
        // Setup
        final authRepository = MockFakeAuthRepository();
        final controller = EmailAndPasswordSignInScreenController(
          fakeAuthRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn,
        );

        // Run
        controller.updateFormType(EmailPasswordSignInFormType.signIn);

        // Expect
        expect(
          controller.debugState,
          EmailPasswordSignInState(
            formType: EmailPasswordSignInFormType.signIn,
            value: const AsyncData<void>(null),
          ),
        );
      });
    },
  );
}
