import 'package:flutter/material.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:mentionable_text_field_example/bouncy_animation.dart';

/// Listview that contains the [mentionables].
/// On tap on one of [_MentionTile], trigger [pickMentionable].
class MentionListWidget extends StatelessWidget {
  /// default constructor.
  const MentionListWidget({
    super.key,
    required this.pickMentionable,
    required this.animation,
    this.mentionables = const [],
  });

  /// [Mentionable] that can be picked.
  final List<Mentionable> mentionables;

  /// Action that is triggered on pick.
  final ValueChanged<Mentionable> pickMentionable;

  /// Animation when list element are built.
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final length = mentionables.length;
    return ListView.separated(
      itemBuilder: (context, index) {
        final mentionable = mentionables[index];
        return ScaleTransition(
          scale: animation
              .drive(
                CurveTween(
                  curve: Interval(
                    index / length,
                    (index + 1) / length,
                    curve: Curves.easeIn,
                  ),
                ),
              )
              .driveBouncy(),
          child: _MentionTile(
            mentionable: mentionable,
            pickMentionable: pickMentionable,
          ),
        );
      },
      itemCount: length,
      separatorBuilder: (
        BuildContext context,
        int index,
      ) =>
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
    );
  }
}

class _MentionTile extends StatelessWidget {
  const _MentionTile({
    required this.mentionable,
    required this.pickMentionable,
  });

  final ValueChanged<Mentionable> pickMentionable;
  final Mentionable mentionable;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(13),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.person),
        title: Text(mentionable.mentionLabel),
        onTap: () => pickMentionable(mentionable),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}
