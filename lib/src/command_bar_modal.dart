import 'package:flutter/material.dart';

import 'command_bar_options.dart';
import 'command_bar_text_field.dart';
import 'models/command_bar_action.dart';

/// Modal route which houses the command bar.
///
/// When the bar is opened this modal is what appears.
class CommandBarModal extends ModalRoute<void> {
  /// See [CommandBar.hintText]
  final String hintText;

  /// See [CommandBar.actions]
  final List<CommandBarAction> actions;

  CommandBarModal({
    required this.hintText,
    required this.actions,
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
    return FadeTransition(
      opacity: CurvedAnimation(curve: Curves.linear, parent: animation),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            height: constraints.maxHeight,
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * (1 / 8),
              horizontal: constraints.maxWidth * (1 / 8),
            ),
            child: Column(
              children: [
                CommandBarTextField(
                  hintText: hintText,
                ),
                Flexible(
                  child: CommandBarOptions(
                    actions: actions,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
