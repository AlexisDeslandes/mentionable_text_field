import 'dart:collection';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mentionable_text_field/src/constants.dart';
import 'package:mentionable_text_field/src/list_extension.dart';
import 'package:mentionable_text_field/src/string_extension.dart';

part 'mention_text_editing_controller.dart';

part 'mentionable.dart';

/// The type of callback when mentionables candidate
/// have changed.
typedef MentionablesChangedCallback = void Function(
  List<Mentionable> mentionables,
);

/// A Widget built on top of [TextField] to add mentions feature.
/// To work, it required [mentionables] to let it know what can be mentioned.
/// When the user will start typing '@' character,
/// it will triggers mention mode.
///
/// It will call [onMentionablesChanged] each time a new character is added,
/// that will filter [mentionables] that match the query.
///
/// [onMentionablesChanged] let you decide
/// the way user will pick a [Mentionable].
///
/// To finally pick a [Mentionable],
/// keep the controller given by [onControllerReady] and
/// call [MentionTextEditingController.pickMentionable].
class MentionableTextField extends StatefulWidget {
  /// default constructor.
  const MentionableTextField({
    super.key,
    required this.onMentionablesChanged,
    this.onControllerReady,
    this.mentionStyle,
    this.expands = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.cursorWidth = 2.0,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.scrollPadding = const EdgeInsets.all(20),
    bool? enableInteractiveSelection,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.mentionables = const [],
    this.onTap,
    this.escapingMentionCharacter = Constants.escapingMentionCharacter,
    this.focusNode,
    this.decoration,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.maxLines,
    this.minLines,
    this.showCursor,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.selectionControls,
    this.mouseCursor,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.restorationId,
  })  : assert(
          escapingMentionCharacter.length == 1,
          'escapingMentionCharacter should be a single character.',
        ),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText);

  /// A callback to retrieve the [TextField] controller when
  /// it's ready.
  final ValueChanged<MentionTextEditingController>? onControllerReady;

  /// List of possible [Mentionable] objects, eg: users.
  final List<Mentionable> mentionables;

  /// The character used to replace mention.
  /// It should not be used by the user to avoid issues.
  /// It should be a single character.
  final String escapingMentionCharacter;

  /// Callback that is called on each new characters typed
  /// in [TextField]. It gives the current candidates to mention feature.
  final MentionablesChangedCallback onMentionablesChanged;

  /// [TextStyle] used to render mentions.
  final TextStyle? mentionStyle;

  /// Called when the [TextField] is tapped.
  final VoidCallback? onTap;

  /// The focus node used by the [TextField].
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.material.InputDecorator.textAlignVertical}
  final TextAlignVertical? textAlignVertical;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  final String obscuringCharacter;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool obscureText;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.services.TextInputConfiguration.smartDashesType}
  final SmartDashesType? smartDashesType;

  /// {@macro flutter.services.TextInputConfiguration.smartQuotesType}
  final SmartQuotesType? smartQuotesType;

  /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// Configuration of toolbar options.
  ///
  /// If not set, select all and paste will default to be enabled. Copy and cut
  /// will be disabled if [obscureText] is true. If [readOnly] is true,
  /// paste and cut will be disabled regardless.
  final ToolbarOptions? toolbarOptions;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// If set, a character counter will be displayed below the
  /// field showing how many characters have been entered. If set to a number
  /// greater than 0, it will also display the maximum number allowed. If set
  /// to [TextField.noMaxLength] then only the current character count is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The text field enforces the length with a [LengthLimitingTextInputFormatter],
  /// which is evaluated after the supplied [inputFormatters], if any.
  ///
  /// This value must be either null, [TextField.noMaxLength], or greater than 0.
  /// If null (the default) then there is no limit to the number of characters
  /// that can be entered. If set to [TextField.noMaxLength], then no limit will
  /// be enforced, but the number of characters entered will still be displayed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// If [maxLengthEnforcement] is [MaxLengthEnforcement.none], then more than
  /// [maxLength] characters may be entered, but the error counter and divider
  /// will switch to the [decoration]'s [InputDecoration.errorStyle] when the
  /// limit is exceeded.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [TextInputAction.next] and [TextInputAction.previous], which
  ///    automatically shift the focus to the next/previous focusable item when
  ///    the user is done editing.
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.onAppPrivateCommand}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [InputDecoration.enabled] property.
  final bool? enabled;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null it will default to the ambient
  /// [TextSelectionThemeData.cursorColor]. If that is null, and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  final Color? cursorColor;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.editableText.selectionEnabled}
  bool get selectionEnabled => enableInteractiveSelection;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.error].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// If this property is null, [MaterialStateMouseCursor.textable] will be used.
  ///
  /// The [mouseCursor] is the only property of [TextField] that controls the
  /// appearance of the mouse pointer. All other properties related to "cursor"
  /// stand for the text cursor, which is usually a blinking vertical line at
  /// the editing position.
  final MouseCursor? mouseCursor;

  /// Callback that generates a custom [InputDecoration.counter] widget.
  ///
  /// See [InputCounterWidgetBuilder] for an explanation of the passed in
  /// arguments.  The returned widget will be placed below the line in place of
  /// the default widget built when [InputDecoration.counterText] is specified.
  ///
  /// The returned widget will be wrapped in a [Semantics] widget for
  /// accessibility, but it also needs to be accessible itself. For example,
  /// if returning a Text widget, set the [Text.semanticsLabel] property.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget counter(
  ///   BuildContext context,
  ///   {
  ///     required int currentLength,
  ///     required int? maxLength,
  ///     required bool isFocused,
  ///   }
  /// ) {
  ///   return Text(
  ///     '$currentLength of $maxLength characters',
  ///     semanticsLabel: 'character count',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// If buildCounter returns null, then no counter and no Semantics widget will
  /// be created at all.
  final InputCounterWidgetBuilder? buildCounter;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter.widgets.editableText.autofillHints}
  /// {@macro flutter.services.AutofillConfiguration.autofillHints}
  final Iterable<String>? autofillHints;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@template flutter.material.textfield.restorationId}
  /// Restoration ID to save and restore the state of the text field.
  ///
  /// If non-null, the text field will persist and restore its current scroll
  /// offset and - if no [controller] has been provided - the content of the
  /// text field. If a [controller] has been provided, it is the responsibility
  /// of the owner of that controller to persist and restore it, e.g. by using
  /// a [RestorableTextEditingController].
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  /// {@endtemplate}
  final String? restorationId;

  /// {@macro flutter.widgets.editableText.scribbleEnabled}
  final bool scribbleEnabled;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  final bool enableIMEPersonalizedLearning;

  @override
  State<MentionableTextField> createState() => _MentionableTextFieldState();
}

