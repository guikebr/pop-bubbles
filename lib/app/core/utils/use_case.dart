abstract class UseCase<T, Params> {
  Future<T> call({required Params params});

  Future<void> dispose();
}

class NoParams {}
