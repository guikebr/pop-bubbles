import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({required this.label, Key? key}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width * .06
              : MediaQuery.of(context).size.width * .03,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
  }
}
