library command_bar;

import 'package:flutter/material.dart';

import 'src/models/command_bar_action.dart';
import 'src/models/command_bar_style.dart';

export 'src/command_bar.dart';
export 'src/models/command_bar_action.dart';
export 'src/models/command_bar_style.dart';

/// Defines the type of function to be used for filtering command bar actions.
/// Given [query] and [allActions], the function should determine the subset of
/// actions to return based on the function
typedef ActionFilter = List<CommandBarAction> Function(
    String query, List<CommandBarAction> allActions);

/// Builder used for the action options.
/// Provides the following arguments:
/// * [style]: The style provided to the command bar
/// * [action]: The action we're building a widget for
/// * [isHighlighted]: Whether or not the action is the currently highlighted
///     one (selected by the cursor)
/// * [onSelected]: Callback that's to be called when the action is clicked on
/// * [searchTerms]: Terms used to search. Taken from the text entered into the
///     text field, splitting on space.
typedef ActionBuilder = Widget Function(
  BuildContext context,
  CommandBarStyle style,
  CommandBarAction action,
  bool isHighlighted,
  VoidCallback onSelected,
  List<String> searchTerms,
);
