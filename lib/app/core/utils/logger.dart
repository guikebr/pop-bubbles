abstract class Logger {
  static void write(String text, {bool isError = false}) =>
      Future<void>.microtask(() => '** $text. isError: [$isError]');
}
