import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/main_sub_arrow_tableviewcell.dart';
import 'package:flutter_baseui_kit/cq-uikit/TextView/input_textview.dart';

typedef TextChangeCallback = void Function(String text);

class ReportDescriptionTableViewCell extends StatefulWidget {
  final String reportReasonString;
  final TextChangeCallback textChangeCallback;

  ReportDescriptionTableViewCell(
      {Key key, this.reportReasonString, this.textChangeCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReportDescriptionTableViewCellState();
  }
}

class _ReportDescriptionTableViewCellState
    extends State<ReportDescriptionTableViewCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _reportWidget(),
    );
  }

  Widget _reportWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MainSubArrowTableViewCell(
            text: '举报理由', detailText: widget.reportReasonString),
        MainSubArrowTableViewCell(text: '举报描述(选填)'),
        CQInputTextView(
          placeholder: '请详细描述举报理由',
          maxLength: 200, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
          maxLines: 5,
          textChangeCallback: widget.textChangeCallback,
        )
      ],
    );
  }
}
