/*
 * @Author: dvlproad
 * @Date: 2022-07-18 18:07:40
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-08 15:58:11
 * @Description: 数据万象(宽高都不传的时候，只会做 format/webp/auto-orient 处理)
 */
import 'package:flutter_image_process/flutter_image_process.dart';
export 'package:flutter_image_process/src/data_vientiane/data_vientiane.dart';
import '../flutter_image_kit_adapt.dart';

class DataVientiane {
  static bool canVientiane(String imageUrl) {
    // https://images.xxx.com/mcms/uploads/1647604960983901.jpg?imageMogr2/thumbnail/100x/format/webp/auto-orient
    int index = imageUrl.indexOf('.xxx.com');
    bool isCloudImage = index != -1;
    return isCloudImage;
  }

  static String newImageUrl(
    String? imageUrl,
    ImageDealType imageDealType, {
    double? width,
    double? height,
    void Function(String lastImageUrl)? lastImageUrlGetBlock,
  }) {
    return BaseDataVientiane.newImageUrl(
      imageUrl,
      imageDealType,
      canVientianeGetBlock: (String checkImageUrl) {
        return canVientiane(checkImageUrl);
      },
      widthLadderValue: 50.w_pt_cj,
      widthLadderCount: 8,
      width: width,
      height: height,
      lastImageUrlGetBlock: lastImageUrlGetBlock,
    );
  }
}
