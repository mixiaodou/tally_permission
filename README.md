# tallypermission
在flutter的项目开发中 需要在多个函数中 调用重复的代码，例如：

> Widget widgetBtn() {
...
 return PermissionWidget('abc', child: child);
}

虽然已经 就行了封装，但是还是不够优美（逼格问题），能否像使用json_serializable一样 只需要在coding时 开启build_runner watch，直接调用 已经自动生成的代码；
达到最终效果：

> @TallyWidget("abc")
Widget widgetBtn() {
...
return widgetBtn_abc(child:child);
}

同时 理解掌握flutter 自动生成代码的机制，使用build_runner和source_gen;

## 先了解一下json_serializable
之所以写下这篇文字主要还是因为在开发中 使用这两个开源库，很方便的自动生成模版代码；最近节奏慢了下来，做个人学习总结；
json_serializable 是pub仓库上比较著名的一个用来json解析的代码生成库，只是这样
```
part 'StationModel.g.dart';
@JsonSerializable()
class StationModel extends Object {
  @JsonKey(name: 'address')
  String address;
  ...
}
```
在类声明的同级位置添加了这样 一个引入外部文件的声明，然后执行了这个命令
> flutter pub run build_runner build

就在同级的文件下生成了一个新的文件，很是奇怪；Android中也有注解的概念，如果要自动生成代码 通常会定义注解处理器，在编译过程中扫描指定的注解，读取代码的元素信息（注释，注解，code声明）然后生成代码，dart显然也是类似的
> Provides [source_gen](https://pub.dev/packages/source_gen) `Generator`s to create code for JSON serialization and deserialization.

这是json_serializable 官方的介绍，基于source_gen

## build_runner和source_gen
[build_runner](https://github.com/dart-lang/build/tree/master/build_runner)  build_runner提供了编译dart代码的命令，而且是pub命令之外的（只是通过pub命令执行build_runner命令）。通常结合source_gen使用，使用source_gen创建builder 代码编译器，然后build_runner可选择性的进行配置builder，最后执行build_runner命令 执行builder的代码 自动生成代码。
builder绑定了gennerator代码生成器，定义了代码生成规则。

> Standalone generator and watcher for Dart using [`package:build`](https://pub.dev/packages/build).
...
The build_runner package provides a concrete way of generating files using Dart code, outside of tools like pub

大部分情况下 build_runner 不需要单独配置，如果需要自定义配置 就在项目顶级目录下 创建一个build.yaml文件 声明即可；

builder_runner包含在build库中，但是没有被flutter环境默认引入，如果使用需要手动引入；


## 为什么使用source_gen
source_gen 提供了简化的api 来自动生成代码；
 >`source_gen` provides an API and tooling that is easily usable on top of `build` to make common tasks easier and more developer friendly. For example the [`PartBuilder`](https://pub.dev/documentation/source_gen/latest/source_gen/PartBuilder-class.html) class wraps one or more [`Generator`](https://pub.dev/documentation/source_gen/latest/source_gen/Generator-class.html) instances to make a [`Builder`](https://pub.dev/documentation/build/latest/build/Builder-class.html) which creates `part of` files, while the [`LibraryBuilder`](https://pub.dev/documentation/source_gen/latest/source_gen/LibraryBuilder-class.html) class wraps a single Generator to make a `Builder` which creates Dart library files.

source_gen 提供了两种代码构建器：PartBuilder 和SharedPartBuilder
- PartBuilder 用来生成part of文件
- SharedPartBuilder 用来生成单独的dart文件

具体参照[官方demo](https://github.com/dart-lang/source_gen)
需要注意的是 构建器builder 可指定作用域范围,也在build.yaml文件中配置
```
# Read about `build.yaml` at https://pub.dev/packages/build_config
targets:
  $default:
    builders:
      # Configure the builder `pkg_name|builder_name`
      # In this case, the member_count builder defined in `../example`
      #-----------指定 代码构建器的 目标作用域
      source_gen_example|member_count:
        # Only run this builder on the specified input.
        #---------指定 代码构建器的 目标文件
        generate_for:
          #- lib/library_source.dart
          - lib/*.dart

      source_gen_example|property_sum:
        generate_for:
          - lib/*.dart
      source_gen_example|property_product:
        generate_for:
          - lib/*.dart
      # The end-user of a builder which applies "source_gen|combining_builder"
      # may configure the builder to ignore specific lints for their project
      source_gen|combining_builder:
        options:
          ignore_for_file:
            - lint_a
            - lint_b
```


更多例子：
[https://github.com/dart-lang/build/tree/master/build_runner](https://github.com/dart-lang/build/tree/master/build_runner)
[https://blog.csdn.net/act64/article/details/90703480](https://blog.csdn.net/act64/article/details/90703480)
[https://github.com/mixiaodou/source_gen](https://github.com/mixiaodou/source_gen)
