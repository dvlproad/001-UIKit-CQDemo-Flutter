# flutter_base_models

一个应用的所有基础模型


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

