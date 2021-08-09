import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/core/utils/flavors.dart';

void main() {
  F.flavor = Flavor.dev;
  runApp(const App());
}
