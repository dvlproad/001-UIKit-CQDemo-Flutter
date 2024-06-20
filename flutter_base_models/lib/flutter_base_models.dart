/*
 * @Author: dvlproad
 * @Date: 2024-05-11 09:37:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 11:09:22
 * @Description: 
 */
library flutter_base_models;

// base
export './base_json_convert.dart';

// user
export './user/user_base_model.dart';
export './user/user_enum_avatar.dart';
export './user/user_enum_realname.dart';
export './user/protocal/user_level_protocal.dart';
export './user/relation/user_relation_model.dart';
export './user/relation/user_relation_tag_model.dart';

// social
export './social/base_comment_model.dart';
export './social/enum_like_status.dart';
export './social/social_count_protocal.dart';
export './social/request_anchor_comment.dart'; // request

// location
// location: base
export './location/base_address_model.dart'; // 位置的基类
export './location/base_location_model.dart'; // 定位sdk返回的位置信息
export './location/area_code_util.dart';
// location: nearby
export './location/map_poi/nearby_address_model.dart';
// location: area picker
export './location/area_picker/base_area_picker_model.dart'; // area picker 数据源类
// export './location/area_picker_selected_index_model.dart'; // area picker 选择的 index 集
export './location/area_picker/area_picker_address_model.dart'; // area picker 选择的结果集
// location: both
export './location/nearby_or_picker_adderss_model.dart';

// auth
export './auth/avatar_auth_service_info.dart';
export './auth/avatar_first_must_auth_utiler.dart';

// publish
export './publish/jurisdiction_bean.dart';
export './publish/base_publish_model.dart';

// topic
export './topic/base_topic_model.dart';

// pickers
export './pickers/base_choose_item_util.dart';
export './pickers/base_choose_item_model.dart';
// pickers--date
export './pickers/date/date_enum.dart';
export './pickers/date/date_choose_rule_model.dart';

// tree
export './tree/base_tree_model.dart';

// services
export './services/user/base_user_singleton.dart';
export './services/user/user_event.dart';
export './services/user/user_cache_protocal.dart';
export './services/user/user_update_protocal.dart';
