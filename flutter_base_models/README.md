# flutter_base_models

一个应用的所有基础模型

PS1: model 的属性暂都不使用 final 修饰，因为后续可能需要修改。即使是id，也可能存在一些旧的代码里使用 id == baseModel.id 的情况。

PS2: 如果基类定义为 abstract 则子类无法使用 UserDetailModel.fromJson(Map<String, dynamic> json) 只能用 static UserDetailModel fromJson(Map<String, dynamic> json) 方法。

### 复杂一点的泛型使用

```
abstract class BaseCityModel<T extends BaseCityModel<T>>

使用：
static AreaPickerAddressModel fromSelectedIndex<T extends BaseCityModel<T>>

子类：
class AppCityModel extends BaseCityModel<AppCityModel>

```



```shell
# app
flutter create tsbaseuidemo

# package
flutter create --template=package flutter_baseui_kit
flutter create --template=package tsdemo_baseui
```

