import 'dart:async';

import 'package:build/build.dart';

import 'src/common.dart';
import 'src/generator.dart';

class JsonSerializableHelperBuilder implements Builder {
  JsonSerializableHelperBuilder(this.options);
  final BuilderOptions options;

  String get name => 'json_builder';

  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        '{{}}.json': <String>['{{}}.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Read the JSON file
    var inputFilePath = buildStep.inputId.path;
    print(
        'json_serializer_helper build started for $inputFilePath with buildStep.inputId: ${buildStep.inputId}');

    final jsonString = await buildStep.readAsString(buildStep.inputId);

    String className =
        convertFileNameToClassName(buildStep.inputId.pathSegments.last);
    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString, true);

    // Save the generated Dart file to the destination path
    generatedFiles.forEach((fileName, generatedDartFile) async {
      await buildStep.writeAsString(
          buildStep.inputId.changeExtension('.dart'), generatedDartFile);
    });
  }
}
