import 'package:flutter/material.dart';

/// The different type of command bar
enum CommandBarActionType {
  /// A single action will call a callback when it is selected.
  single,

  /// Upon being selected a nested action will change the state of the command
  /// bar so that it only shows its children
  nested
}

/// Action that is presented in the command bar. These are the things the user
/// will be presented with to choose from
class CommandBarAction {
  /// The "primary" text of the action. This will be used by the searching
  /// algorithm to find this action.
  final String label;

  /// Optional description which'll be displayed under the [label], if the
  /// default builder is used.
  final String? description;

  /// Specifies what type of action this is
  final CommandBarActionType actionType;

  /// Required when [actionType] set to [CommandBarActionType.single]. This
  /// function is called when the action is selected
  VoidCallback? onSelect;

  /// Required when [actionType] set to [CommandBarActionType.nested]. These are
  /// the actions that will be displayed when this action is selected
  List<CommandBarAction>? childrenActions;

  /// For widgets that exist inside of a nested action, this points to their
  /// parent action
  CommandBarAction? _parent;

  /// Returns the parent of this action. Null indicates that it's a top-level
  /// action
  CommandBarAction? getParent() => _parent;

  CommandBarAction({
    required this.label,
    this.description,
    required this.actionType,
    this.onSelect,
    this.childrenActions,
  }) : assert((actionType == CommandBarActionType.single && onSelect != null) ||
            (actionType == CommandBarActionType.nested &&
                (childrenActions?.isNotEmpty ?? false))) {
    // give all our children "us" as a parent.
    if (actionType == CommandBarActionType.nested) {
      for (final child in childrenActions!) {
        child._parent = this;
      }
    }
  }
}
