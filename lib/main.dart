import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/core/monetize/initialization.dart';
import 'app/core/utils/flavors.dart';

void main() {
  F.flavor = Flavor.dev;
  Initialization.start();
  runApp(const App());
}
