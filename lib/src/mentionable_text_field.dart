import 'package:flutter/material.dart';
import 'package:mentionable_text_field/src/mention_text_editing_controller.dart';

class MentionableTextField extends StatefulWidget {
  const MentionableTextField(
      {Key? key, required this.usernameMentionRegexp, this.onTap})
      : super(key: key);

  final RegExp usernameMentionRegexp;
  final VoidCallback? onTap;

  @override
  State<MentionableTextField> createState() => _MentionableTextFieldState();
}

class _MentionableTextFieldState extends State<MentionableTextField> {
  late final MentionTextEditingController _controller =
      MentionTextEditingController(
    usernameMentionRegexp: widget.usernameMentionRegexp,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: widget.onTap,
      controller: _controller,
      style: widget.style,
      textAlign: widget.textAlign,
      onSubmitted: widget.onSubmitted,
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
    );
  }
}
