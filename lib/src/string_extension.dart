/// Extension on [String] class.
extension StringExtension on String {
  /// Count the number of characters in this string.
  int countChar(String char) => char.allMatches(this).length;

  /// Reverse the string:
  /// 'azer' => 'reza'
  String get reversed => split('').reversed.join();
}
