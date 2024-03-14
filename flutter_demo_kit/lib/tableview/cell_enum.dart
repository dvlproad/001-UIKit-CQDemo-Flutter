/*
 * @Author: dvlproad
 * @Date: 2024-03-14 18:52:40
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-14 18:59:52
 * @Description: 
 */
typedef ClickCellCallback = void Function({int? section, int? row});

enum CJTSTableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}
