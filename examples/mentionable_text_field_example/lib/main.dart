import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:rxdart/subjects.dart';

void main() {
  runApp(const MyApp());
}

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

extension BouncyAnimation on Animation<double> {
  Animation<double> driveBouncy() => drive(TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 0.7),
        TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 0.3)
      ]));
}

/// App widget that shows mentionable_text_field example implementation.
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Mentionable text field Demo';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

/// Home page.
class MyHomePage extends StatefulWidget {
  /// default constructor.
  const MyHomePage({super.key, required this.title});

  /// Page title.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final BehaviorSubject<List<Mentionable>> _mentionableStreamController =
      BehaviorSubject.seeded([]);
  late final AnimationController _animationController =
      AnimationController(vsync: this);
  late void Function(Mentionable mentionable) _onSelectMention;

  @override
  void dispose() {
    _mentionableStreamController.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffC0E6EE), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(13),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: MentionableTextField(
                      onControllerReady: (value) =>
                          _onSelectMention = value.pickMentionable,
                      maxLines: 1,
                      onSubmitted: print,
                      mentionables: const [
                        MyUser('John Doe'),
                        MyUser('Jeanne Aulas'),
                        MyUser('Alexandre Dumas')
                      ],
                      onMentionablesChanged: (mentionables) {
                        final previousValue =
                            _mentionableStreamController.value;
                        _mentionableStreamController.add(mentionables);
                        if (!listEquals(previousValue, mentionables)) {
                          _animationController
                            ..duration = Duration(
                                milliseconds: 250 * mentionables.length)
                            ..reset()
                            ..forward();
                        }
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        hintText: 'Type @ to trigger mention',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: StreamBuilder<List<Mentionable>>(
                        stream: _mentionableStreamController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          final mentionables = snapshot.data!;
                          final length = mentionables.length;
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              final mentionable = mentionables[index];
                              return ScaleTransition(
                                scale: _animationController
                                    .drive(
                                      CurveTween(
                                          curve: Interval(
                                        index / length,
                                        (index + 1) / length,
                                        curve: Curves.easeIn,
                                      )),
                                    )
                                    .driveBouncy(),
                                child: Material(
                                  borderRadius: BorderRadius.circular(13),
                                  child: ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.person),
                                    title: Text(mentionable.mentionLabel),
                                    onTap: () => _onSelectMention(mentionable),
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                  ),
                                ),
                              );
                            },
                            itemCount: length,
                            separatorBuilder: (BuildContext context,
                                    int index) =>
                                const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 4)),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
