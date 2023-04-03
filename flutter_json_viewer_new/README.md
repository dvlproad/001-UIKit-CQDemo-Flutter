# flutter_json_viewer_new



## Features

本控件在[flutter_json_viewer](https://pub.dev/packages/flutter_json_viewer)基础上，额外增加可

* 使用`JSONText`替换原本的`Text`控件，同时传入value值，而不仅仅传显示的text值，使得可以对显示的text控件有更多操作的可能性。
* 为`JSONText`添加双击可拷贝原始value值的操作，方便提取数据到其他地方掰扯（提取的数据会帮你转为标准的json格式）。
* 优化更多警告问题





## Use this package as a library on [Dart dev](flutter_json_viewer_new) 

### 1. Depend on it 

Add this to your package's pubspec.yaml file:

```yaml
dependencies:

flutter_json_viewer_new: ^0.0.1
```

### 2. Install it 

You can install packages from the command line:

with Flutter:

```kotlin
$ flutter pub get
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

### 3. Import it 

Now in your Dart code, you can use:

```kotlin
import 'package:flutter_json_viewer_new/flutter_json_viewer_new.dart';
```

### 4. Show it 

```markdown
Container(
    child: JsonViewer(jsonObj)
)
```

