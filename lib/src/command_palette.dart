import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../command_palette.dart';
import 'command_palette_modal.dart';
import 'command_palette_options.dart';
import 'controller/command_palette_controller.dart';
import 'models/command_palette_action.dart';
import 'models/command_palette_style.dart';

/// Used to communicate the toggle status between the inherited widget and
/// stateful inner widget
class _CommandPaletteToggler extends ValueNotifier<bool> {
  _CommandPaletteToggler(bool value) : super(value);
}

/// Command palette is a widget that is summoned by a keyboard shortcut, or by
/// programmatic means.
///
/// The command palette displays a list of actions and the user can type text
/// into the search bar to filter those actions.
class CommandPalette extends InheritedWidget {
  /// Text that's displayed in the command palette when nothing has been entered
  final String hintText;

  /// List of all the actions that are supported by this command palette
  final List<CommandPaletteAction> actions;

  /// Used to filter which actions are displayed based upon the currently
  /// entered text of the search bar
  final ActionFilter filter;

  /// Used to build the actions which're displayed when the command palette is
  /// open
  ///
  /// For an idea on how to builder your own custom builder, see
  /// [defaultBuilder]
  final ActionBuilder builder;

  /// How long it takes for the command palette to be opened or closed.
  ///
  /// Defaults to 150 ms
  final Duration transitionDuration;

  /// Curves used when fading the command palette in and out.
  ///
  /// Defaults to [Curves.linear]
  final Curve transitionCurve;

  /// Provides options to style the look of the command palette.
  ///
  /// Note for development: Changes to style while the command palette is open
  /// will require the command palette to be closed and reopened.
  final CommandPaletteStyle? style;

  /// The set of keys used to open the command palette.
  ///
  /// Defaults to Ctrl-/Cmd- C
  final LogicalKeySet openKeySet;

  /// The set of keys used to close the command palette.
  ///
  /// Please note that at this time escape will always close the command
  /// palette.
  /// Regardless of if it's set or not. This is something defined at the
  /// App-level. If you want to prevent this, see: https://stackoverflow.com/questions/63763478/disable-escape-key-navigation-in-flutter-web
  ///
  /// Defaults to Esc.
  final LogicalKeySet closeKeySet;

  late final _CommandPaletteToggler _toggler;

  CommandPalette({
    ActionFilter? filter,
    Key? key,
    ActionBuilder? builder,
    required Widget child,
    this.hintText = "Begin typing to search for something",
    required this.actions,
    this.transitionDuration = const Duration(milliseconds: 150),
    this.transitionCurve = Curves.linear,
    this.style,
    LogicalKeySet? openKeySet,
    LogicalKeySet? closeKeySet,
  })  : filter = filter ?? defaultFilter,
        builder = builder ?? defaultBuilder,
        openKeySet = openKeySet ??
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK),
        closeKeySet = closeKeySet ?? LogicalKeySet(LogicalKeyboardKey.escape),
        super(
          key: key,
          child: _CommandPaletteInner(
            key: key,
            actions: actions,
            builder: builder,
            closeKeySet: closeKeySet,
            filter: filter,
            hintText: hintText,
            openKeySet: openKeySet,
            style: style,
            transitionCurve: transitionCurve,
            transitionDuration: transitionDuration,
            toggler: _CommandPaletteToggler(false),
            child: child,
          ),
        ) {
    _toggler = (super.child as _CommandPaletteInner).toggler;
  }

  static CommandPalette of(BuildContext context) {
    final CommandPalette? result =
        context.dependOnInheritedWidgetOfExactType<CommandPalette>();
    assert(result != null, "No CommandPalette in context");
    return result!;
  }

  /// Opens the command palette. Closing it can be achieved in the same way as
  /// closing other modal routes
  void open() {
    _toggler.value = true;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return !equals(oldWidget);
  }

  bool equals(Object other) {
    if (identical(this, other)) return true;

    return other is CommandPalette &&
        other.hintText == hintText &&
        listEquals(other.actions, actions) &&
        other.filter == filter &&
        other.builder == builder &&
        other.transitionDuration == transitionDuration &&
        other.transitionCurve == transitionCurve &&
        other.style == style &&
        other.openKeySet == openKeySet &&
        other.closeKeySet == closeKeySet;
  }
}

/// The actual widget which that handles the opening and closing of the palette.
class _CommandPaletteInner extends StatefulWidget {
  final Widget child;
  final String hintText;
  final List<CommandPaletteAction> actions;
  final ActionFilter filter;
  final ActionBuilder builder;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final CommandPaletteStyle? style;
  final LogicalKeySet openKeySet;
  final LogicalKeySet closeKeySet;

  final _CommandPaletteToggler toggler;

