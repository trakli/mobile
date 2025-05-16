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

    // Check the combined length of the first two words.
    String result;
    if (words.length >= 2 && ('${words[0]} ${words[1]}').length <= maxSize) {
      result = '${words[0]} ${words[1]}';
    } else {
      result = words[0];
    }

    // Trim the result to a maximum length of 10.
    return result.length > maxSize ? result.substring(0, maxSize) : result;
  }
}
