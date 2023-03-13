import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailAndPasswordSignInScreenController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailAndPasswordSignInScreenController(
      {required this.fakeAuthRepository,
      required EmailPasswordSignInFormType formType})
      : super(EmailPasswordSignInState(formType: formType));

  final FakeAuthRepository fakeAuthRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue<void>.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return value.hasError == false;
  }

  Future<void> _authenticate(String email, String password) async {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        fakeAuthRepository.signInWithEmailAndPassword(email, password);
        break;
      case EmailPasswordSignInFormType.register:
        fakeAuthRepository.createUserWithEmailAndPassword(email, password);
        break;
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(formType: formType);
  }
}

final emailPasswordSignControllerNotifierProvider =
    StateNotifierProvider.autoDispose.family<
        EmailAndPasswordSignInScreenController,
        EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final auth = ref.watch(fakeAuthRepositoryProvider);
  return EmailAndPasswordSignInScreenController(
    fakeAuthRepository: auth,
    formType: formType,
  );
});
