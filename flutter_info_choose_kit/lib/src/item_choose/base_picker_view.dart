import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_models/flutter_base_models.dart';
import 'package:flutter_info_choose_kit/flutter_info_choose_kit_adapt.dart';

class BasePickerView<T extends BaseChooseItemModel> extends StatefulWidget {
  final double height;
  final Color selectedBackgroundColor;
  final Color normalTextColor;
  final Color itemNormalTextColor;
  final Color itemSelectedTextColor;
  final Color okTitleColor;

  final String title;
  final Widget Function()? customTitleBuilder;
  final List<T> itemModels;
  final T? selectedModel;
  final Function(T selectedItem) onSubmit;

  final Function(StateSetter setModalState)? updateState;

  const BasePickerView({
    Key? key,
    required this.height,
    this.selectedBackgroundColor = const Color(0x20FF4587),
    this.normalTextColor = const Color(0xFF222222),
    this.okTitleColor = const Color(0xFFE67D4F),
    this.itemNormalTextColor = const Color(0xFF999999),
    this.itemSelectedTextColor = const Color(0xFF333333),
    required this.title,
    this.customTitleBuilder,
    required this.itemModels,
    this.selectedModel,
    required this.onSubmit,
    this.updateState,
  }) : super(key: key);

  @override
  State createState() => _BasePickerViewState<T>();
}

class _BasePickerViewState<T extends BaseChooseItemModel>
    extends State<BasePickerView<T>> {
  List<T> _itemModels = [];
  int _currentSelectedIndex = 0;

  late FixedExtentScrollController scrollController;

  // 避免直接用setState影响渲染性能
  final StreamController<int> _textColorStreamController =
      StreamController.broadcast();

  @override
  void dispose() {
    _textColorStreamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _itemModels = widget.itemModels;
    if (widget.updateState != null) {
      widget.updateState!(setState);
    }

    // for (var element in _itemModels) {
    //   if (element.choosed == true) {
    //     _currentSelectedIndex = _itemModels.indexOf(element);
    //     break;
    //   }
    // }
    _currentSelectedIndex = _itemModels
        .indexWhere((element) => (element.id == widget.selectedModel?.id));

    scrollController =
        FixedExtentScrollController(initialItem: _currentSelectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w_pt_cj),
          topRight: Radius.circular(10.w_pt_cj),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderToolbar(),
          SizedBox(
            height: widget.height - 52.w_pt_cj,
            child: _renderPickerList(),
          ),
        ],
      ),
    );
  }

  _renderToolbar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w_pt_cj),
          topRight: Radius.circular(10.w_pt_cj),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.all(15.w_pt_cj),
              child: Text(
                "取消",
                style: TextStyle(
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.f_pt_cj,
                  color: widget.normalTextColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w_pt_cj),
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.bold,
                fontSize: 16.f_pt_cj,
                color: widget.normalTextColor,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_itemModels.isEmpty) {
                return;
              }
              Navigator.pop(context);
              widget.onSubmit.call(_itemModels[_currentSelectedIndex]);
            },
            child: Padding(
              padding: EdgeInsets.all(15.w_pt_cj),
              child: Text(
                "完成",
                style: TextStyle(
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.f_pt_cj,
                  color: widget.okTitleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 选择列表
  _renderPickerList() {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 44.h_pt_cj,
      diameterRatio: 10,
      magnification: 1,
      squeeze: 1,
      useMagnifier: false,
      selectionOverlay: Container(
        height: 48.h_pt_cj,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: const Color(0xffdddddd),
              width: 1.w_pt_cj,
            ),
          ),
        ),
      ),
      onSelectedItemChanged: (int index) {
        _currentSelectedIndex = index;
        _textColorStreamController.sink.add(index);
      },
      children: _itemModels.map((T element) {
        return _renderListItem(element);
      }).toList(),
    );
  }

  StreamBuilder<int> _renderListItem(element) {
    var index = _itemModels.indexOf(element);
    return StreamBuilder<int>(
      stream: _textColorStreamController.stream,
      initialData: _currentSelectedIndex,
      builder: (context, snapshot) {
        return SizedBox(
          height: 48.h_pt_cj,
          width: 375.w_pt_cj,
          child: Center(
            child: Text(
              element.name,
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                fontSize: 13.f_pt_cj,
                color: snapshot.data == index
                    ? widget.itemSelectedTextColor
                    : widget.itemNormalTextColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
