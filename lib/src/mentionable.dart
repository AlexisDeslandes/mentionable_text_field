part of 'mentionable_text_field.dart';

/// A mentionable object.
@immutable
abstract class Mentionable {
  /// default constructor.
  const Mentionable();

  String get _mentionLabel => '@$label';

  /// Text that will be displayed to show specific mentionable.
  String get label;

  /// Way to render mention as a String in
  /// the TextField final result.
  String buildMention() => _mentionLabel;

  /// Return true when [search] match the mentionable.
  bool match(String search) =>
      label.toLowerCase().contains(search.toLowerCase());
}
