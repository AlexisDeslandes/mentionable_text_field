import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:mocktail/mocktail.dart';

class FunctionMock<T> extends Mock {
  T call();
}

class ValueChangedMock<T> extends Mock {
  void call(T elt);
}

class MyMentionable extends Mentionable {
  const MyMentionable(this.label);

  @override
  final String label;

  @override
  String buildMention() => '<mention>$label</mention>';
}
