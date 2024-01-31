import 'dart:convert';
import 'package:dart_style/dart_style.dart';

import 'common.dart';
import 'keywords.dart';

Map<String, String> generateDartClasses(String className, String jsonString,
    [bool generateSingleFile = false]) {
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  Map<String, String> generatedFiles = {};

  generateClass(generatedFiles, className, jsonMap);

  // only keep the first file and append the content of the rest of the files to it
  // don't change the content of the first file.
  // in the other files, remove the imports and the part statement from the beginning of the file before appending them to the first file.
  if (generateSingleFile) {
    String firstFileName = generatedFiles.keys.first;
    String mergedFileContent = generatedFiles.values.first;
    mergedFileContent = removeImportDartStatements(mergedFileContent);
    generatedFiles.remove(generatedFiles.keys.first);
    generatedFiles.forEach((key, value) {
      String fileContent = value;
      fileContent = fileContent.replaceFirst(
          "import 'package:json_annotation/json_annotation.dart';", '');
      fileContent = fileContent.replaceFirst(
          "part '${key.replaceAll('.dart', '.g.dart')}';", '');
      fileContent = removeImportDartStatements(fileContent);
      mergedFileContent += fileContent;
    });
    generatedFiles.clear();
    generatedFiles[firstFileName] = DartFormatter().format(mergedFileContent);
  }

  return generatedFiles;
}

String removeImportDartStatements(String fileContent) {
  // Remove all import dart statements except 'package:json_annotation/json_annotation.dart'
  var importDartStatements = RegExp(
      r"import '(?!package:json_annotation/json_annotation\.dart')[^']*';");
  fileContent = fileContent.replaceAll(importDartStatements, '');
  return fileContent;
}

void generateClass(Map<String, String> generatedFiles, String className,
    Map<String, dynamic> jsonMap) {
  StringBuffer buffer = StringBuffer();

  // Generate the imports and class header
  buffer.writeln("import 'package:json_annotation/json_annotation.dart';");

  // add import for all of the nested classes
  jsonMap.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      var fileName = convertClassNameToFileName(key);
      buffer.writeln("import '$fileName.dart';");
    } else if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      String singularKey = toSingular(key);
      var fileName = convertClassNameToFileName(singularKey);
      buffer.writeln("import '$fileName.dart';");
    }
  });

  className = convertFileNameToClassName(
      className); // to convert keyword class names, e.g. Type => TypeClass
  var fileName = convertClassNameToFileName(className);

  buffer.writeln();
  buffer.writeln("part '$fileName.g.dart';");
  buffer.writeln();
  buffer.writeln("@JsonSerializable()");
  buffer.writeln("class $className {");

  // Generate the class properties and constructor
  jsonMap.forEach((key, value) {
    String type = getType(key, value);
    type += '?';
    String propertyName = toCamelCase(key);

    // Check if the property name is a Dart keyword and adjust it accordingly
    if (dartKeywords.contains(propertyName)) {
      propertyName = '${propertyName}_';
    }

    buffer.writeln("  @JsonKey(name: '$key', defaultValue: null)");
    buffer.writeln("  final $type $propertyName;");
    buffer.writeln();
  });

  // constructor TODO: here we are using the properties that were generated in the previous step. so maybe it's better to store them in an array in the previous step and reuse them here, instead of regenerating them again.
  buffer.write("  $className({");
  jsonMap.forEach((key, value) {
    String propertyName = toCamelCase(key);
    // Check if the property name is a Dart keyword and adjust it accordingly
    if (dartKeywords.contains(propertyName)) {
      propertyName = '${propertyName}_';
    }
    buffer.write("this.$propertyName, ");
  });
  buffer.writeln("});");

  // Generate the fromJson and toJson methods
  buffer.writeln();
  buffer.writeln(
      "  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);");
  buffer.writeln(
      "  Map<String, dynamic> toJson() => _\$${className}ToJson(this);");

  // Close the class
  buffer.writeln("}");

  // Save the generated class to the map
  String fileNameWithExtension = '$fileName.dart';
  generatedFiles[fileNameWithExtension] = buffer.toString();

  // Recursively generate nested classes
  jsonMap.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      generateClass(generatedFiles, capitalize(key), value);
    } else if (value is List &&
        value.isNotEmpty &&
        value.first is Map<String, dynamic>) {
      String singularKey = toSingular(key);
      generateClass(generatedFiles, capitalize(singularKey), value.first);
    }
  });
}

String getType(String fieldName, dynamic value) {
  if (value == null) {
    return 'dynamic';
  }

  if (value is List) {
    if (value.isEmpty) {
      return 'List<dynamic>';
    }
    String itemType = getType(fieldName, value[0]);
    for (var i = 1; i < value.length; i++) {
      if (getType(fieldName, value[i]) != itemType) {
        return 'List<dynamic>';
      }
    }
    return 'List<${capitalizeNonPrimitiveTypeName(toSingular(itemType))}>';
  }

  if (value is Map) {
    return convertFileNameToClassName(fieldName);
  }

  return value.runtimeType.toString();
}
