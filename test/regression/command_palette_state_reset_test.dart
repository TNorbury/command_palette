import 'package:command_palette/command_palette.dart';
import 'package:command_palette/src/command_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';

void main() {
  testWidgets(
    "Highlighted item is reset",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          builder:
              (context, style, action, isHighlighted, onSelected, searchTerms) {
            return Text("${action.label}-$isHighlighted");
          },
          actions: [
            CommandPaletteAction(
              label: "1",
              actionType: CommandPaletteActionType.nested,
              childrenActions: [
                CommandPaletteAction(
                  label: "Nested Action 1",
                  actionType: CommandPaletteActionType.single,
                  onSelect: () {},
                ),
              ],
            ),
            CommandPaletteAction(
              label: "2",
              actionType: CommandPaletteActionType.single,
              onSelect: () {},
            ),
          ],
        ),
      );

      await openPalette(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();

      expect(find.text("1-false"), findsOneWidget);
      expect(find.text("2-true"), findsOneWidget);

      await closePalette(tester);
      await openPalette(tester);

      expect(find.text("1-true"), findsOneWidget);
      expect(find.text("2-false"), findsOneWidget);
      await closePalette(tester);
    },
  );

  testWidgets(
    "Entered text is reset",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction(
              label: "Action 1",
              actionType: CommandPaletteActionType.single,
              onSelect: () {},
            ),
          ],
        ),
      );
      await openPalette(tester);
      await tester.pumpAndSettle();

      // enter text
      await tester.enterText(find.byType(TextField), "A");
      await tester.pumpAndSettle();

      await closePalette(tester);
      await openPalette(tester);
      expect(find.widgetWithText(TextField, ""), findsOneWidget);
      await closePalette(tester);
    },
  );

  testWidgets(
    "Selected action is reset",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction(
              label: "Action 1",
              actionType: CommandPaletteActionType.nested,
              childrenActions: [
                CommandPaletteAction(
                  label: "Nested Action 1",
                  actionType: CommandPaletteActionType.single,
                  onSelect: () {},
                ),
              ],
            ),
          ],
        ),
      );

      await openPalette(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      await closePalette(tester);
      await openPalette(tester);
      expect(find.text("Nested Action 1"), findsNothing);
      expect(find.text("Action 1"), findsOneWidget);
      await closePalette(tester);
    },
  );
}

class MyApp extends StatelessWidget {
  final List<CommandPaletteAction> actions;
  final ActionBuilder? builder;
  final LogicalKeySet? openKeySet;
  final LogicalKeySet? closeKeySet;

  const MyApp({
    Key? key,
    required this.actions,
    this.builder,
    this.openKeySet,
    this.closeKeySet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommandPalette(
        actions: actions,
        builder: builder,
        openKeySet: openKeySet,
        closeKeySet: closeKeySet,
        style: const CommandPaletteStyle(
          // have to turn highlighting off in order to find by text
          highlightSearchSubstring: false,
        ),
        child: const Scaffold(
          body: Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
