import 'package:command_palette/src/controller/command_palette_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'command_palette_text_field.dart';
import 'options/command_palette_body.dart';

const Key kCommandPaletteModalKey = Key("Command Palette Modal");

/// Modal route which houses the command palette.
///
/// When the palette is opened this modal is what appears.
class CommandPaletteModal extends ModalRoute<void> {
  /// See [CommandPalette.hintText]
  final String hintText;

  /// controller for the command palette. Passed into the modal so that it can
  /// be distributed among this route
  final CommandPaletteController commandPaletteController;

  /// How long it takes for the modal to fade in or out
  final Duration _transitionDuration;

  final Curve _transitionCurve;

  final LogicalKeySet closeKeySet;

  @override
  void dispose() {
    // palette is closed now, tell the controller
    commandPaletteController.onClose();
    super.dispose();
  }

  /// [transitionDuration] How long it takes for the modal to fade in or out
  ///
  /// [transitionCurve] The curve used when fading the modal in and out
  CommandPaletteModal({
    required this.hintText,
    required this.commandPaletteController,
    required Duration transitionDuration,
    required Curve transitionCurve,
    required this.closeKeySet,
  })  : _transitionDuration = transitionDuration,
        _transitionCurve = transitionCurve;

  @override
  Color? get barrierColor =>
      commandPaletteController.style.commandPaletteBarrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel =>
      "Command Palette barrier. Clicking on the barrier will dismiss the command palette";

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CommandPaletteControllerProvider(
      key: kCommandPaletteModalKey,
      controller: commandPaletteController,
      child: FadeTransition(
        opacity: CurvedAnimation(
          curve: _transitionCurve,
          parent: animation,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // figure out size and positioning for the modal
            double height = commandPaletteController.config.height ??
                constraints.maxHeight * (6 / 8);
            double width = commandPaletteController.config.width ??
                constraints.maxWidth * (6 / 8);

            double top = commandPaletteController.config.top ??
                constraints.maxHeight * (1 / 8);
            double left = commandPaletteController.config.left ??
                constraints.maxWidth * (1 / 8);
            double? bottom = commandPaletteController.config.bottom;
            double? right = commandPaletteController.config.right;

            return Stack(
              children: [
                Positioned(
                  top: top,
                  bottom: bottom,
                  left: left,
                  right: right,
                  child: Focus(
                    // not sure why but this seems to make things play nice lol
                    onKeyEvent: (node, event) => KeyEventResult.ignored,
                    onKey: (node, event) {
                      KeyEventResult result = KeyEventResult.ignored;

                      if (LogicalKeySet(LogicalKeyboardKey.backspace)
                          .accepts(event, RawKeyboard.instance)) {
                        if (commandPaletteController.handleBackspace()) {
                          result = KeyEventResult.handled;
                        }
                      }

                      // down, move selector down
                      else if (LogicalKeySet(LogicalKeyboardKey.arrowDown)
                          .accepts(event, RawKeyboard.instance)) {
                        commandPaletteController.movedHighlightedAction(
                          down: true,
                        );
                        result = KeyEventResult.handled;
                      }

                      // up, move selector up
                      else if (LogicalKeySet(LogicalKeyboardKey.arrowUp)
                          .accepts(event, RawKeyboard.instance)) {
                        commandPaletteController.movedHighlightedAction(
                          down: false,
                        );
                        result = KeyEventResult.handled;
                      }

                      // enter makes selection
                      else if (LogicalKeySet(LogicalKeyboardKey.enter)
                          .accepts(event, RawKeyboard.instance)) {
                        commandPaletteController
                            .performHighlightedAction(context);
                        result = KeyEventResult.handled;
                      }

                      // close the command palette
                      else if (closeKeySet.accepts(
                        event,
                        RawKeyboard.instance,
                      )) {
                        Navigator.of(context).pop();
                        result = KeyEventResult.handled;
                      }

                      return result;
                    },
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        children: [
                          CommandPaletteTextField(
                            hintText: hintText,
                            onSubmit: () => commandPaletteController
                                .performHighlightedAction(context),
                          ),
                          const Flexible(
                            child: CommandPaletteBody(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
