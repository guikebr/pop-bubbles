abstract class UseCase<T, Params> {
  Future<T> call({required Params params});

  void stop();
}

class NoParams {}
