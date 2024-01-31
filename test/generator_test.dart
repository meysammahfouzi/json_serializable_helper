import 'package:json_serializable_helper/src/generator.dart';
import 'package:test/test.dart';

void main() {
  test('generateDartClasses should create only one file with correct name', () {
    String className = 'Person';
    String jsonString = '''
    {
      "name": "John Doe",
      "age": 30,
      "address": {
        "street": "123 Main St",
        "city": "New York",
        "country": "USA"
      },
      "job": {
        "title": "Software Engineer",
        "company": {
          "name": "TechCorp",
          "industry": "Technology"
        }
      }
    }
    ''';

    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString, true);
    expect(generatedFiles.length, 1);
    // check file name
    expect(generatedFiles.containsKey('person.dart'), true);
  });

  test('generateDartClasses should create multiple files with correct name',
      () {
    String className = 'Person';
    String jsonString = '''
    {
      "name": "John Doe",
      "age": 30,
      "address": {
        "street": "123 Main St",
        "city": "New York",
        "country": "USA"
      },
      "job": {
        "title": "Software Engineer",
        "company": {
          "name": "TechCorp",
          "industry": "Technology"
        }
      }
    }
    ''';

    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString);

    expect(generatedFiles.length, 4);

    expect(generatedFiles.containsKey('person.dart'), true);
    expect(generatedFiles.containsKey('address.dart'), true);
    expect(generatedFiles.containsKey('job.dart'), true);
    expect(generatedFiles.containsKey('company.dart'), true);
  });

  test('generateDartClasses should create the expected Dart classes', () {
    String className = 'TestClass';
    String jsonString = '''
    {
      "id": 1,
      "name": "John Doe",
      "scores": [95, 88, 76]
    }
    ''';

    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString);

    // Check if the expected file exists in the generated files map
    String fileName = 'test_class.dart';
    expect(generatedFiles.containsKey(fileName), true);

    // Check if the content of the file contains the expected class name
    String fileContent = generatedFiles[fileName]!;
    expect(
        fileContent.contains(
            'import \'package:json_annotation/json_annotation.dart\';'),
        true);
    expect(!fileContent.contains('import \'.dart\';'), true);
    expect(fileContent.contains('part \'test_class.g.dart\';'), true);
    expect(fileContent.contains('@JsonSerializable()'), true);
    expect(fileContent.contains('class TestClass'), true);
    expect(fileContent.contains('@JsonKey(name: \'id\', defaultValue: null)'),
        true);
    expect(fileContent.contains('final int? id;'), true);
    expect(fileContent.contains('@JsonKey(name: \'name\', defaultValue: null)'),
        true);
    expect(fileContent.contains('final String? name;'), true);
    expect(
        fileContent.contains('@JsonKey(name: \'scores\', defaultValue: null)'),
        true);
    expect(fileContent.contains('final List<int>? scores;'), true);
    expect(
        fileContent.contains('TestClass({this.id, this.name, this.scores, });'),
        true);
    expect(
        fileContent.contains(
            'factory TestClass.fromJson(Map<String, dynamic> json) => _\$TestClassFromJson(json);'),
        true);
    expect(
        fileContent.contains(
            'Map<String, dynamic> toJson() => _\$TestClassToJson(this);'),
        true);
  });

  test('generateDartClasses generates expected output for simple JSON', () {
    String className = 'Person';
    String jsonString = '{"name": "John Doe", "age": 30, "isStudent": false}';

    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString);
    String? personDartContent = generatedFiles['person.dart'];

    expect(personDartContent, isNotNull);
    expect(personDartContent, contains('@JsonSerializable()'));
    expect(personDartContent, contains('class Person {'));

    // Check properties
    expect(personDartContent,
        contains("@JsonKey(name: 'name', defaultValue: null)"));
    expect(personDartContent, contains('final String? name;'));
    expect(personDartContent,
        contains("@JsonKey(name: 'age', defaultValue: null)"));
    expect(personDartContent, contains('final int? age;'));
    expect(personDartContent,
        contains("@JsonKey(name: 'isStudent', defaultValue: null)"));
    expect(personDartContent, contains('final bool? isStudent;'));

    // Check constructor
    expect(personDartContent,
        contains('Person({this.name, this.age, this.isStudent, });'));

    // Check fromJson and toJson methods
    expect(
        personDartContent,
        contains(
            'factory Person.fromJson(Map<String, dynamic> json) => _\$PersonFromJson(json);'));
    expect(personDartContent,
        contains('Map<String, dynamic> toJson() => _\$PersonToJson(this);'));
  });

  test('generateDartClasses handles Type keyword correctly', () {
    String className = 'Summary';
    String jsonString = '''
  {
    "Type": {
      "Text": "Example",
      "Confidence": 0.9
    },
    "Content": "This is a test"
  }
  ''';

    Map<String, String> generatedFiles =
        generateDartClasses(className, jsonString);

    // Check if the renamed class file 'field_type.dart' is generated
    expect(generatedFiles.containsKey('type_class.dart'), isTrue);

    // Check the content of the generated 'summary.dart' file
    String? summaryDartContent = generatedFiles['summary.dart'];
    expect(summaryDartContent, isNotNull);
    expect(summaryDartContent, contains("import 'type_class.dart';"));
    expect(summaryDartContent, contains("part 'summary.g.dart';"));
    expect(summaryDartContent,
        contains("@JsonKey(name: 'Type', defaultValue: null)"));
    expect(summaryDartContent, contains("final TypeClass? type;"));

    // Check the content of the generated 'field_type.dart' file
    String? fieldTypeDartContent = generatedFiles['type_class.dart'];
    expect(fieldTypeDartContent, isNotNull);
    expect(fieldTypeDartContent, contains("part 'type_class.g.dart';"));
    expect(fieldTypeDartContent, contains('@JsonSerializable()'));
    expect(fieldTypeDartContent, contains('class TypeClass {'));
    expect(
        fieldTypeDartContent,
        contains(
            'factory TypeClass.fromJson(Map<String, dynamic> json) => _\$TypeClassFromJson(json);'));
    expect(fieldTypeDartContent,
        contains('Map<String, dynamic> toJson() => _\$TypeClassToJson(this);'));
  });

  // Test getType function
  test('getType function should return the correct type based on the value',
      () {
    expect(getType('count', 42), 'int');
    expect(getType('value', 3.14), 'double');
    expect(getType('text', 'hello'), 'String');
    expect(getType('flag', true), 'bool');
    expect(getType('unknown', null), 'dynamic');
    expect(getType('user', {'name': 'John'}), 'User');
    expect(getType('numbers', [1, 2, 3]), 'List<int>');
    expect(getType('names', ['john', 'david', 'brian']), 'List<String>');
    expect(getType('grades', [3.14, 7.24]), 'List<double>');
    expect(getType('flags', [true, false]), 'List<bool>');
    expect(
        getType('numbers', [
          [1, 2, 3],
          [4, 5, 6]
        ]),
        'List<List<int>>');
    expect(
        getType('users', [
          {'name': 'John'}
        ]),
        'List<User>');
    expect(
        getType('people', [
          {'name': 'John'}
        ]),
        'List<Person>');
    expect(
        getType('users', [
          [
            {'name': 'John'},
            {'name': 'David'}
          ],
          [
            {'name': 'Brian'},
            {'name': 'Michael'}
          ]
        ]),
        'List<List<User>>');
  });

  // Test _generateClass function
  test('_generateClass function should generate the correct class structure',
      () {
    Map<String, String> generatedFiles = {};
    generateClass(generatedFiles, 'Person', {'name': 'John', 'age': 30});

    String? personDartContent = generatedFiles['person.dart'];
    expect(personDartContent, isNotNull);
    expect(personDartContent, contains('@JsonSerializable()'));
    expect(personDartContent, contains('class Person {'));
    expect(personDartContent,
        contains("@JsonKey(name: 'name', defaultValue: null)"));
    expect(personDartContent, contains('final String? name;'));
    expect(personDartContent,
        contains("@JsonKey(name: 'age', defaultValue: null)"));
    expect(personDartContent, contains('final int? age;'));
    expect(
        personDartContent,
        contains(
            'factory Person.fromJson(Map<String, dynamic> json) => _\$PersonFromJson(json);'));
    expect(personDartContent,
        contains('Map<String, dynamic> toJson() => _\$PersonToJson(this);'));
  });

  test('Generated Dart classes for comprehensive JSON', () {
    String jsonInput = '''
    {
      "string": "Hello, World!",
      "integer": 42,
      "double": 3.14,
      "boolean": true,
      "nullValue": null,
      "array": [
        "element1",
        2,
        3.0,
        true,
        null,
        {
          "key": "value"
        }
      ],
      "object": {
        "stringKey": "This is a string",
        "integerKey": 123,
        "doubleKey": 12.34,
        "booleanKey": false,
        "nullKey": null,
        "arrayKey": [
          "one",
          "two",
          "three"
        ],
        "nestedObject": {
          "anotherKey": "Another value"
        }
      }
    }
    ''';

    Map<String, String> generatedFiles =
        generateDartClasses('ComprehensiveJson', jsonInput);

    expect(generatedFiles, isNotNull);
    expect(generatedFiles, isNotEmpty);

    // Check the main class
    expect(generatedFiles['comprehensive_json.dart'], isNotNull);
    expect(generatedFiles['comprehensive_json.dart'],
        contains('class ComprehensiveJson'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final String? string;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final int? integer;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final double? double_;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final bool? boolean;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final dynamic? nullValue;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final List<dynamic>? array;'));
    expect(generatedFiles['comprehensive_json.dart'],
        contains('final Object? object;'));

    // Check the nested Object class
    expect(generatedFiles['object.dart'], isNotNull);
    expect(generatedFiles['object.dart'], contains('class Object'));
    expect(generatedFiles['object.dart'], contains('final String? stringKey;'));
    expect(generatedFiles['object.dart'], contains('final int? integerKey;'));
    expect(generatedFiles['object.dart'], contains('final double? doubleKey;'));
    expect(generatedFiles['object.dart'], contains('final bool? booleanKey;'));
    expect(generatedFiles['object.dart'], contains('final dynamic? nullKey;'));
    expect(generatedFiles['object.dart'],
        contains('final List<String>? arrayKey;'));
    expect(generatedFiles['object.dart'],
        contains('final NestedObject? nestedObject;'));

    // Check the nested NestedObject class
    expect(generatedFiles['nested_object.dart'], isNotNull);
    expect(
        generatedFiles['nested_object.dart'], contains('class NestedObject'));
    expect(generatedFiles['nested_object.dart'],
        contains('final String? anotherKey;'));
  });
}
