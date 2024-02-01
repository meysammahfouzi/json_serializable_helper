## [![Pub Version](https://img.shields.io/pub/v/json_serializable_helper)](https://pub.dev/packages/json_serializable_helper) [![codecov](https://codecov.io/gh/meysammahfouzi/json_serializable_helper/graph/badge.svg?token=JC7QQUSQE7)](https://codecov.io/gh/meysammahfouzi/json_serializable_helper)

By adding this package to your project, you can directly use json files as the input of the 
[json_serializable](https://pub.dev/packages/json_serializable) package.

![Diagram](https://github.com/meysammahfouzi/json_serializable_helper/raw/main/diagram.jpeg "json_serializable_helper")

## Features

Imagine you have received the following response from an API call:

```json
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
```

If you want to decode and encode this simple JSON, you can use the `json_serializable` package. But 
before doing that, you need to create the corresponding `person.dart` class required by 
`json_serializable`:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  @JsonKey(name: 'name', defaultValue: null)
  final String? name;

  @JsonKey(name: 'age', defaultValue: null)
  final int? age;

  @JsonKey(name: 'address', defaultValue: null)
  final Address? address;

  @JsonKey(name: 'job', defaultValue: null)
  final Job? job;

  Person({
    this.name,
    this.age,
    this.address,
    this.job,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Address {
  @JsonKey(name: 'street', defaultValue: null)
  final String? street;

  @JsonKey(name: 'city', defaultValue: null)
  final String? city;

  @JsonKey(name: 'country', defaultValue: null)
  final String? country;

  Address({
    this.street,
    this.city,
    this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Job {
  @JsonKey(name: 'title', defaultValue: null)
  final String? title;

  @JsonKey(name: 'company', defaultValue: null)
  final Company? company;

  Job({
    this.title,
    this.company,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}

@JsonSerializable()
class Company {
  @JsonKey(name: 'name', defaultValue: null)
  final String? name;

  @JsonKey(name: 'industry', defaultValue: null)
  final String? industry;

  Company({
    this.name,
    this.industry,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
```

And then by running the following command:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The `person.g.dart` file will be generated for you and you are done!

As you can see, writing the `person.dart` class is a tedious and error-prone process, specially when 
the JSON is large and complex. This package aims to simplify this process by allowing you to use the
JSON file as the input of the `json_serializable`. That means you only need to include the JSON file
in your project, and then by running the same command above, the corresponding dart classes (
`person.dart` and `person.g.dart`) will be generated for you.

## Usage

Add `json_serializable` and `json_serializable_helper` dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  json_serializable: ^6.7.1
  json_serializable_helper: ^1.0.0
```

Then add the `build.yaml` file to the root of your project. In this file you should specify the
directory where your JSON file(s) will be found, for example:

```yaml
global_options:
  json_serializable_helper:
    options:
      json_path: "lib/datamodels"
```

In the above example, your json file can be placed in the `lib/datamodels` directory or any 
subdirectory under it, for example `lib/datamodels/aws/person.json`.

Now run the following command to generate the dart classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will generate the `person.dart` and `person.g.dart` files next to your `person.json` file.

## Contribution

If you find a bug or want to add a feature, please create an issue or a pull request.   
Thank you!