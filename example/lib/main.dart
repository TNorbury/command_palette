import 'dart:math';

import 'package:command_palette/command_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeMode themeMode = ThemeMode.light;
  String _currentUser = "";
  Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      themeMode: themeMode,
      home: Builder(
        builder: (context) {
          return CommandPalette(
            config: CommandPaletteConfig(
              // define a custom query
              // filter: (query, allActions) {

              // },
              style: CommandPaletteStyle(
                actionLabelTextAlign: TextAlign.left,
                textFieldInputDecoration: InputDecoration(
                  hintText: "Enter Something",
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

              // Setting custom keyboard shortcuts
              // openKeySet: LogicalKeySet(
              //   LogicalKeyboardKey.alt,
              //   LogicalKeyboardKey.keyO,
              // ),
              // closeKeySet: LogicalKeySet(
              //   LogicalKeyboardKey.control,
              //   LogicalKeyboardKey.keyC,
              // ),
            ),
            actions: [
              CommandPaletteAction(
                label: "Close Command Palette",
                description: "Closes the command palette",
                actionType: CommandPaletteActionType.single,
                shortcut: ["esc"],
                onSelect: () {
                  Navigator.of(context).pop();
                },
              ),
              CommandPaletteAction(
                label: "Change Theme",
                actionType: CommandPaletteActionType.nested,
                description: "Change the color theme of the app",
                shortcut: ["ctrl", "t"],
                childrenActions: [
                  CommandPaletteAction(
                    label: "Light",
                    actionType: CommandPaletteActionType.single,
                    onSelect: () {
                      setState(() {
                        themeMode = ThemeMode.light;
                      });
                    },
                  ),
                  CommandPaletteAction(
                    label: "Dark",
                    actionType: CommandPaletteActionType.single,
                    onSelect: () {
                      setState(() {
                        themeMode = ThemeMode.dark;
                      });
                    },
                  ),
                ],
              ),
              CommandPaletteAction(
                label: "Set User",
                actionType: CommandPaletteActionType.nested,
                shortcut: ["ctrl", "shift", "s"],
                childrenActions: [
                  ...["Maria", "Kurt", "Susanne", "Larissa", "Simon", "Admin"]
                      .map(
                    (e) => CommandPaletteAction(
                      label: e,
                      actionType: CommandPaletteActionType.single,
                      onSelect: () => setState(() {
                        _currentUser = e;
                        color = Colors.transparent;
                      }),
                    ),
                  ),
                ],
              ),
              if (_currentUser == "Admin")
                CommandPaletteAction(
                  label: "Some sorta super secret admin action",
                  actionType: CommandPaletteActionType.single,
                  onSelect: () {
                    setState(() {
                      color = Color(Random().nextInt(0xFFFFFF)).withAlpha(255);
                    });
                  },
                ),
              if (_currentUser.isNotEmpty)
                CommandPaletteAction(
                  label: "Log out",
                  actionType: CommandPaletteActionType.single,
                  shortcut: ["l", "o"],
                  description: "Logs the current user out",
                  onSelect: () {
                    setState(() {
                      _currentUser = "";
                      color = Colors.transparent;
                    });
                  },
                ),
            ],
            child: Builder(
              builder: (context) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Welcome to the Command Palette example!"),
                        Text(
                          "Press ${defaultTargetPlatform == TargetPlatform.macOS ? 'Cmd' : 'Ctrl'}+K to open",
                        ),
                        TextButton(
                          child: Text("Or Click Here!"),
                          onPressed: () {
                            CommandPalette.of(context).open();
                          },
                        ),
                        if (_currentUser.isNotEmpty)
                          Text("Current User: $_currentUser"),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          width: 50,
                          height: 50,
                          color: color,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
