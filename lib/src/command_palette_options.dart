import 'package:command_palette/command_palette.dart';
import 'package:command_palette/src/controller/command_palette_controller.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'models/command_palette_action.dart';

/// Displays all the available [CommandPaletteAction] options based upon various
/// filtering criteria
class CommandPaletteOptions extends StatelessWidget {
  const CommandPaletteOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommandPaletteController controller =
        CommandPaletteControllerProvider.of(context);
    List<CommandPaletteAction> actions = controller.getFilteredActions();

    return Material(
      elevation: controller.style.elevation,
      borderRadius: controller.style.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final CommandPaletteAction item = actions[index];

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
  CommandPaletteStyle style,
  CommandPaletteAction action,
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
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, c) {
          Widget? shortcuts;
          if (action.shortcut != null) {
            shortcuts = Wrap(
                alignment: WrapAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: action.shortcut!
                    .map<Widget>(
                      (e) => Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black87),
                              ),
                              child: Text(
                                e.toUpperCase(),
                                style: style.actionDescriptionTextStyle,
                              ),
                            ),
                            // const Text("+")
                          ],
                        ),
                      ),
                    )
                    .toList());
          }
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: label),
                    ],
                  ),
                  if (action.description != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            action.description!,
                            textAlign: style.actionLabelTextAlign,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (shortcuts != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: shortcuts,
                ),
            ],
          );
        }),
      ),
    ),
  );
};
