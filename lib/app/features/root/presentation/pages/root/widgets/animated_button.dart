import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../../core/languages/key_translations.dart';

class AnimatedButton extends StatelessWidget {
  const AnimatedButton({
    required this.widthButton,
    required this.heightButton,
    required this.sizeIcon,
    required this.sizeLabel,
    Key? key,
  }) : super(key: key);

  final double widthButton;
  final double heightButton;
  final double sizeIcon;
  final double sizeLabel;

  @override
  Widget build(BuildContext context) => Container(
        height: heightButton,
        width: widthButton,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 5),
              color: Theme.of(context).colorScheme.surface.withAlpha(50),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondaryVariant,
            ],
          ),
        ),
        child: Center(
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  CupertinoIcons.play_fill,
                  size: sizeIcon,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withOpacity(.5),
                ),
                Text(
                  KeysTranslation.buttonPlay.tr,
                  style: TextStyle(
                    fontSize: sizeLabel,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('height', heightButton))
      ..add(DoubleProperty('width', widthButton))
      ..add(DoubleProperty('sizeTitle', sizeIcon))
      ..add(DoubleProperty('sizeDescription', sizeLabel));
  }
}
