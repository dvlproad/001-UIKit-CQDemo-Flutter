library flutter_json_widget;

import 'package:flutter/material.dart';
import './json_text_widget.dart';

class BaseJsonViewer extends StatefulWidget {
  final dynamic jsonObj;

  BaseJsonViewer(
    this.jsonObj, {
    super.key,
    required void Function(dynamic value) onTap,
    required void Function(dynamic value) onDoubleTap,
    required void Function(dynamic value) onLongPress,
  }) {
    JSONText.onTap = onTap;
    JSONText.onDoubleTap = onDoubleTap;
    JSONText.onLongPress = onLongPress;
  }

  @override
  _BaseJsonViewerState createState() => _BaseJsonViewerState();
}

class _BaseJsonViewerState extends State<BaseJsonViewer> {
  @override
  Widget build(BuildContext context) {
    return getContentWidget(widget.jsonObj);
  }

  static Widget getContentWidget(dynamic content) {
    if (content == null) {
      return const Text('{}');
    } else if (content is List) {
      return JsonArrayViewer(content, notRoot: false);
    } else {
      return JsonObjectViewer(content, notRoot: false);
    }
  }
}

class JsonObjectViewer extends StatefulWidget {
  // final Map<String, dynamic> jsonObj; // 不使用此方式,限制泛型,防止外部写Map的时候不支持
  final Map jsonObj;
  final bool notRoot;

  const JsonObjectViewer(
    this.jsonObj, {
    super.key,
    this.notRoot = false,
  });

  @override
  JsonObjectViewerState createState() => JsonObjectViewerState();
}

class JsonObjectViewerState extends State<JsonObjectViewer> {
  Map<String, bool> openFlag = {};

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: _getList()),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  _getList() {
    List<Widget> list = [];
    for (MapEntry entry in widget.jsonObj.entries) {
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ex
              ? ((openFlag[entry.key] ?? false)
                  ? Icon(Icons.arrow_drop_down,
                      size: 14, color: Colors.grey[700])
                  : Icon(Icons.arrow_right, size: 14, color: Colors.grey[700]))
              : const Icon(
                  Icons.arrow_right,
                  color: Color.fromARGB(0, 0, 0, 0),
                  size: 14,
                ),
          (ex && ink)
              ? InkWell(
                  child: Text(entry.key,
                      style: TextStyle(color: Colors.purple[900])),
                  onTap: () {
                    setState(() {
                      openFlag[entry.key] = !(openFlag[entry.key] ?? false);
                    });
                  })
              : Text(entry.key,
                  style: TextStyle(
                      color: entry.value == null
                          ? Colors.grey
                          : Colors.purple[900])),
          const Text(
            ':',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 3),
          getValueWidget(entry)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[entry.key] ?? false) {
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  static getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewer(content, notRoot: true);
    } else {
      return JsonObjectViewer(content, notRoot: true);
    }
  }

  static isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is List) {
      if (content.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  getValueWidget(MapEntry entry) {
    if (entry.value == null) {
      return const Expanded(
          child: JSONText(
        'undefined',
        style: TextStyle(color: Colors.grey),
        value: 'undefined',
      ));
    } else if (entry.value is int) {
      return Expanded(
          child: JSONText(
        entry.value.toString(),
        style: const TextStyle(color: Colors.teal),
        value: entry.value,
      ));
    } else if (entry.value is String) {
      return Expanded(
          child: JSONText(
        // ignore: unnecessary_string_escapes
        '\"' + entry.value + '\"',
        style: const TextStyle(color: Colors.redAccent),
        value: entry.value,
      ));
    } else if (entry.value is bool) {
      return Expanded(
          child: JSONText(
        entry.value.toString(),
        style: const TextStyle(color: Colors.purple),
        value: entry.value,
      ));
    } else if (entry.value is double) {
      return Expanded(
          child: JSONText(
        entry.value.toString(),
        style: const TextStyle(color: Colors.teal),
        value: entry.value,
      ));
    } else if (entry.value is List) {
      if (entry.value.isEmpty) {
        return const JSONText(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
          value: 'Array[0]',
        );
      } else {
        return InkWell(
            child: JSONText(
              'Array<${getTypeName(entry.value[0])}>[${entry.value.length}]',
              style: const TextStyle(color: Colors.grey),
              value: entry.value,
            ),
            onTap: () {
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key] ?? false);
              });
            });
      }
    }
    return InkWell(
        child: JSONText(
          'Object',
          style: const TextStyle(color: Colors.grey),
          value: entry.value,
        ),
        onTap: () {
          setState(() {
            openFlag[entry.key] = !(openFlag[entry.key] ?? false);
          });
        });
  }

  static isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    }
    return 'Object';
  }
}

class JsonArrayViewer extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  const JsonArrayViewer(
    this.jsonArray, {
    super.key,
    this.notRoot = false,
  });

  @override
  _JsonArrayViewerState createState() => _JsonArrayViewerState();
}

class _JsonArrayViewerState extends State<JsonArrayViewer> {
  late List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  @override
  void initState() {
    super.initState();
    openFlag = List.filled(widget.jsonArray.length, false);
  }

  _getList() {
    List<Widget> list = [];
    int i = 0;
    for (dynamic content in widget.jsonArray) {
      bool ex = JsonObjectViewerState.isExtensible(content);
      bool ink = JsonObjectViewerState.isInkWell(content);
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ex
              ? ((openFlag[i])
                  ? Icon(Icons.arrow_drop_down,
                      size: 14, color: Colors.grey[700])
                  : Icon(Icons.arrow_right, size: 14, color: Colors.grey[700]))
              : const Icon(
                  Icons.arrow_right,
                  color: Color.fromARGB(0, 0, 0, 0),
                  size: 14,
                ),
          (ex && ink)
              ? getInkWell(i)
              : Text('[$i]',
                  style: TextStyle(
                      color:
                          content == null ? Colors.grey : Colors.purple[900])),
          const Text(
            ':',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 3),
          getValueWidget(content, i)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[i]) {
        list.add(JsonObjectViewerState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  getInkWell(int index) {
    return InkWell(
        child: Text('[$index]', style: TextStyle(color: Colors.purple[900])),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }

  getValueWidget(dynamic content, int index) {
    if (content == null) {
      return const Expanded(
          child: Text(
        'undefined',
        style: TextStyle(color: Colors.grey),
      ));
    } else if (content is int) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (content is String) {
      return Expanded(
          child: Text(
        // ignore: unnecessary_string_escapes
        '\"' + content + '\"',
        style: const TextStyle(color: Colors.redAccent),
      ));
    } else if (content is bool) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.purple),
      ));
    } else if (content is double) {
      return Expanded(
          child: Text(
        content.toString(),
        style: const TextStyle(color: Colors.teal),
      ));
    } else if (content is List) {
      if (content.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
            child: Text(
              'Array<${JsonObjectViewerState.getTypeName(content)}>[${content.length}]',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              setState(() {
                openFlag[index] = !(openFlag[index]);
              });
            });
      }
    }
    return InkWell(
        child: const Text(
          'Object',
          style: TextStyle(color: Colors.grey),
        ),
        onTap: () {
          setState(() {
            openFlag[index] = !(openFlag[index]);
          });
        });
  }
}
