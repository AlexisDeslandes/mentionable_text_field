import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:mocktail/mocktail.dart';

class FunctionMock<T> extends Mock {
  T call();
}

class ValueChangedMock<T> extends Mock {
  void call(T elt);
}

class MyMentionable extends Mentionable {
  const MyMentionable(this.mentionLabel);

  @override
  final String mentionLabel;

  @override
  String buildMention() => '<mention>$mentionLabel</mention>';
}
