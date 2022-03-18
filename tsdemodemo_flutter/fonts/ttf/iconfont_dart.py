# coding: u8
import re
from pathlib import Path
import time
ROOT = Path(__file__).resolve().parent
MAIN = ROOT
# 生成的IconFont.dart 文件路径
IconDart = 'lib/common/style/IconFont.dart'
# iconfont css 文件存放路径
#IconCss = 'assets/iconfont/iconfont.css'
IconDart = 'IconFont.dart'
IconCss = 'iconfont.css'
# 将 iconfont 的 css 自动转换为 dart 代码
def translate():
    print('Begin translate...')
    
    code = """
        import 'package:flutter/widgets.dart';
        
        /// @author:  hsc
        /// @date: {date}
        /// @description  代码由程序自动生成。请不要对此文件做任何修改。
        
        class IconFont {
        
        static const String FONT_FAMILY = 'IconFont';
        
        {icon_codes}
        
        }
        """.strip()
    strings = []
    content = open(MAIN / IconCss).read().replace('\n  content', 'content')
    matchObj = re.finditer( r'.icon-(.*?):(.|\n)*?"\\(.*?)";', content)
    for match in matchObj:
        name = match.group(1)
        name = name.replace("-","_")
        string = f'  static const IconData {name} = const IconData(0x{match.group(3)}, fontFamily: IconFont.FONT_FAMILY);'
        strings.append(string)
    strings = '\n'.join(strings)
    code = code.replace('{icon_codes}', strings)
    code = code.replace('{date}', time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
    open(MAIN / IconDart, 'w').write(code)
    print('Finish translate...')

if __name__ == "__main__":
    translate()

