/*
 * @Author: dvlproad
 * @Date: 2024-05-24 17:43:45
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-24 18:10:00
 * @Description: 
 */
abstract class BaseTreeModel {
  final String? id;
  final List<BaseTreeModel>? children;

  BaseTreeModel({
    this.id,
    this.children,
  });

  /// 递归遍历：根据叶子节点id，获取选中的叶子节点信息
  /// （常用于：判断这个树是否被选中，如果有选中该树的任意节点则①显示高亮及②对应的信息。eg场景:将一堆标签树）
  BaseTreeModel? getLeafTagModelByLeafTagId(String? leafTagId) {
    if (leafTagId == null) {
      return null;
    }

    if (id == leafTagId) {
      return this;
    } else {
      if (children == null || children!.isEmpty) {
        return null;
      }

      for (var childTagModel in children!) {
        BaseTreeModel? leafTagModel =
            childTagModel.getLeafTagModelByLeafTagId(leafTagId);
        if (leafTagModel != null) {
          return leafTagModel;
        }
      }

      return null;
    }
  }

  /// 递归遍历：根据叶子节点id，获取选中的标签节点的完整路径信息（暂时没发生什么用处）
  List<int>? getLeafTagModelPathByLeafTagId(String leafTagId) {
    if (id == leafTagId) {
      return [0];
    } else {
      if (children == null || children!.isEmpty) {
        return null;
      }

      List<int> fullLeafIndexPaths = [];
      int childTagCount = children!.length;
      for (var i = 0; i < childTagCount; i++) {
        List<int>? childLeafIndexPaths;
        var childTagModel = children![i];

        if (childTagModel.id == leafTagId) {
          childLeafIndexPaths = [i];
        } else {
          childLeafIndexPaths =
              childTagModel.getLeafTagModelPathByLeafTagId(leafTagId);
        }

        if (childLeafIndexPaths != null) {
          fullLeafIndexPaths.addAll(childLeafIndexPaths);
          break;
        }
      }

      return fullLeafIndexPaths;
    }
  }
}
