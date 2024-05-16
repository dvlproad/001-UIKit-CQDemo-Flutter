import 'package:flutter/material.dart';

class LocationInput extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChange;

  const LocationInput({
    required this.controller,
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocationInputState();
}

class LocationInputState extends State<LocationInput> {
  late FocusNode focusNode = FocusNode();
  late TextEditingController textEditingController = widget.controller;
  bool isEmptyInput = true;

  @override
  void initState() {
    super.initState();
    isEmptyInput = textEditingController.text.isEmpty;
  }

  hideAllPanel() {
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // final I18nUtils ttBuild = I18nUtils(context);
    return Container(
      height: 72,
      transform: Matrix4.translationValues(0, -10, 0),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: TextField(
                onChanged: (value) async {
                  final isEmpty = value.isEmpty;
                  setState(() {
                    isEmptyInput = isEmpty ? true : false;
                  });
                  widget.onChange(value);
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                maxLines: 4,
                minLines: 1,
                focusNode: focusNode,
                controller: textEditingController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: hexToColor("717171"),
                  ),
                  fillColor: const Color(0xFFEDEDED),
                  filled: true,
                  isDense: true,
                  hintText: "搜索地点",
                  prefixIcon: Icon(
                    Icons.search,
                    color: hexToColor("717171"),
                  ),
                ),
              ),
            ),
          ),
          if (!isEmptyInput)
            Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    textEditingController.text = "";
                    setState(() {
                      isEmptyInput = true;
                    });
                    widget.onChange("");
                  },
                  child: const Text(
                    "取消", // "cancel"
                    style: TextStyle(
                      color: Color(0xFF999999),
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  Color hexToColor(String hexString) {
    return Color(int.parse(hexString, radix: 16)).withAlpha(255);
  }
}
