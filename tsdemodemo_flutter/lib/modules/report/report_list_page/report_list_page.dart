import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'report_list.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_page.dart';
import 'package:tsdemodemo_flutter/modules/report/report_list_page/report_list_model.dart';

class ReportListPage extends StatefulWidget {
  final String reportTypeId;
  final int reportTypeValue;
  final String reportTypeDescription;

  ReportListPage({Key key, this.reportTypeId, this.reportTypeValue, this.reportTypeDescription}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  ReportListModel _reportListModel = ReportListModel();
  var sectionModels = [];

  @override
  void dispose() {
    _reportListModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _reportListModel.requestReportList().then((value) {
//    mockRequest_reportList().then((value) => {
      print(value);
      setState(() {
        sectionModels = value;
      });
    }).catchError((onError) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportTypeDescription),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: ReportSectionTableView(
            sectionModels: sectionModels,
            clickReportReasonItemCallback: (reportDetailTypeId, reportDetailTypeDescription)=>{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailUploadPage(
                    reportTypeId: widget.reportTypeId,
                    reportTypeValue: widget.reportTypeValue,
                    reportTypeDescription: widget.reportTypeDescription,
                    reportDetailTypeId: reportDetailTypeId,
                    reportDetailTypeDescription: reportDetailTypeDescription,
                  ),
//                  settings: RouteSettings(arguments: userName),
                ),
              )
            },
          ),
        ),
      ),
    );
  }
}
