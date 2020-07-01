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
