import 'package:command_palette/command_palette.dart';
import 'package:flutter/material.dart';
import 'package:woozy_search/woozy_search.dart';

class CommandPaletteControllerProvider
    extends InheritedNotifier<CommandPaletteController> {
  late final CommandPaletteController controller;

  // ignore: prefer_const_constructors_in_immutables
  CommandPaletteControllerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child, notifier: controller);

  static CommandPaletteController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CommandPaletteControllerProvider>()!
        .controller;
  }
}

/// Controller for the internals of the command palette
class CommandPaletteController extends ChangeNotifier {
  /// All the actions supported by this command palette.
  final List<CommandPaletteAction> actions;

  /// Filter used to determine the actions currently shown
  final ActionFilter filter;

  /// Builder for the action item
  final ActionBuilder builder;

  List<CommandPaletteAction> _filteredActionsCache = [];
  bool _actionsNeedRefiltered = true;

  /// Controller for the command search filed
  TextEditingController textEditingController = TextEditingController();

  /// The query entered into the command search field
  String _enteredQuery = "";

  /// Index of the highlighted action. This is the action which'll be invoked if
  /// the enter key is pressed
  int highlightedAction = 0;

  CommandPaletteStyle _style;

  /// To be called when the command palette is closed
  void onClose() {
    _currentlySelectedAction = null;
    highlightedAction = 0;
    _actionsNeedRefiltered = true;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      textEditingController.text = "";
    });
  }

  /// updates the command palette style (if needed)
  set style(CommandPaletteStyle style) {
    if (_style != style) {
      _style = style;
      notifyListeners();
    }
  }

  /// gets the style of the command palette
  CommandPaletteStyle get style => _style;

  CommandPaletteController(
    this.actions, {
    required this.filter,
    required this.builder,
  }) : _style = const CommandPaletteStyle() {
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
  CommandPaletteAction? get currentlySelectedAction => _currentlySelectedAction;
  set currentlySelectedAction(CommandPaletteAction? newAction) {
    assert(newAction == null ||
        newAction.actionType == CommandPaletteActionType.nested);
    _currentlySelectedAction = newAction;
    _actionsNeedRefiltered = true;
    textEditingController.clear();
    notifyListeners();
  }

  CommandPaletteAction? _currentlySelectedAction;

  /// Returns the list of actions filtered by the current search query, and if
  /// we're in a nested action
  List<CommandPaletteAction> getFilteredActions() {
    List<CommandPaletteAction> filteredActions = [];

    // something changed so we need to refilter
    if (_actionsNeedRefiltered) {
      // reset highlight position on re-filtering.
      highlightedAction = 0;

      if (currentlySelectedAction?.actionType ==
          CommandPaletteActionType.nested) {
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
  void handleAction(BuildContext context,
      {required CommandPaletteAction action}) {
    if (action.actionType == CommandPaletteActionType.single) {
      action.onSelect!();
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    // nested items we set this item as the selected which in turn
    // will display its children.
    else if (action.actionType == CommandPaletteActionType.nested) {
      currentlySelectedAction = action;
    }
  }

  /// performs the action which is currently selected by [highlightedAction]
  void performHighlightedAction(BuildContext context) {
    handleAction(context, action: _filteredActionsCache[highlightedAction]);
  }
}

/// Default filter for actions. Splits the entered query, and then wraps it in
/// groups and wild cards
// ignore: prefer_function_declarations_over_variables
final ActionFilter kDefaultFilter = (query, actions) {
  if (query.isEmpty) {
    return actions;
  }

  /// Using a fuzzy filter, match are actions based upon the entered query.
  final List<MatchedCommandPaletteAction> matchedActions = actions
      .map((e) {
        final result = Filter.matchesFuzzy(query, e.label);

        if (result != null) {
          return MatchedCommandPaletteAction(e, result);
        }

        return null;
      })
      .where((element) => element != null)
      .cast<MatchedCommandPaletteAction>()
      .toList();

  // score all the matched actions, so that they're sorted by score
  final woozy = Woozy<CommandPaletteAction>();
  for (final action in matchedActions) {
    woozy.addEntry(action.label, value: action);
  }

  final searchResults = woozy.search(query);
  // searchResults.forEach((element) {
  //   debugPrint("${element.text} ${element.score}");
  // });
  // debugPrint("-----");

  return searchResults.map((e) => e.value!).toList();
};
