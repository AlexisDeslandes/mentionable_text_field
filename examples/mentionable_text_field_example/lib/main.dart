import 'package:flutter/material.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  List<Mentionable> _mentionableUsers = [];
  late void Function(Mentionable mentionable) _onSelectMention;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Column(
                children: [
                  MentionableTextField(
                    onControllerReady: (value) =>
                        _onSelectMention = value.pickMentionable,
                    maxLines: 1,
                    onSubmitted: print,
                    mentionables: const [
                      MyUser('John Doe'),
                      MyUser('Jeanne Aulas'),
                      MyUser('Alexandre Dumas')
                    ],
                    onMentionablesChanged: (mentionableUsers) =>
                        setState(() => _mentionableUsers = mentionableUsers),
                    decoration:
                        const InputDecoration(hintText: 'Type something ...'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final mentionable = _mentionableUsers[index];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(mentionable.mentionLabel),
                          onTap: () => _onSelectMention(mentionable),
                        );
                      },
                      itemCount: _mentionableUsers.length,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
