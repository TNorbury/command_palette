# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- Optional `leading` widget for `CommandPaletteAction`s which will display a Widget at the left-side of the different command palette options
- exporting new widget 'KeyboardKeyIcon', this is the widget used to create the Keyboard Key Icons for the instructions bar and the shortcuts for each action

### Changed
- Flutter 3.3.1

## 0.5.0 - 2022-07-20
### Added
- Open to nested action via `CommandPalette.of(context).openToAction(actionId)`

### Changed
- When a nested action is selected, the label of that action will prefix the command palette text field. This can be enabled by setting `prefixNestedActions` to true (this is also the current default) in `CommandPaletteStyle`

### Fixed
- BREAKING: default open key is now platform dependent. Previously it was always Ctrl+K, but now it will check if the platform is MacOS (this includes Web running on Mac) and if so will change the default open key to Command. While this change does make things function as I originally intended, this is changing default behavior so I'm considering this a breaking change

## 0.4.1 - 2022-06-09
### Added
- allow the setting of size (height, width) and position (top, bottom, left, right) of the command palette modal via the CommandPaletteConfig class

## 0.4.0 - 2022-06-09
### Changed
- Support Flutter 3

## 0.3.1 - 2022-06-09
### Fixed
- specify supported platforms explicitly
- use kIsWeb to stop error from being thrown when platform is checked

## 0.3.0 - 2022-02-26
### Changed
- Change default alignment of action text to better support all screen sizes

### Fixed
- Remove ListView padding that was creating blank spaces on smaller screens
- On-screen virtual keyboards that don't have a proper enter button were unable to select an action. This should be fixed now

## 0.2.0 - 2022-02-03
### Changed
- Flutter 2.10.0
- BREAKING: The configuration for the command palette is now set by a CommandPaletteConfig object that is passed to the CommandPalette constructor. To migrate, wrap all the arguments in the CommandPalette constructor that aren't actions, child, or key, in a CommandPaletteConfig constructor and pass that to the config argument
- Now using a fuzzy search implementation. This should improve search results. This also includes an improved sub-string highlighter. Expect the behavior to be the same as VSCode's command palette, as the logic is an adaptation of what's used there.

## 0.1.1 - 2021-11-03
### Fixed
- command palette state is now reset upon closure of palette

## 0.1.0 - 2021-11-03
### Added
-   initial release