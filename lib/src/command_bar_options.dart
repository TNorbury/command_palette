import 'package:command_bar/command_bar.dart';
import 'package:command_bar/src/controller/command_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'models/command_bar_action.dart';

/// Displays all the available [CommandBarAction] options based upon various
/// filtering criteria
class CommandBarOptions extends StatelessWidget {
  const CommandBarOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommandBarController controller = CommandBarControllerProvider.of(context);
    List<CommandBarAction> actions = controller.getFilteredActions();

    return Material(
      elevation: controller.style.elevation,
      borderRadius: controller.style.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final CommandBarAction item = actions[index];

          return controller.builder(
            context,
            controller.style,
            item,
            controller.highlightedAction == index,
            () => controller.handleAction(context, action: item),
            controller.textEditingController.text.split(" "),
          );
        },
      ),
    );
  }
}

/// Default builder of Actions.
/// Uses all the parameters, so this is a good place to look if you're wanting
/// to create your our custom builder
// ignore: prefer_function_declarations_over_variables
final ActionBuilder defaultBuilder = (
  BuildContext context,
  CommandBarStyle style,
  CommandBarAction action,
  bool isHighlighted,
  VoidCallback onSelected,
  List<String> searchTerms,
) {
  Widget label;

  // if highlighting the search substring is enabled, then we'll use the
  // widget for that
  if (style.highlightSearchSubstring) {
    label = SubstringHighlight(
      text: action.label,
      textAlign: style.actionLabelTextAlign,
      terms: searchTerms,
      textStyle: style.actionLabelTextStyle!,
      textStyleHighlight: style.highlightedLabelTextStyle!,
    );
  }
  // otherwise, just use a plain ol' text widget
  else {
    label = Text(
      action.label,
      textAlign: style.actionLabelTextAlign,
      style: style.actionLabelTextStyle!,
    );
  }

  return Material(
    color: isHighlighted ? style.selectedColor : style.actionColor,
    child: InkWell(
      onTap: () => onSelected,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: label),
            if (action.shortcut != null)
              Row(
                children: action.shortcut!
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black87),
                          ),
                          child: Text(e),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    ),
  );
};
