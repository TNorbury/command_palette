import 'package:flutter/material.dart';

/// The different type of command palette
enum CommandPaletteActionType {
  /// A single action will call a callback when it is selected.
  single,

  /// Upon being selected a nested action will change the state of the command
  /// palette so that it only shows its children
  nested
}

/// Action that is presented in the command palette. These are the things the 
/// user will be presented with to choose from
class CommandPaletteAction {
  /// The "primary" text of the action. This will be used by the searching
  /// algorithm to find this action.
  final String label;

  /// Optional description which'll be displayed under the [label], if the
  /// default builder is used.
  final String? description;

  /// Specifies what type of action this is
  final CommandPaletteActionType actionType;

  /// Required when [actionType] set to [CommandPaletteActionType.single]. This
  /// function is called when the action is selected
  VoidCallback? onSelect;

  /// Required when [actionType] set to [CommandPaletteActionType.nested]. These are
  /// the actions that will be displayed when this action is selected
  List<CommandPaletteAction>? childrenActions;

  /// For widgets that exist inside of a nested action, this points to their
  /// parent action
  CommandPaletteAction? _parent;

  /// Returns the parent of this action. Null indicates that it's a top-level
  /// action
  CommandPaletteAction? getParent() => _parent;

  /// List of strings representing the keyboard shortcut to invoke the action.
  ///
  /// Note that this doesn't set any handlers for shortcuts, but just adds a
  /// visual indicator.
  List<String>? shortcut;

  CommandPaletteAction({
    required this.label,
    this.description,
    required this.actionType,
    this.onSelect,
    this.childrenActions,
    this.shortcut,
  }) : assert((actionType == CommandPaletteActionType.single && onSelect != null) ||
              (actionType == CommandPaletteActionType.nested &&
                  (childrenActions?.isNotEmpty ?? false))) {
    // give all our children "us" as a parent.
    if (actionType == CommandPaletteActionType.nested) {
      for (final child in childrenActions!) {
        child._parent = this;
      }
    }
  }
}
