/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-24 18:52:31
 * @Description: 基础UI库
 */
library flutter_baseui_kit;

// bgcontainer
export 'src/bg_border_widget.dart';

// button
export './src/button/base_image_text_button.dart';
export './src/button/basebutton.dart' show CJButtonConfigModel, CJBaseButton;
export './src/button/button_child_widget.dart'
    show ButtonImagePosition, ButtonChildWidget;

// cell 包含标题文本title，值视图valueWidget、箭头类型 的视图
export './src/cell/title_textValue_cell.dart'; // text 文本
// export './src/cell/title_imageValue_cell.dart'; // image 图片
export './src/cell/title_textInputValue_cell.dart'; // textInput 输入框
export './src/cell/title_switchValue_cell.dart'; // switch 开关
export './src/cell/title_commonValueWithHolder_cell.dart';
export './src/cell/title_commonValue_cell.dart';

// textinput
export './src/textfield/clearButton_textfield.dart';
export './src/textfield/textfield_container.dart';
export './src/textInputFormatter/TextInputFormatterFactory.dart';
export './src/textInputFormatter/emoji_lengthLimiting_textInputFormatter.dart';
export './src/textInputFormatter/textinputformatter_util.dart';
export './src/textview/emoji_input_textview.dart';
