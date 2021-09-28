import 'package:command_bar/src/controller/command_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'command_bar_options.dart';
import 'command_bar_text_field.dart';

/// Modal route which houses the command bar.
///
/// When the bar is opened this modal is what appears.
class CommandBarModal extends ModalRoute<void> {
  /// See [CommandBar.hintText]
  final String hintText;

  /// controller for the command bar. Passed into the modal so that it can be
  /// distributed among this route
  final CommandBarController commandBarController;

  CommandBarModal({
    required this.hintText,
    required this.commandBarController,
  });

  @override
  Color? get barrierColor => Colors.black12;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel =>
      "Command Bar barrier. Clicking on the barrier will dismiss the command bar";

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CommandBarControllerProvider(
      controller: commandBarController,
      child: FadeTransition(
        opacity: CurvedAnimation(curve: Curves.linear, parent: animation),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Focus(
              // not sure why but this seems to make things play nice lol
              onKeyEvent: (node, event) => KeyEventResult.ignored,
              onKey: (node, event) {
                KeyEventResult result = KeyEventResult.ignored;

                if (LogicalKeySet(LogicalKeyboardKey.backspace)
                    .accepts(event, RawKeyboard.instance)) {
                  if (commandBarController.handleBackspace()) {
                    result = KeyEventResult.handled;
                  }
                }

                // down, move selector down
                else if (LogicalKeySet(LogicalKeyboardKey.arrowDown)
                    .accepts(event, RawKeyboard.instance)) {
                  commandBarController.movedHighlightedAction(down: true);
                  result = KeyEventResult.handled;
                }

                // up, move selector up
                else if (LogicalKeySet(LogicalKeyboardKey.arrowUp)
                    .accepts(event, RawKeyboard.instance)) {
                  commandBarController.movedHighlightedAction(down: false);
                  result = KeyEventResult.handled;
                }

                // enter makes selection
                else if (LogicalKeySet(LogicalKeyboardKey.enter)
                    .accepts(event, RawKeyboard.instance)) {
                  commandBarController.performHighlightedAction(context);
                  result = KeyEventResult.handled;
                }

                
                return result;
              },
              child: Container(
                height: constraints.maxHeight,
                padding: EdgeInsets.symmetric(
                  vertical: constraints.maxHeight * (1 / 8),
                  horizontal: constraints.maxWidth * (1 / 8),
                ),
                child: Column(
                  children: [
                    CommandBarTextField(hintText: hintText),
                    const Flexible(
                      child: CommandBarOptions(),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
