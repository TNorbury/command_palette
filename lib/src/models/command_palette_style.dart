import 'package:flutter/material.dart';

/// Used to style a [CommandPalette]
class CommandPaletteStyle {
  /// Color that's used as the background of the non-selected action item.
  ///
  /// Defaults to `Theme.of(context).canvasColor` when not set
  final Color? actionColor;

  /// Colors that's used as the background of the selected action item;
  ///
  /// Defaults to `Theme.of(context).highlightColor` when not set
  final Color? selectedColor;

  /// Text style for the label of an action
  ///
  /// Defaults to (if it's available):
  /// ```
  /// Theme.of(context).primaryTextTheme.subtitle1?.copyWith(
  ///   color: Theme.of(context).colorScheme.onSurface,
  ///  )
  /// ```
  final TextStyle? actionLabelTextStyle;

  /// Text style for the parts of the label which're highlighted because of
  /// searching
  ///
  /// Defaults to (if it's available):
  /// ```
  /// Theme.of(context)
  ///   .primaryTextTheme
  ///   .subtitle1
  ///   ?.copyWith(
  ///       color: Theme.of(context).colorScheme.secondary,
  ///       fontWeight: FontWeight.w600,
  ///   )
  /// ```
  final TextStyle? highlightedLabelTextStyle;

  /// Determines whether or not matching characters in action labels are
  /// highlighted while searching.
  ///
  /// Defaults to `true`
  final bool highlightSearchSubstring;

  /// Elevation of the command palette
  ///
  /// Defaults to `4.0`
  final double elevation;

  /// Border radius of the entire command palette. Includes the search bar and 
  /// the contents.
  ///
  /// Defaults to
  /// ```
  /// BorderRadius.only(
  ///   bottomLeft: Radius.circular(5),
  ///   bottomRight: Radius.circular(5),
  /// )
  /// ```
  final BorderRadiusGeometry borderRadius;

  /// The alignment of the text within the action labels
  ///
  /// Defaults to [TextAlign.center]
  final TextAlign actionLabelTextAlign;

  /// The color which is set behind the command palette when it's open
  ///
  /// Defaults to `Colors.black12`
  final Color commandPaletteBarrierColor;

  /// Decoration used for the text field
  /// 
  /// Defaults to 
  /// ```
  /// InputDecoration(
  ///   contentPadding: const EdgeInsets.all(8),
  /// ).applyDefaults(Theme.of(context).inputDecorationTheme)
  /// ```
  final InputDecoration? textFieldInputDecoration;

  const CommandPaletteStyle({
    this.actionColor,
    this.selectedColor,
    this.actionLabelTextStyle,
    this.highlightedLabelTextStyle,
    this.highlightSearchSubstring = true,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(5),
      bottomRight: Radius.circular(5),
    ),
    this.actionLabelTextAlign = TextAlign.center,
    this.commandPaletteBarrierColor = Colors.black12,
    this.textFieldInputDecoration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommandPaletteStyle &&
        other.actionColor == actionColor &&
        other.selectedColor == selectedColor &&
        other.actionLabelTextStyle == actionLabelTextStyle &&
        other.highlightedLabelTextStyle == highlightedLabelTextStyle &&
        other.highlightSearchSubstring == highlightSearchSubstring &&
        other.elevation == elevation &&
        other.borderRadius == borderRadius &&
        other.actionLabelTextAlign == actionLabelTextAlign &&
        other.commandPaletteBarrierColor == commandPaletteBarrierColor;
  }

  @override
  int get hashCode {
    return actionColor.hashCode ^
        selectedColor.hashCode ^
        actionLabelTextStyle.hashCode ^
        highlightedLabelTextStyle.hashCode ^
        highlightSearchSubstring.hashCode ^
        elevation.hashCode ^
        borderRadius.hashCode ^
        actionLabelTextAlign.hashCode ^
        commandPaletteBarrierColor.hashCode;
  }
}
