import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textbutton.dart';
import 'report_upload_description_tableviewcell.dart';

class ReportDetailUploadPage extends StatefulWidget {
  ReportDetailUploadPage({Key key, this.reportTypeSting, this.reportReasonString}) : super(key: key);

  final String reportTypeSting;
  final String reportReasonString;


  @override
  State<StatefulWidget> createState() {
    return _ReportDetailUploadPageState();
  }
}

class _ReportDetailUploadPageState extends State<ReportDetailUploadPage> {
  String reportText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportTypeSting),
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: reportList(),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ThemeBGButton(
                  text: "提交",
                  enable: true,
                  enableOnPressed: _uploadReport
              ),
            )
          ],
        )


      ),
    );
  }

  Widget reportList() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: ListView(
        children: <Widget>[
          ReportDescriptionTableViewCell(
            reportReasonString: widget.reportReasonString,
            textChangeCallback: (text)=>{
//            print("listen text:" + reportText)
              reportText = text
            },
          ),
        ],
      ),
    );
  }

  _uploadReport() {
    print("最后提交的内容为:" + reportText);
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return MyMainPage();
//    }));
  }
}