extension StringExtension on String {
  /// Count the number of characters in this string.
  int countChar(String char) => char.allMatches(this).length;
}