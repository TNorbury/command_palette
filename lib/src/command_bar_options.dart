import 'package:flutter/material.dart';

import 'models/command_bar_action.dart';

class CommandBarOptions extends StatelessWidget {
  const CommandBarOptions({
    Key? key,
    required this.actions,
  }) : super(key: key);

  final List<CommandBarAction> actions;

  @override
  Widget build(BuildContext context) {
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
          return InkWell(
            onTap: () {
              if (item.actionType == CommandBarActionType.single) {
                item.onSelect!();
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.label +
                    (item.actionType == CommandBarActionType.nested
                        ? "..."
                        : ""),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
