# command_palette

[![pub package](https://img.shields.io/pub/v/command_palette.svg)](https://pub.dev/packages/command_palette)
[![flutter_tests](https://github.com/TNorbury/command_palette/workflows/flutter%20tests/badge.svg)](https://github.com/TNorbury/command_palette/actions?query=workflow%3A%22flutter+tests%22)
[![codecov](https://codecov.io/gh/TNorbury/command_palette/branch/master/graph/badge.svg)](https://codecov.io/gh/TNorbury/command_palette)
[![style: flutter lints](https://img.shields.io/badge/style-flutter_lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
A Flutter widget that allows you to bring up a command palette, seen in programs like Visual Studio Code and Slack.
Allows you to provide users with a convenient way to perform all sorts of actions related to your app.

![](https://raw.githubusercontent.com/TNorbury/command_palette/main/readme_assets/demo.gif)

## Features

-   Access the command palette via a keyboard shortcut, or programmatically.
-   Define a custom list of actions for the user and define the callbacks for each.
-   Use the default styling or build your own custom list items.
-   Use your own filtering logic
-   Use throughout your entire app, or just in certain sections!
-   Support for keyboardless apps too!

## Getting started

To install run the following command:

```
flutter pub install command_palette
```

or add `command_palette` to your pubspec.yaml

## Usage

Start by placing the Command Palette widget in your widget tree:

```dart
import 'package:command_palette/command_palette.dart';

//...
CommandPalette(
  actions: [
    CommandPaletteAction(
      label: "Goto Home Page",
      actionType: CommandPaletteActionType.single,
      onSelect: () {
        // go to home page, or perform some other sorta action
      }
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
  ],
  child: Text("Use a keyboard shortcut to open the palette up!"),
)
//...
```

### Opening Without a Keyboard

Want to allow devices that don't have a keyboard to open the palette, just use the handy InheritedWidget!

```dart
CommandPalette.of(context).open();
```

## Additional information

Have a feature request, or some questions? Come on down to the [discussions tab](https://github.com/TNorbury/command_palette/discussions).

Find a bug or want to open a pull request? Feel free to do so, any and all contributions are welcome and appreciated!

### Note about the version

While I feel confident that this package is ready to use in a real world app. I'm keeping the version below 1.0.0 for the time being incase there is any major changes I'd like to make before I settle down into something.
