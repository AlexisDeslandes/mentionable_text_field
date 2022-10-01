import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:mocktail/mocktail.dart';

import '../pump_app.dart';
import '../test_utils.dart';

void main() {
  group('MentionableTextField', () {
    const johnDoe = MyMentionable('John Doe');
    const mentionables = [johnDoe, MyMentionable('James Bond')];

    testWidgets(
        'Given 2 mentionables, if input is @, '
        'it should call onMentionablesChanged '
        'with these 2 mentionables.', (tester) async {
      final onMentionablesChanged = ValueChangedMock<List<Mentionable>>();
      await tester.pumpApp(
        Material(
          child: MentionableTextField(
            mentionables: mentionables,
            onMentionablesChanged: onMentionablesChanged,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(MentionableTextField), '@');
      verify(() => onMentionablesChanged(mentionables));
    });

    testWidgets(
        'Given 2 mentionables (John Doe & James Bond), if input is @joh, '
        'it should call onMentionablesChanged '
        'with only Mentionable(John Doe).', (tester) async {
      final onMentionablesChanged = ValueChangedMock<List<Mentionable>>();
      await tester.pumpApp(
        Material(
          child: MentionableTextField(
            mentionables: mentionables,
            onMentionablesChanged: onMentionablesChanged,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(MentionableTextField), '@joh');
      verify(() => onMentionablesChanged([johnDoe]));
    });

    testWidgets(
        'Given input value = "@joh", '
        'call controller.pickMentionable with John Doe, '
        'new input value should be "@John Doe".', (tester) async {
      final onMentionablesChanged = ValueChangedMock<List<Mentionable>>();
      MentionTextEditingController? controller;
      await tester.pumpApp(
        Material(
          child: MentionableTextField(
            mentionables: mentionables,
            onMentionablesChanged: onMentionablesChanged,
            onControllerReady: (value) => controller = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(MentionableTextField), '@joh');
      controller?.pickMentionable(johnDoe);
      await tester.pumpAndSettle();
      final fieldFinder = find.byType(MentionableTextField);
      final johnTextFinder = find.text('@John Doe');
      expect(
        find.descendant(of: fieldFinder, matching: johnTextFinder),
        findsOneWidget,
      );
    });

    testWidgets(
        'Given input value = "@John Doe", '
        'call submit should call onSubmitted with '
        '"<mention>John Doe</mention> "', (tester) async {
      final onMentionablesChanged = ValueChangedMock<List<Mentionable>>();
      final onSubmitted = ValueChangedMock<String>();
      await tester.pumpApp(
        Material(
          child: MentionableTextField(
            mentionables: mentionables,
            onMentionablesChanged: onMentionablesChanged,
            onSubmitted: onSubmitted,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(MentionableTextField), '@John Doe');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      verify(() => onSubmitted('<mention>John Doe</mention> '));
    });
  });
}
