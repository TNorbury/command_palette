import 'package:command_bar/src/models/command_bar_action.dart';
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
  final List<CommandBarAction> _actions;

  List<CommandBarAction> _filteredActionsCache = [];
  bool _actionsNeedRefiltered = true;

  /// Controller for the command search filed
  TextEditingController textEditingController = TextEditingController();

  /// The query entered into the command search field
  String _enteredQuery = "";

  CommandBarController(this._actions) {
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
      if (currentlySelectedAction?.actionType == CommandBarActionType.nested) {
        filteredActions = currentlySelectedAction!.childrenActions!;
      } else {
        filteredActions = _actions;
      }

      // TODO: make better filtering logic
      // no only get options that contain the search query
      filteredActions = filteredActions
          .where(
            (element) => element.label
                .toLowerCase()
                .contains(_enteredQuery.toLowerCase()),
          )
          .toList();

      _actionsNeedRefiltered = false;
      _filteredActionsCache = filteredActions;
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
}
