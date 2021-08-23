abstract class UseCase<T, Params> {
  Future<T> call({required Params params});

  void pause();

  void resume();

  void dispose();
}

class NoParams {}
