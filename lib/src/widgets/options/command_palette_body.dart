import 'package:command_palette/command_palette.dart';
import 'package:command_palette/src/controller/command_palette_controller.dart';
import 'package:command_palette/src/widgets/command_palette_instructions.dart';
import 'package:command_palette/src/widgets/options/option_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

/// Displays all the available [CommandPaletteAction] options based upon various
/// filtering criteria.
/// Also displays [CommandPaletteInstructions] if that's enabled
class CommandPaletteBody extends StatelessWidget {
  const CommandPaletteBody({
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final CommandPaletteAction item = actions[index];

                var isHighlighted = controller.highlightedAction == index;

                //                 return ActionItemWrapper(
                //   child: controller.config.builder(
                //     context,
                //     controller.style,
                //     item,
                //     isHighlighted,
                //     () => controller.handleAction(context, action: item),
                //     controller.textEditingController.text.split(" "),
                //   ),
                // );

                return controller.config.builder(
                  context,
                  controller.style,
                  item,
                  isHighlighted,
                  () => controller.handleAction(context, action: item),
                  controller.textEditingController.text.split(" "),
                );
              },
            ),
          ),
          if (controller.config.showInstructions)
            const CommandPaletteInstructions(),
        ],
      ),
    );
  }
}

class ActionItemWrapper extends SingleChildRenderObjectWidget {
  const ActionItemWrapper({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ActionItemRenderObject();
  }
}

class ActionItemRenderObject extends RenderBox with RenderObjectWithChildMixin {
  ActionItemRenderObject();

  @override
  void performLayout() {
    child?.layout(constraints);
    super.performLayout();
  }

  @override
  bool get sizedByParent => true;
}

/// Default builder of Actions.
/// Uses all the parameters, so this is a good place to look if you're wanting
/// to create your our custom builder
// ignore: prefer_function_declarations_over_variables
final ActionBuilder kDefaultBuilder = (
  BuildContext context,
  CommandPaletteStyle style,
  CommandPaletteAction action,
  bool isHighlighted,
  VoidCallback onSelected,
  List<String> searchTerms,
) {
  Widget label;

  // if highlighting the search substring is enabled, then we'll use one of the
  // two widgets for that
  if (style.highlightSearchSubstring) {
    // if the action is a MatchedCommandPaletteAction, then we'll use our
    // own highlighter here.
    if (action is MatchedCommandPaletteAction && action.matches != null) {
      label = OptionHighlighter(
        action: action,
        textStyle: style.actionLabelTextStyle!,
        textAlign: style.actionLabelTextAlign,
        textStyleHighlight: style.highlightedLabelTextStyle!,
      );
    }
    // if it's just a generic action, then we'll use the 3rd party highlighter.
    // This likely means that the user made their own filtering solution.
    else {
      label = SubstringHighlight(
        text: action.label,
        textAlign: style.actionLabelTextAlign,
        terms: searchTerms,
        textStyle: style.actionLabelTextStyle!,
        textStyleHighlight: style.highlightedLabelTextStyle!,
      );
    }
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
        child: LayoutBuilder(
          builder: (context, c) {
            Widget? shortcuts;
            if (action.shortcut != null) {
              shortcuts = Wrap(
                alignment: WrapAlignment.end,
                children: action.shortcut!
                    .map<Widget>(
                      (e) => KeyboardKeyIcon(
                        iconString: e,
                      ),
                    )
                    .toList(),
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action.leading != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: action.leading!,
                  ),
                Flexible(
                  child: Column(
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
                ),
                if (shortcuts != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: shortcuts,
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
};
