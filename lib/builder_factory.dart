import 'package:build/build.dart';

import 'builder.dart';

Builder getBuilder(BuilderOptions options) =>
    JsonSerializableHelperBuilder(options);
