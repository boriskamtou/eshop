import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeAuthRepository {
  final bool hasDelay;

  final _authState = InMemoryStore<AppUser?>(null);

  FakeAuthRepository({this.hasDelay = true});

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(hasDelay);
    _createNewUser(email);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(hasDelay);
    _createNewUser(email);
  }

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();
}

final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final _auth = FakeAuthRepository();
  ref.onDispose(() => _auth.dispose());
  return _auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>(
  (ref) {
    final authRepository = ref.watch(fakeAuthRepositoryProvider);
    return authRepository.authStateChanges();
  },
);
