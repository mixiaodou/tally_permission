//指定当前code路径
library tally_permission.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tally_permission/src/WidgetPermissionGen.dart';
import 'package:tally_permission/src/WidgetWrapGen.dart';

Builder widgetPermissionBuilder(BuilderOptions options) {
  return SharedPartBuilder([WidgetPermissionGen()], 'widgetPermission');
}

Builder tallyPermissionBuilder(BuilderOptions options) {
  return LibraryBuilder(WidgetWrapGen(),
      generatedExtension: '.tally.dart');
}
