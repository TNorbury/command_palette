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
            ],
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text("Welcome to the Command Bar example!"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    // return CommandBar(
    //   actions: [
    //     CommandBarAction(
    //         label: "Close Command Bar",
    //         actionType: CommandBarActionType.single,
    //         onSelect: () {
    //           Navigator.of(context).pop();
    //         }),
    //     CommandBarAction(
    //       label: "Change Theme",
    //       actionType: CommandBarActionType.nested,
    //       childrenActions: [
    //         CommandBarAction(
    //           label: "Light",
    //           actionType: CommandBarActionType.single,
    //           onSelect: () {
    //             // TODO: make light
    //           },
    //         ),
    //         CommandBarAction(
    //           label: "Dark",
    //           actionType: CommandBarActionType.single,
    //           onSelect: () {
    //             // TODO: make dark
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    //   child: Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: const <Widget>[
    //           Text("Welcome to the Command Bar example!"),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
