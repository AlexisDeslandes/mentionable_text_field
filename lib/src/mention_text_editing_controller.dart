part of 'mentionable_text_field.dart';

///
/// A [TextEditingController] that displays the mentions
/// with a specific style using [mentionStyle].
/// Mentions are stored in controller
/// as an unique character [escapingMentionCharacter].
/// Internally, [value] contains only [escapingMentionCharacter],
/// but the user will see mentions.
/// To get the real content of the text field
/// use [buildMentionedValue].
///
class MentionTextEditingController extends TextEditingController {
  /// default constructor.
  MentionTextEditingController({
    required MentionablesChangedCallback onMentionablesChanged,
    this.mentionStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.escapingMentionCharacter = Constants.escapingMentionCharacter,
  })  : _onMentionablesChanged = onMentionablesChanged,
        _storedMentionables = [];

  /// Character that is excluded from keyboard
  /// to replace the mentions (not visible to users).
  final String escapingMentionCharacter;

  /// [TextStyle] applied to mentionables in Text Field.
  final TextStyle mentionStyle;
  final List<Mentionable> _storedMentionables;
  final MentionablesChangedCallback _onMentionablesChanged;

  String? _getMentionCandidate(String value) {
    const mentionCharacter = Constants.mentionCharacter;
    final indexCursor = selection.base.offset;
    var indexAt =
        value.substring(0, indexCursor).reverse.indexOf(mentionCharacter);
    if (indexAt != -1) {
      if (value.length == 1) return mentionCharacter;
      indexAt = indexCursor - indexAt;
      if (indexAt != -1 && indexAt >= 0 && indexAt <= indexCursor) {
        return value.substring(indexAt - 1, indexCursor);
      }
    }
    return null;
  }

  Queue<Mentionable> _mentionQueue() =>
      Queue<Mentionable>.from(_storedMentionables);

  void _addMention(String candidate, Mentionable mentionable) {
    final indexSelection = selection.base.offset;
    final textPart = text.substring(0, indexSelection);
    final indexInsertion = textPart.countChar(escapingMentionCharacter);
    _storedMentionables.insert(indexInsertion, mentionable);
    text = '${text.replaceAll(candidate, escapingMentionCharacter)} ';
    selection =
        TextSelection.collapsed(offset: indexSelection - candidate.length + 2);
  }

  void _onFieldChanged(
    String value,
    List<Mentionable> mentionables,
  ) {
    final candidate = _getMentionCandidate(value);
    if (candidate != null) {
      final isMentioningRegexp = RegExp(r'^@[a-zA-Z ]*$');
      final mention = isMentioningRegexp.stringMatch(candidate)?.substring(1);
      if (mention != null) {
        final perfectMatch = mentionables.firstWhereOrNull(
          (element) => element.match(mention) && element.label == mention,
        );
        if (perfectMatch != null) {
          pickMentionable(perfectMatch);
        } else {
          final matchList =
              mentionables.where((element) => element.match(mention)).toList();
          _onMentionablesChanged(matchList);
        }
      }
    } else {
      _onMentionablesChanged([]);
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final escapeChar = escapingMentionCharacter;
    final res = text.split(RegExp('(?=$escapeChar)|(?<=$escapeChar)'));
    final mentionQueue = _mentionQueue();
    return TextSpan(
      style: style,
      children: res.map((e) {
        if (e == escapingMentionCharacter) {
          final mention = mentionQueue.removeFirst();
          return WidgetSpan(
            child: Text(
              mention._mentionLabel,
              style: mentionStyle,
            ),
          );
        }
        return TextSpan(text: e, style: style);
      }).toList(),
    );
  }

  /// Add the mention to this controller.
  /// [_onMentionablesChanged] is called with empty list,
  /// yet there are no candidates anymore.
  void pickMentionable(Mentionable mentionable) {
    final candidate = _getMentionCandidate(text);
    if (candidate != null) {
      _addMention(candidate, mentionable);
      _onMentionablesChanged([]);
    }
  }

  /// Get the real value of the field with the mentions transformed
  /// thanks to [Mentionable.buildMention].
  String buildMentionedValue() {
    final mentionQueue = _mentionQueue();
    return text.replaceAllMapped(
      escapingMentionCharacter,
      (_) => mentionQueue.removeFirst().buildMention(),
    );
  }
}
