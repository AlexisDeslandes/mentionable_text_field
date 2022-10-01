part of 'mentionable_text_field.dart';

/// A mentionable object.
@immutable
abstract class Mentionable {
  /// default constructor.
  const Mentionable();

  String get _fullMentionLabel => '@$mentionLabel';

  /// Text that will be input after @ character in
  /// [TextField] to show mention.
  String get mentionLabel;

  /// Way to render mention as a String in
  /// the TextField final result.
  String buildMention() => _fullMentionLabel;

  /// Return true when [search] match the mentionable.
  bool match(String search) =>
      _fullMentionLabel.toLowerCase().contains(search.toLowerCase());
}
