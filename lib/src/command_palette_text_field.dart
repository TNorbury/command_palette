import 'package:command_palette/src/controller/command_palette_controller.dart';
import 'package:flutter/material.dart';

/// The Text Field portion of the command palette
class CommandPaletteTextField extends StatefulWidget {
  /// See [CommandPalette.hintText]
  final String hintText;

  const CommandPaletteTextField({required this.hintText, Key? key})
      : super(key: key);

  @override
  _CommandPaletteTextFieldState createState() => _CommandPaletteTextFieldState();
}

class _CommandPaletteTextFieldState extends State<CommandPaletteTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    // we're a greedy focus node. Make sure we always have it (so long as the
    // command palette is up)
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
            CommandPaletteControllerProvider.of(context).textEditingController,
        focusNode: _focusNode,
        decoration: CommandPaletteControllerProvider.of(context)
            .style
            .textFieldInputDecoration,
      ),
    );
  }
}
