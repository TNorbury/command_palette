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
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
