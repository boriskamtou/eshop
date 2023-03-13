import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required this.fakeAuthRepository})
      : super(const AsyncData(null));

  final FakeAuthRepository fakeAuthRepository;

  Future<void> signOut() async {
    // try {
    //   state = const AsyncValue.loading();
    //   await fakeAuthRepository.signOut();
    //   state = const AsyncValue.data(null);
    //   return true;
    // } catch (e, st) {
    //   state = AsyncValue.error(e, st);
    //   return false;
    // }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => fakeAuthRepository.signOut());
  }
}

final accountScreenNotifierProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final fakeAuthRepository = ref.watch(fakeAuthRepositoryProvider);
  return AccountScreenController(fakeAuthRepository: fakeAuthRepository);
});
