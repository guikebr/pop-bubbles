enum Flavor {
  dev,
  prod,
}

class F {
  const F._();

  static Flavor? flavor;

  static String get name {
    switch (flavor) {
      case Flavor.prod:
        return 'POP BUBBLES';
      case Flavor.dev:
      default:
        return 'POP BUBBLES DEV';
    }
  }

  static String get nameStorage {
    switch (flavor) {
      case Flavor.prod:
        return 'PROD';
      case Flavor.dev:
      default:
        return 'DEV';
    }
  }
}
