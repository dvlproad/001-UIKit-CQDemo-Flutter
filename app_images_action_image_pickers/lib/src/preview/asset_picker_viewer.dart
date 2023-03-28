// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetPickerViewer<Asset, Path> extends StatefulWidget {
  const AssetPickerViewer({
    super.key,
    required this.builder,
  });

  final AssetPickerViewerBuilderDelegate<Asset, Path> builder;

  @override
  AssetPickerViewerState<Asset, Path> createState() =>
      AssetPickerViewerState<Asset, Path>();

  /// Static method to push with the navigator.
  /// 跳转至选择预览的静态方法
  static Future<List<AssetEntity>?> pushToViewer(
    BuildContext context, {
    int currentIndex = 0,
    required List<AssetEntity> previewAssets,
    required ThemeData themeData,
    DefaultAssetPickerProvider? selectorProvider,
    ThumbnailSize? previewThumbnailSize,
    List<AssetEntity>? selectedAssets,
    SpecialPickerType? specialPickerType,
    int? maxAssets,
    bool shouldReversePreview = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
  }) async {
    await AssetPicker.permissionCheck();
    final Widget viewer = AssetPickerViewer<AssetEntity, AssetPathEntity>(
      builder: DefaultAssetPickerViewerBuilderDelegate(
        currentIndex: currentIndex,
        previewAssets: previewAssets,
        provider: selectedAssets != null
            ? AssetPickerViewerProvider<AssetEntity>(
                selectedAssets,
                maxAssets: maxAssets ??
                    selectorProvider?.maxAssets ??
                    defaultMaxAssetsCount,
              )
            : null,
        themeData: themeData,
        previewThumbnailSize: previewThumbnailSize,
        specialPickerType: specialPickerType,
        selectedAssets: selectedAssets,
        selectorProvider: selectorProvider,
        maxAssets: maxAssets,
        shouldReversePreview: shouldReversePreview,
        selectPredicate: selectPredicate,
      ),
    );
    final PageRouteBuilder<List<AssetEntity>> pageRoute =
        PageRouteBuilder<List<AssetEntity>>(
      pageBuilder: (_, __, ___) => viewer,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
    final List<AssetEntity>? result =
        await Navigator.of(context).push<List<AssetEntity>>(pageRoute);
    return result;
  }

  /// Call the viewer with provided delegate and provider.
  /// 通过指定的 [delegate] 调用查看器
  static Future<List<A>?> pushToViewerWithDelegate<A, P>(
    BuildContext context, {
    required AssetPickerViewerBuilderDelegate<A, P> delegate,
  }) async {
    await AssetPicker.permissionCheck();
    final Widget viewer = AssetPickerViewer<A, P>(builder: delegate);
    final PageRouteBuilder<List<A>> pageRoute = PageRouteBuilder<List<A>>(
      pageBuilder: (_, __, ___) => viewer,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
    final List<A>? result = await Navigator.of(context).push<List<A>>(
      pageRoute,
    );
    return result;
  }
}
