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
          final item = actions[index];

          Widget label;

          // if highlighting the search substring is enabled, then we'll use the
          // widget for that
          if (controller.style.highlightSearchSubstring) {
            label = SubstringHighlight(
              text: item.label,
              textAlign: controller.style.actionLabelTextAlign,
              terms: controller.textEditingController.text.split(" "),
              textStyle: controller.style.actionLabelTextStyle!,
              textStyleHighlight: controller.style.highlightedLabelTextStyle!,
            );
          }
          // otherwise, just use a plain ol' text widget
          else {
            label = Text(
              item.label,
              textAlign: controller.style.actionLabelTextAlign,
              style: controller.style.actionLabelTextStyle!,
            );
          }

          return Material(
            color: controller.highlightedAction == index
                ? controller.style.selectedColor
                : controller.style.actionColor,
            child: InkWell(
              onTap: () => controller.handleAction(context, action: item),
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
          );
        },
      ),
    );
  }
}
