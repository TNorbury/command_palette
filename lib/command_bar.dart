library command_bar;

import 'src/models/command_bar_action.dart';

export 'src/command_bar.dart';
export 'src/models/command_bar_action.dart';
export 'src/models/command_bar_style.dart';

/// Defines the type of function to be used for filtering command bar actions.
/// Given [query] and [allActions], the function should determine the subset of
/// actions to return based on the function
typedef ActionFilter = List<CommandBarAction> Function(
    String query, List<CommandBarAction> allActions);
