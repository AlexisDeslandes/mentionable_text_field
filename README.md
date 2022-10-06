# mentionable_text_field

A flutter plugin to create customizable text field that has a mentionable feature.

<p align="center">
  <a href="https://zupimages.net/viewer.php?id=22/40/1xum.gif"><img src="https://zupimages.net/up/22/40/1xum.gif" alt="" /></a>
</p>

## Installing:
In your pubspec.yaml
```yaml
dependencies:
  mentionable_text_field: ^0.0.2
```
```dart
import 'package:mentionable_text_field/mentionable_text_field.dart';
```

<br>
<br>

## Basic Usage:
```dart
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
                          title: Text(mentionable.label),
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

```

<br>
<br>

## Custom usage

In addition to basic textField's attributes,
There are other options:\

|  Properties  |   Description   |
|--------------|-----------------|
| `ValueChanged<MentionTextEditingController>? onControllerReady` | A callback to retrieve the `TextField` controller when ready|
| `List<Mentionable> mentionables` | List of possible `Mentionable` objects, eg: users.|
| `String escapingMentionCharacter` | The character used to replace mention. It should not be used by the user to avoid issues. It should be a single character.|
| `MentionablesChangedCallback onMentionablesChanged` | Callback that is called on each new characters typed in `TextField`. It gives the current candidates to mention feature.|
| `TextStyle mentionStyle` | Text Style applied to mentions|

## Additional information

Don't hesitate to suggest any features or fix that will improve the package!
