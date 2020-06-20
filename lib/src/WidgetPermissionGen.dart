import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tally_permission/annotations.dart';

///GeneratorForAnnotation:注解扫描器 只能够扫描 某个文件的顶层element；
class WidgetPermissionGen extends GeneratorForAnnotation<TallyPermission> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print("------------------- element is $element , ${element.runtimeType}");
    if (element is! ClassElement) {
      throw '-- TallyPermission only support Class !!';
    }
    StringBuffer stringBuffer = StringBuffer("");

    ClassElement e = element as ClassElement;
    for (var method in e.methods) {
      //方法的名字
      print("-- method.name = ${method.name}");
      for (var annotation in method.metadata) {
        //注解信息
        final metadata = annotation.computeConstantValue();
        //注解的类型
        final metadataType = metadata.type;
        //注解的类型名字
        final typeName = metadataType.getDisplayString();
        print("-- typeName = $typeName");
        print("-- metadataType = ${metadataType}");
        if (typeName == 'TallyWidget') {
          //注解的数值
          String permissionCode =
              metadata.getField('permissionCode').toStringValue();
          print("-- permissionCode = $permissionCode");
          stringBuffer.write('''
          
          Widget ${method.name}_$permissionCode({Widget child, WidgetBuilder builder}){
            return PermissionWidget('$permissionCode',child:child,builder:builder);
          }
          
          ''');
        }
      }
    }
    return stringBuffer.toString();
  }
}
