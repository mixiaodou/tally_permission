import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class WidgetWrapGen extends GeneratorForAnnotation<TallyPermission> {

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    return super.generate(library, buildStep);
  }

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print("------------------- element is $element , runtimeType is ${element.runtimeType}");
    if (element is! ClassElement) {
      throw '-- TallyPermission only support Class !!';
    }
    ClassElement e = element as ClassElement;
    StringBuffer stringBuffer = StringBuffer();
    bool first=true;
    e.methods.forEach((m) {
      String methodName = m.name;
      m.metadata.forEach((an) {
        DartObject metadata = an.computeConstantValue();
        ParameterizedType metadataType = metadata.type;
        String metadataTypeName = metadataType.getDisplayString();
        if (metadataTypeName == 'TallyWidget') {
          String permissionCode = metadata.getField('permissionCode').toStringValue();
          if(first){
            first=false;
            stringBuffer.write('''
            import 'package:flutter/material.dart';
            import 'package:zh_tally/permission/PermissionWidget.dart';
          
          ''');
          }
          stringBuffer.write('''
          
          // ignore: non_constant_identifier_names
          Widget ${methodName}_$permissionCode({Widget child, WidgetBuilder builder}){
            return PermissionWidget('$permissionCode',child:child,builder:builder);
          }
          
          ''');
        }
      });
    });
    return stringBuffer.toString();
  }

}
