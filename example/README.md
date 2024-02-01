Add `json_serializable` and `json_serializable_helper` dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  json_serializable: ^6.7.1
  json_serializable_helper: ^1.0.0
```

Add `person.json` to your project, e.g. under `lib/models/person.json`:

```json
{
  "name": "John Doe",
  "age": 30,
  "address": {
    "street": "Main Street",
    "city": "New York",
    "country": "USA"
  },
  "job": {
    "title": "Software Engineer",
    "company": {
      "name": "Google",
      "address": {
        "street": "1600 Amphitheatre Parkway",
        "city": "Mountain View",
        "country": "USA"
      }
    }
  }
}
```

Add `build.yaml` to the root of your project, and specify the directory where `person.json` can be
found:

```yaml
global_options:
  json_serializable_helper:
    options:
      json_path: "lib/models"
```

Run `flutter pub run build_runner build` to generate the `person.dart` and `person.g.dart` files.
