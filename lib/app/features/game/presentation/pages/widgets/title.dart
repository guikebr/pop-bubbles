import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  const Title({required this.label, Key? key}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * .1
                : MediaQuery.of(context).size.width * .05,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
  }
}
