import 'package:rxdart/rxdart.dart';

/// An in-memory store backed by BehaviorSubject
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// The behaviorSubject that holds the data
  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to listen the data
  Stream<T> get stream => _subject.stream;

  /// Asynchronuos getter for current value
  T get value => _subject.value;

  /// A setter for updating the value
  set value(T value) => _subject.add(value);

  /// Close the connexion
  void close() => _subject.close();
}
