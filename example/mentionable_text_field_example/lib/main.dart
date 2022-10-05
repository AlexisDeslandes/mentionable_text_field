import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:mentionable_text_field_example/mention_list_widget.dart';
import 'package:mentionable_text_field_example/my_user.dart';
import 'package:rxdart/subjects.dart';

void main() {
  runApp(const MyApp());
}

/// App widget that shows mentionable_text_field example implementation.
class MyApp extends StatelessWidget {
  ///
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Mentionable text field Demo';
    return const MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: title),
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
  late final _animationController = AnimationController(vsync: this);
  late MentionTextEditingController _textFieldController;
  final _resultStreamController = StreamController<String>();

  @override
  void dispose() {
    _mentionableStreamController.close();
    _animationController.dispose();
    _resultStreamController.close();
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(13),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: MentionableTextField(
                          onControllerReady: (value) =>
                              _textFieldController = value,
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
                                  milliseconds: 250 * mentionables.length,
                                )
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
                            return MentionListWidget(
                              mentionables: snapshot.data!,
                              pickMentionable:
                                  _textFieldController.pickMentionable,
                              animation: _animationController,
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        // height of bottom button
                        padding: const EdgeInsets.only(bottom: 48),
                        child: StreamBuilder<String>(
                          stream: _resultStreamController.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();
                            final data = snapshot.data!;
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: Text(
                                key: ValueKey(data),
                                data,
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () => _resultStreamController
                        .add(_textFieldController.buildMentionedValue()),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff53828c),
                      fixedSize: const Size.fromWidth(200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'SEND',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
