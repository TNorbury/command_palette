import 'package:command_palette/command_palette.dart';
import 'package:command_palette/src/widgets/command_palette_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "Open and close the palette programmatically",
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

      await tester.tap(find.text("Open"));
      await tester.pumpAndSettle();

      expect(find.byKey(kCommandPaletteModalKey), findsOneWidget);

      closeCP();
      await tester.pumpAndSettle();
      expect(find.byKey(kCommandPaletteModalKey), findsNothing);
    },
  );
}

// don't do this in the real world, very bad, just wanting to test
// functionality...
BuildContext? hackyContext;
void closeCP() {
  CommandPalette.of(hackyContext!).close();
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
        child: Builder(
          builder: (context) {
            hackyContext = context;
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    CommandPalette.of(context).open();
                  },
                  child: const Text("Open"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
