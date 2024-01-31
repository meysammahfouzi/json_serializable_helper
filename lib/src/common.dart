import 'keywords.dart';
import 'plurals.dart';
import 'primitive_types.dart';

String convertClassNameToFileName(String className) {
  return toSnakeCase(convertFileNameToClassName(className));
}

String convertFileNameToClassName(String fileName) {
  String nameWithoutExtension = fileName.split('.').first;
  List<String> words = nameWithoutExtension.split('_');
  String className = words.map((word) => capitalize(word)).join();

  // Check if the generated class name is a Dart keyword
  if (dartKeywords.contains(className)) {
    className = '${className}Class';
  }

  return className;
}

String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

String capitalizeNonPrimitiveTypeName(String typeName) {
  if (primitiveTypes.contains(typeName)) {
    return typeName;
  }

  return capitalize(typeName);
}

String toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z\d])([A-Z])'),
        (Match match) => '${match[1]}_${match[2]?.toLowerCase()}',
      )
      .toLowerCase();
}

// convert to camelCase with first letter in lower case
String toCamelCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.split('_');

  if (words.first.isNotEmpty) {
    words.first = words.first[0].toLowerCase() + words.first.substring(1);
  }

  if (words.length > 1) {
    for (int i = 1; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = capitalize(words[i]);
      }
    }
  }

  return words.join();
}

String toSingular(String word) {
  // Check for irregular plurals using the map
  String? singularForm = irregularPlurals[word.toLowerCase()];
  if (singularForm != null) {
    return singularForm;
  }

  if (word.endsWith('ies')) {
    return '${word.substring(0, word.length - 3)}y';
  } else if (word.endsWith('xes')) {
    return word.substring(0, word.length - 2);
  } else if (word.endsWith('s')) {
    return word.substring(0, word.length - 1);
  }

  return word;
}
