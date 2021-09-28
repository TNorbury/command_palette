import 'package:command_bar/src/controller/command_bar_controller.dart';
import 'package:flutter/material.dart';

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
      elevation: 4,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final item = actions[index];
          return Material(
            color: controller.highlightedAction == index
                ? Theme.of(context).highlightColor // TODO: make part of args
                : Theme.of(context).canvasColor, // TODO: make part of args
            child: InkWell(
              onTap: () => controller.handleAction(context, action: item),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.label +
                      (item.actionType == CommandBarActionType.nested
                          ? "..."
                          : ""),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.subtitle1?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ), // TODO make part of args
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
