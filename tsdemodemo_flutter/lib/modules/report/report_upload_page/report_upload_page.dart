import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_model.dart';
import 'report_upload_description_tableviewcell.dart';

class ReportDetailUploadPage extends StatefulWidget {
  ReportDetailUploadPage({
    Key key,
    @required this.reportTypeId,
    @required this.reportTypeValue,
    @required this.reportTypeDescription,
    this.reportDetailTypeId,
    this.reportDetailTypeDescription,
  }) : super(key: key);

  final String reportTypeId;
  final int reportTypeValue;
  final String reportTypeDescription;

  final String reportDetailTypeId;
  final String reportDetailTypeDescription;

  @override
  State<StatefulWidget> createState() {
    return _ReportDetailUploadPageState();
  }
}

class _ReportDetailUploadPageState extends State<ReportDetailUploadPage> {
  ReportUploadModel _reportUploadtModel = ReportUploadModel();
  String reportDetailTypeReasonDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportTypeDescription ?? ''),
      ),
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            color: Colors.black,
            child: reportListWidget(),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: CQTSThemeBGButton(
              bgColorType: CQTSThemeBGType.pink,
              title: "提交",
              enable: true,
              onPressed: _uploadReport,
            ),
          )
        ],
      )),
    );
  }

  Widget reportListWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        children: <Widget>[
          ReportDescriptionTableViewCell(
            reportReasonString: widget.reportDetailTypeDescription,
            textChangeCallback: (text) {
              print("listen reportDetailTypeReasonDescription:" + text);
              reportDetailTypeReasonDescription = text;
            },
          ),
        ],
      ),
    );
  }

  _uploadReport() {
    print("最后提交的内容为:" + reportDetailTypeReasonDescription);
    _reportUploadtModel
        .requestSubmitReport(widget.reportTypeId, widget.reportTypeValue,
            widget.reportDetailTypeId, reportDetailTypeReasonDescription)
        .then((value) {
      //print('举报成功，返回');
//      Routes.popUntil(context, [widget.fromPage]);
    }).catchError((onError) {
      print("err:${onError.toString()}");
    });
  }
}
