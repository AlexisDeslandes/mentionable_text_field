import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mentionable_text_field/src/string_extension.dart';

///
/// A [TextEditingController] that displays the mentions with a specific color using username.
/// True mention tags are stored in [_mentions] and will be used on [trueContent] call.
///
class MentionTextEditingController extends TextEditingController {
  ///
  MentionTextEditingController({
    required this.usernameMentionRegexp,
    this.mentionStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.escapingMentionCharacter = '∞',
  }) : _mentions = [];

  final String escapingMentionCharacter;
  final RegExp usernameMentionRegexp;
  final TextStyle mentionStyle;
  final List<String> _mentions;

  Queue<String> _mentionQueue() => Queue<String>.from(_mentions);

  void addMention(String candidate, String mention) {
    final indexSelection = selection.base.offset;
    final textPart = text.substring(0, indexSelection);
    final indexInsertion = textPart.countChar(escapingMentionCharacter);
    _mentions.insert(indexInsertion, mention);
    text = '${text.replaceAll(candidate, escapingMentionCharacter)} ';
    selection =
        TextSelection.collapsed(offset: indexSelection - candidate.length + 2);
  }

  /// Text with mention tag.
  /// To call to get the content we want to send to server eg.
  String get trueContent {
    final mentionQueue = _mentionQueue();
    return text.replaceAllMapped(
      escapingMentionCharacter,
      (_) => mentionQueue.removeFirst(),
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final escapeChar = escapingMentionCharacter;
    final res = text.split(RegExp('(?=$escapeChar)|(?<=$escapeChar)'));
    final mentionQueue = _mentionQueue();
    return TextSpan(
      style: style,
      children: res.map((e) {
        if (e == escapingMentionCharacter) {
          final mention = mentionQueue.removeFirst();
          final username = usernameMentionRegexp.stringMatch(mention)!;
          return WidgetSpan(
            child: Text(
              username,
              style: mentionStyle,
            ),
          );
        }
        return TextSpan(text: e, style: style);
      }).toList(),
    );
  }
}
