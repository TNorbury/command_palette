import 'package:command_bar/src/controller/command_bar_controller.dart';
import 'package:flutter/material.dart';

/// The Text Field portion of the command bar
class CommandBarTextField extends StatefulWidget {
  /// See [CommandBar.hintText]
  final String hintText;

  const CommandBarTextField({required this.hintText, Key? key})
      : super(key: key);

  @override
  _CommandBarTextFieldState createState() => _CommandBarTextFieldState();
}

class _CommandBarTextFieldState extends State<CommandBarTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    // we're a greedy focus node. Make sure we always have it (so long as the
    // command bar is up)
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: TextField(
        controller:
            CommandBarControllerProvider.of(context).textEditingController,
        focusNode: _focusNode,
        decoration: CommandBarControllerProvider.of(context)
            .style
            .textFieldInputDecoration,
      ),
    );
  }
}
