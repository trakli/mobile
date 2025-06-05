extension StringExtension on String {
  /// Capitalizes the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Trims the string and replaces multiple spaces with a single space
  String get normalizeSpaces {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String extractWords({int maxSize = 10}) {
    // Split the string into words.
    List<String> words = trim().split(RegExp(r'\s+'));

    if (words.isEmpty) return '';

    // Build result by adding words until we hit the maxSize limit
    String result = words[0];
    int currentIndex = 1;

    while (currentIndex < words.length) {
      String nextWord = ' ${words[currentIndex]}';
      if ((result + nextWord).length <= maxSize) {
        result += nextWord;
        currentIndex++;
      } else {
        break;
      }
    }

    return result;
  }
}
