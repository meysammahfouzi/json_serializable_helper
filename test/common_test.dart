import 'package:json_serializable_helper/src/common.dart';
import 'package:test/test.dart';

void main() {
  // Test capitalize function
  test('capitalize function should capitalize the first letter of the word',
      () {
    expect(capitalize('name'), 'Name');
    expect(capitalize('Name'), 'Name');
    expect(capitalize('firstName'), 'FirstName');
    expect(capitalize('FirstName'), 'FirstName');
    expect(capitalize('first_name'), 'First_name');
    expect(capitalize('First_name'), 'First_name');
    expect(capitalize('First_Name'), 'First_Name');
  });

  test(
      'capitalizeNonPrimitiveTypeName function should capitalize the first '
      'letter of the word if it is not a primitive type', () {
    expect(capitalizeNonPrimitiveTypeName('person'), 'Person');
    expect(capitalizeNonPrimitiveTypeName('Person'), 'Person');
    expect(capitalizeNonPrimitiveTypeName('dataType'), 'DataType');
    expect(capitalizeNonPrimitiveTypeName('int'), 'int');
    expect(capitalizeNonPrimitiveTypeName('double'), 'double');
    expect(capitalizeNonPrimitiveTypeName('bool'), 'bool');
    expect(capitalizeNonPrimitiveTypeName('dynamic'), 'dynamic');
    expect(capitalizeNonPrimitiveTypeName('num'), 'num');
  });

  // Test toSnakeCase function
  test('toSnakeCase function should return snake case', () {
    expect(toSnakeCase('name'), 'name');
    expect(toSnakeCase('Name'), 'name');
    expect(toSnakeCase('firstName'), 'first_name');
    expect(toSnakeCase('FirstName'), 'first_name');
    expect(toSnakeCase('firstName1'), 'first_name1');
    expect(toSnakeCase('FirstName1'), 'first_name1');
    expect(toSnakeCase('first_name'), 'first_name');
    expect(toSnakeCase('First_name'), 'first_name');
    expect(toSnakeCase('First_Name'), 'first_name');
  });

  // Test toCamelCase function
  test('toCamelCase function should return camel case', () {
    expect(toCamelCase('TestKey'), 'testKey');
    expect(toCamelCase('exampleString'), 'exampleString');
    expect(toCamelCase('another'), 'another');
    expect(toCamelCase('Some'), 'some');
    expect(toCamelCase('first_name'), 'firstName');
    expect(toCamelCase('First_Name'), 'firstName');
    expect(toCamelCase('first_name_'), 'firstName');
    expect(toCamelCase('First_Name_'), 'firstName');
    expect(toCamelCase('first_name_1'), 'firstName1');
    expect(toCamelCase('First_Name_1'), 'firstName1');
    expect(toCamelCase('first_name_1_'), 'firstName1');
  });

  // Test toSingular function
  test('toSingular function should return the singular form of the word', () {
    expect(toSingular('users'), 'user');
    expect(toSingular('Users'), 'User');
    expect(toSingular('Ladies'), 'Lady');
    expect(toSingular('boxes'), 'box');
    expect(toSingular('categories'), 'category');
    expect(toSingular('items'), 'item');
    expect(toSingular('countries'), 'country');
    expect(toSingular('women'), 'woman');
    expect(toSingular('Men'), 'man');
    expect(toSingular('children'), 'child');
  });
}
