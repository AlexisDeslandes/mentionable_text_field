import 'package:mentionable_text_field/mentionable_text_field.dart';

/// Example implementation of [Mentionable].
class MyUser extends Mentionable {
  /// default constructor.
  const MyUser(this.mentionLabel);

  /// Label of user.
  @override
  final String mentionLabel;

  @override
  String buildMention() => '<my-custom-tag>$mentionLabel</my-custom-tag>';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUser &&
          runtimeType == other.runtimeType &&
          mentionLabel == other.mentionLabel;

  @override
  int get hashCode => mentionLabel.hashCode;
}
