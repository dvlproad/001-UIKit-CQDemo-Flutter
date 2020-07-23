import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'report_list.dart';
import 'package:tsdemodemo_flutter/modules/report/report_upload_page/report_upload_page.dart';

class ReportSectionTableViewPage extends StatefulWidget {
  final String title;

  ReportSectionTableViewPage({Key key, this.title}) : super(key: key);

  @override
  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
}

class _CJTSTableHomeBasePageState extends State<ReportSectionTableViewPage> {
  var reportTypeString = '';
  var sectionModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reportTypeString = 'XX举报';
    sectionModels = [
      {
        "id": "650000199703063668",
        "message": "根数基做军示",
        "rows": [
          {
            "id": "440000197702091845",
            "message": "光感大两"
          },
          {
            "id": "360000200702206379",
            "message": "火低示报回"
          },
          {
            "id": "440000199801068033",
            "message": "增科米学主"
          },
          {
            "id": "990000197105043666",
            "message": "运各器段广等传"
          }
        ]
      },
      {
        "id": "120000197504133405",
        "message": "式之都提再心",
        "rows": [
          {
            "id": "120000198910122968",
            "message": "原面以阶她题"
          },
          {
            "id": "810000199407227744",
            "message": "效调最办"
          },
          {
            "id": "520000197408093153",
            "message": "重建往即"
          }
        ]
      },
      {
        "id": "150000200203095636",
        "message": "龙作把养",
        "rows": [
          {
            "id": "610000197506236260",
            "message": "社样按"
          },
          {
            "id": "650000200008199657",
            "message": "带快特究"
          },
          {
            "id": "460000198408081265",
            "message": "最几员之"
          },
          {
            "id": "410000199107077946",
            "message": "什引易正"
          }
        ]
      },
      {
        "id": "510000199509239673",
        "message": "运较才到",
        "rows": [
          {
            "id": "41000020060204352X",
            "message": "进类程"
          },
          {
            "id": "820000199009101670",
            "message": "明观约"
          },
          {
            "id": "540000197006252741",
            "message": "周我属务步接"
          },
          {
            "id": "710000199506307527",
            "message": "设位状张"
          }
        ]
      },
      {
        "id": "810000199609235179",
        "message": "部我总步段风",
        "rows": [
          {
            "id": "510000197207098167",
            "message": "白克不"
          },
          {
            "id": "710000200509292370",
            "message": "水经斗"
          },
          {
            "id": "150000200603037574",
            "message": "如适比深候调"
          }
        ]
      },
      {
        "id": "81000020140222718X",
        "message": "县成确性正观",
        "rows": [
          {
            "id": "360000201610232646",
            "message": "次示党清无原"
          },
          {
            "id": "460000197507184716",
            "message": "程具东步战"
          },
          {
            "id": "82000019720228457X",
            "message": "造县但织又结"
          }
        ]
      },
      {
        "id": "350000197905021634",
        "message": "文指由毛线",
        "rows": [
          {
            "id": "520000197108181135",
            "message": "取须知出社北"
          },
          {
            "id": "520000197001142769",
            "message": "角界王眼几列"
          },
          {
            "id": "120000200911204762",
            "message": "议论已主算高名"
          },
          {
            "id": "31000020081230654X",
            "message": "不四算研严"
          }
        ]
      },
      {
        "id": "62000020150406577X",
        "message": "北化什度特记",
        "rows": [
          {
            "id": "310000197404097537",
            "message": "红公地度局"
          },
          {
            "id": "520000199009093374",
            "message": "战二代速给"
          },
          {
            "id": "310000197401266155",
            "message": "那维外南求"
          },
          {
            "id": "620000199604077022",
            "message": "月克期打约"
          }
        ]
      },
      {
        "id": "330000198612024840",
        "message": "克后白决放",
        "rows": [
          {
            "id": "710000200707275977",
            "message": "着美集身它设"
          },
          {
            "id": "150000198408085562",
            "message": "级也着调县公"
          },
          {
            "id": "650000198007257667",
            "message": "回土比"
          }
        ]
      },
      {
        "id": "710000197007071645",
        "message": "精区切回性在",
        "rows": [
          {
            "id": "460000198301251260",
            "message": "群美新安构"
          },
          {
            "id": "340000200702167054",
            "message": "示大组任有至"
          },
          {
            "id": "430000201008052747",
            "message": "收高路想事"
          }
        ]
      },
      {
        "id": "440000201302162367",
        "message": "流权发何飞",
        "rows": [
          {
            "id": "210000201209105189",
            "message": "要史打派共"
          },
          {
            "id": "210000200604306621",
            "message": "长王族百"
          },
          {
            "id": "510000197912064536",
            "message": "计七完问"
          },
          {
            "id": "710000197312279370",
            "message": "造日明式根越"
          }
        ]
      },
      {
        "id": "650000197602211626",
        "message": "当内花土后们白",
        "rows": [
          {
            "id": "540000199211122953",
            "message": "四层八三号"
          },
          {
            "id": "530000199303240410",
            "message": "织眼空党然从"
          },
          {
            "id": "460000201202022416",
            "message": "被适况"
          },
          {
            "id": "530000199712304139",
            "message": "组行难力后外治"
          }
        ]
      },
      {
        "id": "350000201101217593",
        "message": "克前响片更的",
        "rows": [
          {
            "id": "650000198801171668",
            "message": "元业解况特入"
          },
          {
            "id": "500000201108261464",
            "message": "南联次义米才"
          },
          {
            "id": "520000197907181887",
            "message": "们温百问度"
          },
          {
            "id": "150000201604292977",
            "message": "国建时面平"
          }
        ]
      },
      {
        "id": "320000198410314688",
        "message": "理江成导书",
        "rows": [
          {
            "id": "13000019880812685X",
            "message": "又方平"
          },
          {
            "id": "440000199104231528",
            "message": "达般记经子"
          },
          {
            "id": "22000020120513147X",
            "message": "能王委响半市意"
          },
          {
            "id": "340000200804251476",
            "message": "习术调"
          }
        ]
      },
      {
        "id": "65000019720330442X",
        "message": "造识省京小",
        "rows": [
          {
            "id": "810000201412215422",
            "message": "化出西展"
          },
          {
            "id": "320000198506188460",
            "message": "严平形"
          },
          {
            "id": "610000197601127177",
            "message": "力角连听外办派"
          }
        ]
      },
      {
        "id": "420000199206205327",
        "message": "情拉步直",
        "rows": [
          {
            "id": "990000197302111728",
            "message": "点千人身太整"
          },
          {
            "id": "630000197401031617",
            "message": "值持个多相"
          },
          {
            "id": "220000199311239847",
            "message": "少易会头车"
          }
        ]
      },
      {
        "id": "530000201207238775",
        "message": "开保查系先",
        "rows": [
          {
            "id": "520000199507230431",
            "message": "表我红别"
          },
          {
            "id": "500000199511039759",
            "message": "决规空响"
          },
          {
            "id": "410000200705212381",
            "message": "么风马"
          },
          {
            "id": "150000201904194308",
            "message": "方细型院般场"
          }
        ]
      },
      {
        "id": "310000199310122665",
        "message": "委线走界万",
        "rows": [
          {
            "id": "640000201112045474",
            "message": "阶包效"
          },
          {
            "id": "320000200404172820",
            "message": "法委战百什"
          },
          {
            "id": "650000200101301150",
            "message": "这下何题"
          }
        ]
      },
      {
        "id": "530000199903136887",
        "message": "许即府和写",
        "rows": [
          {
            "id": "210000197707228799",
            "message": "相用做族"
          },
          {
            "id": "150000200302025684",
            "message": "真己与文好技"
          },
          {
            "id": "350000197010262285",
            "message": "较话九对保程"
          },
          {
            "id": "360000198009061087",
            "message": "大的发确"
          }
        ]
      },
      {
        "id": "410000201306217681",
        "message": "高受住传",
        "rows": [
          {
            "id": "540000200709248284",
            "message": "外件济运"
          },
          {
            "id": "810000201712198185",
            "message": "越例从划件江化"
          },
          {
            "id": "21000019790107253X",
            "message": "群个件"
          },
          {
            "id": "630000198612154144",
            "message": "它识小解容效"
          }
        ]
      }
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reportTypeString),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: ReportSectionTableView(
            sectionModels: sectionModels,
            clickReportReasonItemCallback: (reportReasonString)=>{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailUploadPage(
                    reportTypeSting: reportTypeString,
                    reportReasonString: reportReasonString,
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
