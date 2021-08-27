import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines variants of entry animations
enum EntryAnimation {
  /// Appears in Center, standard Material dialog entrance animation, i.e.
  /// slow fade-in in the center of the screen.
  base,

  /// Enters screen horizontally from the left
  left,

  /// Enters screen horizontally from the right
  right,

  /// Enters screen horizontally from the top
  top,

  /// Enters screen horizontally from the bottom
  bottom,

  /// Enters screen from the top left corner
  topLeft,

  /// Enters screen from the top right corner
  topRight,

  /// Enters screen from the bottom left corner
  bottomLeft,

  /// Enters screen from the bottom right corner
  bottomRight,
}

class BaseGifDialog extends StatefulWidget {
  const BaseGifDialog({
    required this.title,
    required this.description,
    required this.imageWidget,
    required this.cornerRadius,
    required this.buttonRadius,
    required this.onlyOkButton,
    required this.buttonOkText,
    required this.buttonOkColor,
    required this.entryAnimation,
    required this.onlyCancelButton,
    required this.buttonCancelText,
    required this.onOkButtonPressed,
    required this.buttonCancelColor,
    required this.buttonNeutralText,
    required this.buttonNeutralColor,
    required this.onCancelButtonPressed,
    required this.onNeutralButtonPressed,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final bool onlyOkButton;
  final Widget imageWidget;
  final Widget description;
  final String buttonOkText;
  final Color buttonOkColor;
  final double buttonRadius;
  final double cornerRadius;
  final bool onlyCancelButton;
  final Color buttonCancelColor;
  final String buttonCancelText;
  final String buttonNeutralText;
  final Color buttonNeutralColor;
  final EntryAnimation entryAnimation;
  final VoidCallback onOkButtonPressed;
  final VoidCallback onCancelButtonPressed;
  final VoidCallback? onNeutralButtonPressed;

  @override
  _BaseGifDialogState createState() => _BaseGifDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('buttonOkText', buttonOkText))
      ..add(DoubleProperty('buttonRadius', buttonRadius))
      ..add(DoubleProperty('cornerRadius', cornerRadius))
      ..add(ColorProperty('buttonOkColor', buttonOkColor))
      ..add(StringProperty('buttonCancelText', buttonCancelText))
      ..add(ColorProperty('buttonCancelColor', buttonCancelColor))
      ..add(StringProperty('buttonNeutralText', buttonNeutralText))
      ..add(ColorProperty('buttonNeutralColor', buttonNeutralColor))
      ..add(DiagnosticsProperty<bool>('onlyOkButton', onlyOkButton))
      ..add(EnumProperty<EntryAnimation>('entryAnimation', entryAnimation))
      ..add(DiagnosticsProperty<bool>('onlyCancelButton', onlyCancelButton))
      ..add(ObjectFlagProperty<VoidCallback>.has(
        'onCancelButtonPressed',
        onCancelButtonPressed,
      ))
      ..add(ObjectFlagProperty<VoidCallback>.has(
        'onOkButtonPressed',
        onOkButtonPressed,
      ))
      ..add(ObjectFlagProperty<VoidCallback?>.has(
        'onNeutralButtonPressed',
        onNeutralButtonPressed,
      ));
  }
}

class _BaseGifDialogState extends State<BaseGifDialog>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  Animation<Offset>? _entryAnimation;

  Offset? _start(EntryAnimation entryAnimation) {
    switch (entryAnimation) {
      case EntryAnimation.top:
        return const Offset(0, -1);
      case EntryAnimation.topLeft:
        return const Offset(-1, -1);
      case EntryAnimation.topRight:
        return const Offset(1, -1);
      case EntryAnimation.left:
        return const Offset(-1, 0);
      case EntryAnimation.right:
        return const Offset(1, 0);
      case EntryAnimation.bottom:
        return const Offset(0, 1);
      case EntryAnimation.bottomLeft:
        return const Offset(-1, 1);
      case EntryAnimation.bottomRight:
        return const Offset(1, 1);
      case EntryAnimation.base:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_isDefaultEntryAnimation(widget.entryAnimation)) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _entryAnimation = Tween<Offset>(
        begin: _start(widget.entryAnimation),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Curves.easeIn,
        ),
      )..addListener(() => setState(() {}));
      _animationController?.forward();
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  bool _isDefaultEntryAnimation(EntryAnimation entryAnimation) =>
      entryAnimation == EntryAnimation.base;

  Widget _buildPortraitWidget(BuildContext context, Widget imageWidget) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.cornerRadius),
                topLeft: Radius.circular(widget.cornerRadius),
              ),
              child: imageWidget,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget.title,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: widget.description,
                  ),
                ),
                Offstage(
                  offstage: widget.buttonNeutralText.isEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widget.buttonNeutralColor,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                widget.buttonRadius,
                              ),
                            ),
                          ),
                        ),
                        onPressed: widget.onNeutralButtonPressed,
                        child: Text(
                          widget.buttonNeutralText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildButtonsBar(context)
              ],
            ),
          ),
        ],
      );

  Widget _buildLandscapeWidget(BuildContext context, Widget imageWidget) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.cornerRadius),
                bottomLeft: Radius.circular(widget.cornerRadius),
              ),
              child: imageWidget,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget.title,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: widget.description,
                ),
                Offstage(
                  offstage: widget.buttonNeutralText.isEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widget.buttonNeutralColor,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                widget.buttonRadius,
                              ),
                            ),
                          ),
                        ),
                        onPressed: widget.onNeutralButtonPressed,
                        child: Text(
                          widget.buttonNeutralText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildButtonsBar(context),
              ],
            ),
          ),
        ],
      );

  Widget _buildButtonsBar(BuildContext context) => Row(
        mainAxisAlignment: !widget.onlyOkButton
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.center,
        children: <Widget>[
          if (!widget.onlyOkButton) ...<TextButton>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  widget.buttonCancelColor,
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.buttonRadius),
                  ),
                ),
              ),
              onPressed: widget.onCancelButtonPressed,
              child: Text(
                widget.buttonCancelText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
          if (!widget.onlyCancelButton) ...<TextButton>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  widget.buttonOkColor,
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.buttonRadius),
                  ),
                ),
              ),
              onPressed: widget.onOkButtonPressed,
              child: Text(
                widget.buttonOkText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ]
            .map(
              (Widget e) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: e,
                ),
              ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        transform: !_isDefaultEntryAnimation(widget.entryAnimation)
            ? Matrix4.translationValues(
                _entryAnimation!.value.dx * width,
                _entryAnimation!.value.dy * width,
                0,
              )
            : null,
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * (isPortrait ? 0.8 : 0.6),
        child: Material(
          type: MaterialType.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.cornerRadius),
          ),
          elevation: Theme.of(context).dialogTheme.elevation ?? 24.0,
          child: isPortrait
              ? _buildPortraitWidget(context, widget.imageWidget)
              : _buildLandscapeWidget(context, widget.imageWidget),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<AnimationController?>(
        '_animationController',
        _animationController,
      ))
      ..add(DiagnosticsProperty<Animation<Offset>?>(
        '_entryAnimation',
        _entryAnimation,
      ));
  }
}
