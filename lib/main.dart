import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/core/monetize/ad_stance.dart';
import 'app/core/utils/flavors.dart';

void main() {
  F.flavor = Flavor.prod;
  AdStance.initialization();
  runApp(const App());
}
