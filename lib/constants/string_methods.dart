String toPascalCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  final words = input.split(' ');
  final pascalCaseWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  });

  return pascalCaseWords.join(' ');
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String capitalizeFirstLetterOfEachWord(String text) {
  List<String> words = text.toLowerCase().split(' ');
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word.isNotEmpty) {
      words[i] = word[0].toUpperCase() + word.substring(1);
    }
  }
  return words.join(' ');
}

String convertToCamelCase(String input) {
  List<String> words = input.split(' ');

  String result = words[0].toLowerCase();

  for (int i = 1; i < words.length; i++) {
    String word = words[i];
    result += word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  return result;
}

String getOrdinal(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return '$number${'th'}';
  }
  switch (number % 10) {
    case 1:
      return '$number${'st'}';
    case 2:
      return '$number${'nd'}';
    case 3:
      return '$number${'rd'}';
    default:
      return '$number${'th'}';
  }
}
