import 'package:command_palette/command_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  testWidgets(
    "Action Description is displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction(
              label: "Action 1",
              description: "This is action 1",
              actionType: CommandPaletteActionType.single,
              onSelect: () {},
            ),
          ],
        ),
      );

      await openPalette(tester);

      expect(find.text("This is action 1"), findsOneWidget);

      await closePalette(tester);
    },
  );

  testWidgets(
    "Shortcuts are displayed",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction(
              label: "Action 1",
              shortcut: ["ctrl", "a"],
              actionType: CommandPaletteActionType.single,
              onSelect: () {},
            ),
          ],
        ),
      );

      await openPalette(tester);
      expect(find.text("CTRL"), findsOneWidget);
      expect(find.text("A"), findsOneWidget);

      await closePalette(tester);
    },
  );
}

class MyApp extends StatelessWidget {
  final List<CommandPaletteAction> actions;

  const MyApp({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommandPalette(
        actions: actions,
        child: const Scaffold(
          body: Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
