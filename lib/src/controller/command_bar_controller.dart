import 'package:command_bar/command_bar.dart';
import 'package:command_bar/src/models/command_bar_action.dart';
import 'package:command_bar/src/models/command_bar_style.dart';
import 'package:flutter/material.dart';

class CommandBarControllerProvider
    extends InheritedNotifier<CommandBarController> {
  late final CommandBarController controller;

  // ignore: prefer_const_constructors_in_immutables
  CommandBarControllerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child, notifier: controller);

  static CommandBarController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CommandBarControllerProvider>()!
        .controller;
  }
}

/// Controller for the internals of the command bar
class CommandBarController extends ChangeNotifier {
  /// All the actions supported by this command bar.
  final List<CommandBarAction> actions;

  final ActionFilter filter;

  List<CommandBarAction> _filteredActionsCache = [];
  bool _actionsNeedRefiltered = true;

  /// Controller for the command search filed
  TextEditingController textEditingController = TextEditingController();

  /// The query entered into the command search field
  String _enteredQuery = "";

  /// Index of the highlighted action. This is the action which'll be invoked if
  /// the enter key is pressed
  int highlightedAction = 0;

  CommandBarStyle _style;

  /// updates the command bar style (if needed)
  set style(CommandBarStyle style) {
    if (_style != style) {
      _style = style;
      notifyListeners();
    }
  }

  /// gets the style of the command bar
  CommandBarStyle get style => _style;

  CommandBarController(this.actions, {required this.filter})
      : _style = const CommandBarStyle() {
    textEditingController.addListener(_onTextControllerChange);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  /// Listens to [textEditingController] and is called whenever it changes.
  void _onTextControllerChange() {
    if (_enteredQuery != textEditingController.text) {
      _enteredQuery = textEditingController.text;
      _actionsNeedRefiltered = true;
      notifyListeners();
    }
  }

  /// The currently selected action. Only nested actions can be selected
  CommandBarAction? get currentlySelectedAction => _currentlySelectedAction;
  set currentlySelectedAction(CommandBarAction? newAction) {
    assert(newAction == null ||
        newAction.actionType == CommandBarActionType.nested);
    _currentlySelectedAction = newAction;
    _actionsNeedRefiltered = true;
    textEditingController.clear();
    notifyListeners();
  }

  CommandBarAction? _currentlySelectedAction;

  /// Returns the list of actions filtered by the current search query, and if
  /// we're in a nested action
  List<CommandBarAction> getFilteredActions() {
    List<CommandBarAction> filteredActions = [];

    // something changed so we need to refilter
    if (_actionsNeedRefiltered) {
      // reset highlight position on re-filtering.
      highlightedAction = 0;

      if (currentlySelectedAction?.actionType == CommandBarActionType.nested) {
        filteredActions = currentlySelectedAction!.childrenActions!;
      } else {
        filteredActions = actions;
      }
      filteredActions = filter(_enteredQuery, filteredActions);
      _filteredActionsCache = filteredActions;
      _actionsNeedRefiltered = false;
    }

    // no refilter required
    else {
      filteredActions = _filteredActionsCache;
    }

    return filteredActions;
  }

  /// Handles backspace being pressed. The order of actions is as follows
  /// 1. If there is text in the controller, the backspace works as expected
  ///     there (i.e. deletes the character right behind the cursor)
  /// 2. If an action is currently selected, we'll pop one level
  bool handleBackspace() {
    bool handled = false;

    if (textEditingController.text.isNotEmpty) {
      handled = false;
    } else {
      handled = gotoParentAction();
    }
    return handled;
  }

  /// Goes a level up in the action tree, and sets the selected action as the
  /// parent of our currently selected one
  ///
  /// Returns true if popped
  bool gotoParentAction() {
    bool popped = false;
    // if the current action is null, we'll already at the top
    if (currentlySelectedAction != null) {
      currentlySelectedAction = currentlySelectedAction!.getParent();
      _actionsNeedRefiltered = true;
      notifyListeners();
      popped = true;
    }

    return popped;
  }

  /// Moves the action highlighter.
  void movedHighlightedAction({bool down = false}) {
    if (_filteredActionsCache.isEmpty) {
      return;
    }
    if (down) {
      highlightedAction =
          (highlightedAction + 1) % _filteredActionsCache.length;
    } else {
      highlightedAction =
          (highlightedAction - 1) % _filteredActionsCache.length;
    }
    notifyListeners();
  }

  /// Performs the required handling for the given action
  void handleAction(BuildContext context, {required CommandBarAction action}) {
    if (action.actionType == CommandBarActionType.single) {
      action.onSelect!();
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // currentlySelectedAction = null;
    }

    // nested items we set this item as the selected which in turn
    // will display its children.
    else if (action.actionType == CommandBarActionType.nested) {
      currentlySelectedAction = action;
    }
  }

  /// performs the action which is currently selected by [highlightedAction]
  void performHighlightedAction(BuildContext context) {
    handleAction(context, action: _filteredActionsCache[highlightedAction]);
  }
}
