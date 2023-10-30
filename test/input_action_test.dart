import 'package:command_palette/command_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  const String expectedText = "This is a secret message!";
  testWidgets(
    "Input action passes result to callback",
    (WidgetTester tester) async {
      String enteredText = "";
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction.input(
              label: "Enter Text",
              onConfirmInput: (value) {
                enteredText = value;
              },
            ),
            CommandPaletteAction.single(
              label: "Some other action",
              onSelect: () {},
            ),
          ],
        ),
      );

      await openPalette(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text("Enter Text: "), findsOneWidget);
      expect(find.text("Some other action"), findsNothing);

      // enter text
      await tester.enterText(find.byType(TextField), expectedText);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(enteredText, expectedText);
    },
  );

  testWidgets(
    "Input text is reset after closing palette",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction.input(
              label: "Enter Text",
              onConfirmInput: (value) {},
            ),
          ],
        ),
      );

      await openPalette(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      // enter text
      await tester.enterText(find.byType(TextField), expectedText);

      await closePalette(tester);
      await openPalette(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text(expectedText), findsNothing);
    },
  );

  testWidgets(
    "Enter button label is changed when input action is selected",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MyApp(
          actions: [
            CommandPaletteAction.input(
              label: "Enter Text",
              onConfirmInput: (value) {},
            ),
          ],
        ),
      );

      await openPalette(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text("to confirm"), findsOneWidget);
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
        config: CommandPaletteConfig(
            showInstructions: true,
            builder: (context, style, action, isHighlighted, onSelected,
                searchTerms) {
              return Text(action.label);
            },
            style: const CommandPaletteStyle(
                highlightedLabelTextStyle: TextStyle(color: Colors.pink))),
        child: const Scaffold(
          body: Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
