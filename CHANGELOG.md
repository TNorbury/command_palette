# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Fixed
- Remove ListView padding that was creating blank spaces on smaller screens

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