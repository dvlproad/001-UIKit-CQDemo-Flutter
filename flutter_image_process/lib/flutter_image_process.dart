/*
 * @Author: dvlproad
 * @Date: 2023-03-17 20:48:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-09 10:17:02
 * @Description: 
 */
library flutter_image_process;

// data_vientiane
export './src/data_vientiane/data_vientiane.dart';

export './src/images_compress_util.dart';

export './src/bean/image_choose_bean.dart';
export './src/bean/image_compress_bean.dart';
export './src/bean/video_compress_bean.dart';

export './src/bean/base_compress_bean.dart'
    show CompressResultType, CompressInfoProcess;

// 语音
export './src/voice/voice_base_bean.dart';

// util-compress
export 'src/get_image_info_util/media_type_util.dart'; // 需要 UploadMediaType
export 'src/get_image_info_util/asset_entity_info_getter.dart';
export 'src/image_compress_util/app_video_frame_util.dart';
export 'src/image_compress_util/app_video_compress_check_util.dart';
export 'src/image_compress_util/app_image_compress_util.dart';
