import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../../../core/languages/key_translations.dart';

class AnimatedButton extends StatelessWidget {
  const AnimatedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * .08,
        width: MediaQuery.of(context).size.width * .8,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                CupertinoIcons.play_fill,
                size: MediaQuery.of(context).size.width * .1,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(.5),
              ),
              Text(
                KeysTranslation.buttonPlay.tr,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .08,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSecondary.withOpacity(.5),
                ),
              ),
            ],
          ),
        ),
      );
}
