import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.decoration,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.style,
    this.readOnly = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.validator,
    this.enabled = true,
    this.labelText,
    this.hintText,
  });

  final bool autofocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  // TextCapitalization textCapitalization = TextCapitalization.none,
  final TextInputAction? textInputAction;
  final TextStyle? style;
  // StrutStyle? strutStyle,
  // TextDirection? textDirection,
  // TextAlign textAlign = TextAlign.start,
  // TextAlignVertical? textAlignVertical,
  final bool readOnly;
  // ToolbarOptions? toolbarOptions,
  // bool? showCursor,
  // String obscuringCharacter = '•',
  final bool obscureText;
  // bool autocorrect = true,
  // SmartDashesType? smartDashesType,
  // SmartQuotesType? smartQuotesType,
  // bool enableSuggestions = true,
  // MaxLengthEnforcement? maxLengthEnforcement,
  // int? maxLines = 1,
  // int? minLines,
  // bool expands = false,
  // int? maxLength,
  // void Function(String)? onChanged,
  // void Function()? onTap,
  // void Function(PointerDownEvent)? onTapOutside,
  final void Function()? onEditingComplete;
  // void Function(String)? onFieldSubmitted,
  // void Function(String?)? onSaved,
  final String? Function(String?)? validator;
  // List<TextInputFormatter>? inputFormatters,
  final bool? enabled;
  // double cursorWidth = 2.0,
  // double? cursorHeight,
  // Radius? cursorRadius,
  // Color? cursorColor,
  // Brightness? keyboardAppearance,
  // EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
  // bool? enableInteractiveSelection,
  // TextSelectionControls? selectionControls,
  // Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter,
  // ScrollPhysics? scrollPhysics,
  // Iterable<String>? autofillHints,
  // AutovalidateMode? autovalidateMode,
  // ScrollController? scrollController,
  // String? restorationId,
  // bool enableIMEPersonalizedLearning = true,
  // MouseCursor? mouseCursor,
  // Widget Function(BuildContext, EditableTextState)? contextMenuBuilder = _defaultContextMenuBuilder,
  // SpellCheckConfiguration? spellCheckConfiguration,
  // TextMagnifierConfiguration? magnifierConfiguration,
  // UndoHistoryController? undoController,
  // void Function(String, Map<String, dynamic>)? onAppPrivateCommand,
  // bool? cursorOpacityAnimates,
  // BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
  // BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
  // DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  // ContentInsertionConfiguration? contentInsertionConfiguration,
  // Clip clipBehavior = Clip.hardEdge,
  // bool scribbleEnabled = true,
  // bool canRequestFocus = true,
  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          hintText: hintText,
          labelText: labelText,
          hintStyle: style,
          labelStyle: style
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: theme.textTheme.titleLarge ?? style,
        readOnly: readOnly,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        validator: validator,
        enabled: enabled,
      ),
    );
  }
}