  _CommandPaletteInner({
    ActionFilter? filter,
    Key? key,
    ActionBuilder? builder,
    LogicalKeySet? openKeySet,
    LogicalKeySet? closeKeySet,
    required this.child,
    this.hintText = "Begin typing to search for something",
    required this.actions,
    this.transitionDuration = const Duration(milliseconds: 150),
    this.transitionCurve = Curves.linear,
    this.style,
    required this.toggler,
  })  : filter = filter ?? defaultFilter,
        builder = builder ?? defaultBuilder,
        openKeySet = openKeySet ??
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK),
        closeKeySet = closeKeySet ?? LogicalKeySet(LogicalKeyboardKey.escape),
        super(key: key);

  @override
  State<_CommandPaletteInner> createState() => _CommandPaletteInnerState();
}

class _CommandPaletteInnerState extends State<_CommandPaletteInner> {
  bool _commandPaletteOpen = false;

  late CommandPaletteController _controller;

  late CommandPaletteStyle _style;

  @override
  void initState() {
    super.initState();

    _controller = CommandPaletteController(
      widget.actions,
      filter: widget.filter,
      builder: widget.builder,
    );
  }

  @override
  void didUpdateWidget(covariant _CommandPaletteInner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.actions != widget.actions ||
        oldWidget.filter != widget.filter ||
        oldWidget.style != widget.style ||
        oldWidget.builder != widget.builder) {
      _controller = CommandPaletteController(
        widget.actions,
        filter: widget.filter,
        builder: widget.builder,
      );
      _initStyle();
    }

    // refresh toggler listeners if need be
    if (oldWidget.toggler != widget.toggler) {
      oldWidget.toggler.removeListener(_handleToggle);
      widget.toggler.addListener(_handleToggle);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.toggler.addListener(_handleToggle);

    _initStyle();
  }

  void _handleToggle() {
    // is open
    if (widget.toggler.value && !_commandPaletteOpen) {
      // widget.toggler.value
      _openCommandPalette(context);
    } else if (!widget.toggler.value && _commandPaletteOpen) {
      _closeCommandPalette();
    }
  }

  /// Initialize all the styles and stuff
  void _initStyle() {
    CommandPaletteStyle styleToCopy =
        widget.style ?? const CommandPaletteStyle();

    _style = CommandPaletteStyle(
      actionColor: styleToCopy.actionColor ?? Theme.of(context).canvasColor,
      selectedColor:
          styleToCopy.selectedColor ?? Theme.of(context).highlightColor,
      actionLabelTextStyle: styleToCopy.actionLabelTextStyle ??
          Theme.of(context).primaryTextTheme.subtitle1?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
      highlightedLabelTextStyle: styleToCopy.highlightedLabelTextStyle ??
          Theme.of(context).primaryTextTheme.subtitle1?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
      actionDescriptionTextStyle: styleToCopy.actionDescriptionTextStyle ??
          Theme.of(context).primaryTextTheme.subtitle2?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
      actionLabelTextAlign: styleToCopy.actionLabelTextAlign,
      borderRadius: styleToCopy.borderRadius,
      commandPaletteBarrierColor: styleToCopy.commandPaletteBarrierColor,
      elevation: styleToCopy.elevation,
      highlightSearchSubstring: styleToCopy.highlightSearchSubstring,
      textFieldInputDecoration: styleToCopy.textFieldInputDecoration == null
          ? const InputDecoration(
              hintText: "Begin typing to search for something",
              contentPadding: EdgeInsets.all(8),
            ).applyDefaults(Theme.of(context).inputDecorationTheme)
          : styleToCopy.textFieldInputDecoration!
              .applyDefaults(Theme.of(context).inputDecorationTheme),
    );

    _controller.style = _style;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommandPaletteControllerProvider(
      controller: _controller,
      child: Builder(
        builder: (context) {
          return Focus(
            autofocus: true,
            onKey: (node, event) {
              KeyEventResult result = KeyEventResult.ignored;

              // if ctrl-c is pressed, and the command palette isn't open,
              // open it
              if (widget.openKeySet.accepts(event, RawKeyboard.instance) &&
                  !_commandPaletteOpen) {
                _openCommandPalette(context);

                result = KeyEventResult.handled;
              }

              return result;
            },
            child: widget.child,
          );
        },
      ),
    );
  }

  /// Opens the command palette
  void _openCommandPalette(BuildContext context) {
    setState(() {
      _commandPaletteOpen = true;
      widget.toggler.value = true;
    });

    Navigator.of(context)
        .push(
          CommandPaletteModal(
            hintText: widget.hintText,

            // we pass the controller in so that it can be re-provided within the
            // tree of the modal
            commandPaletteController: _controller,
            transitionCurve: widget.transitionCurve,
            transitionDuration: widget.transitionDuration,
            closeKeySet: widget.closeKeySet,
          ),
        )
        .then(
          (value) => setState(() {
            _commandPaletteOpen = false;
            widget.toggler.value = false;
          }),
        );
  }

  /// Closes the command bar
  void _closeCommandPalette() {
    setState(() {
      _commandPaletteOpen = false;
      widget.toggler.value = false;
    });
    Navigator.of(context).pop();
  }
}
