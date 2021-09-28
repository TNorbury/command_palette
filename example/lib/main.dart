import 'dart:math';

import 'package:command_bar/command_bar.dart';
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
          return CommandBar(
            actions: [
              CommandBarAction(
                label: "Close Command Bar",
                actionType: CommandBarActionType.single,
                onSelect: () {
                  Navigator.of(context).pop();
                },
              ),
              CommandBarAction(
                label: "Change Theme",
                actionType: CommandBarActionType.nested,
                childrenActions: [
                  CommandBarAction(
                    label: "Light",
                    actionType: CommandBarActionType.single,
                    onSelect: () {
                      setState(() {
                        themeMode = ThemeMode.light;
                      });
                    },
                  ),
                  CommandBarAction(
                    label: "Dark",
                    actionType: CommandBarActionType.single,
                    onSelect: () {
                      setState(() {
                        themeMode = ThemeMode.dark;
                      });
                    },
                  ),
                ],
              ),
              CommandBarAction(
                label: "Set User",
                actionType: CommandBarActionType.nested,
                childrenActions: [
                  ...["Maria", "Kurt", "Susanne", "Larissa", "Simon", "Admin"]
                      .map(
                    (e) => CommandBarAction(
                      label: e,
                      actionType: CommandBarActionType.single,
                      onSelect: () => setState(() {
                        _currentUser = e;
                        color = Colors.transparent;
                      }),
                    ),
                  ),
                ],
              ),
              if (_currentUser == "Admin")
                CommandBarAction(
                  label: "Some sorta super secret admin action",
                  actionType: CommandBarActionType.single,
                  onSelect: () {
                    setState(() {
                      color = Color(Random().nextInt(0xFFFFFF)).withAlpha(255);
                    });
                  },
                ),
              if (_currentUser.isNotEmpty)
                CommandBarAction(
                  label: "Log out",
                  actionType: CommandBarActionType.single,
                  onSelect: () {
                    setState(() {
                      _currentUser = "";
                      color = Colors.transparent;
                    });
                  },
                ),
            ],
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Welcome to the Command Bar example!"),
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
            ),
          );
        },
      ),
    );
  }
}