class _MentionableTextFieldState extends State<MentionableTextField> {
  late final MentionTextEditingController _controller =
      MentionTextEditingController(
    escapingMentionCharacter: widget.escapingMentionCharacter,
    onMentionablesChanged: widget.onMentionablesChanged,
    mentionStyle: widget.mentionStyle,
  );

  @override
  void initState() {
    super.initState();
    widget.onControllerReady?.call(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final mentionables = widget.mentionables;
    _controller._onFieldChanged(value, mentionables);
    widget.onChanged?.call(value);
  }

  void _onSubmitted(_) {
    final mentionedValue = _controller.buildMentionedValue();
    widget.onSubmitted?.call(mentionedValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: widget.onTap,
      controller: _controller,
      style: widget.style,
      textAlign: widget.textAlign,
      onSubmitted: _onSubmitted,
      onChanged: _onChanged,
      restorationId: widget.restorationId,
      inputFormatters: widget.inputFormatters,
      mouseCursor: widget.mouseCursor,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
      clipBehavior: widget.clipBehavior,
      scrollController: widget.scrollController,
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      buildCounter: widget.buildCounter,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      dragStartBehavior: widget.dragStartBehavior,
      enabled: widget.enabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      enableSuggestions: widget.enableSuggestions,
      expands: widget.expands,
      focusNode: widget.focusNode,
      keyboardAppearance: widget.keyboardAppearance,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      minLines: widget.minLines,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      onEditingComplete: widget.onEditingComplete,
      readOnly: widget.readOnly,
      scribbleEnabled: widget.scribbleEnabled,
      scrollPadding: widget.scrollPadding,
      scrollPhysics: widget.scrollPhysics,
      selectionControls: widget.selectionControls,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      showCursor: widget.showCursor,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      strutStyle: widget.strutStyle,
      textAlignVertical: widget.textAlignVertical,
      textCapitalization: widget.textCapitalization,
      textDirection: widget.textDirection,
      textInputAction: widget.textInputAction,
      toolbarOptions: widget.toolbarOptions,
    );
  }
}
