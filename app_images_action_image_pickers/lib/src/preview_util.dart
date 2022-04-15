/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 16:04:37
 * @Description: 图片/视频等浏览方法
 */

import './bean/image_choose_bean.dart';
import 'package:image_pickers/image_pickers.dart';

class PreviewUtil {
  static preview(List<ImageChooseBean> imageChooseModels, int imageIndex) {
    List<String> imagePaths = [];
    for (ImageChooseBean item in imageChooseModels) {
      String imagePath = item.localPath ?? item.networkUrl ?? '';
      imagePaths.add(imagePath);
    }

    ImagePickers.previewImages(imagePaths, imageIndex);
  }
}
