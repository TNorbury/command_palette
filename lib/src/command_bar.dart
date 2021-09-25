import 'package:command_bar/src/command_bar_modal.dart';
import 'package:command_bar/src/controller/command_bar_controller.dart';
import 'package:command_bar/src/models/command_bar_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Command bar is a widget that is summoned by a keyboard shortcut, or by
/// programmatic means.
///
/// The command bar displays a list of actions and the user can type text into
/// the search bar to filter those actions.
class CommandBar extends StatefulWidget {
  /// Child which is wrapped by the command bar
  final Widget child;

  /// Text that's displayed in the command bar when nothing has been entered
  final String hintText;

  /// List of all the actions that are supported by this command bar
  final List<CommandBarAction> actions;

  const CommandBar({
    required this.child,
    required this.actions,
    this.hintText = "Begin typing to search for something",
    Key? key,
  }) : super(key: key);

  @override
  State<CommandBar> createState() => _CommandBarState();
}

class _CommandBarState extends State<CommandBar> {
  bool _commandBarOpen = false;

  @override
  Widget build(BuildContext context) {
    final controller = CommandBarController(widget.actions);

    return CommandBarControllerProvider(
      controller: controller,
      child: Builder(
        builder: (context) {
          return Focus(
            autofocus: true,
            onKey: (node, event) {
              // debugPrint("here");
              KeyEventResult result = KeyEventResult.ignored;

              // if ctrl-c is pressed, and the command bar isn't open, open it
              if (LogicalKeySet(
                          LogicalKeyboardKey.control, LogicalKeyboardKey.keyK)
                      .accepts(event, RawKeyboard.instance) &&
                  !_commandBarOpen) {
                _openCommandBar(context);

                result = KeyEventResult.handled;
              }

              // if esc is pressed, and the command bar isn't open, close it
              else if (LogicalKeySet(LogicalKeyboardKey.escape)
                      .accepts(event, RawKeyboard.instance) &&
                  _commandBarOpen) {
                _closeCommandBar();
                result = KeyEventResult.handled;
              }

              return result;
            },
            child: widget.child,
          );
        },
      ),
    );
  }

  /// Closes the command bar
  void _closeCommandBar() {
    setState(() {
      _commandBarOpen = false;
    });
    Navigator.of(context).pop();
  }

  /// Opens the command bar
  void _openCommandBar(BuildContext context) {
    setState(() {
      _commandBarOpen = true;
    });

    Navigator.of(context)
        .push(
          CommandBarModal(
            hintText: widget.hintText,

            // we pass the controller in so that it can be re-provided within the
            // tree of the modal
            commandBarController: CommandBarControllerProvider.of(context),
          ),
        )
        .then(
          (value) => setState(() {
            _commandBarOpen = false;
          }),
        );
  }
}
