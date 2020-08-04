import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-bubble/bubble_widget.dart';

class GuideOverlayEntryFactory1 {
  void addGuideOverlayEntrys(BuildContext context) {
    List<OverlayEntry> overlayEntryList = List<OverlayEntry>();
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    OverlayEntry overlayBackgroundEntry;
    OverlayEntry overlayEntry1, overlayEntry2, overlayEntry3;

    var overIndex = 4;
    overlayBackgroundEntry = OverlayEntry(builder: (context) {
      return Stack(children: <Widget>[
        GestureDetector(
            onTap: () {
              --overIndex;
              if (overIndex == 3) {
                overlayEntry1.remove();
                overlayEntryList.removeLast();
                Overlay.of(context).insert(overlayEntry2);
              } else if (overIndex == 2) {
                overlayEntry2.remove();
                Overlay.of(context).insert(overlayEntry3);
              } else if (overIndex == 1) {
                overlayEntry3.remove();
                overlayBackgroundEntry.remove();
                overlayEntryList.removeLast();
              }
            },
            child: Container(color: Colors.black.withOpacity(0.4)))
      ]);
    });

    overlayEntry1 = OverlayEntry(builder: (context) {
      return Stack(children: <Widget>[
        Positioned(
            top: 75,
            left: width - 185.0,
            child: GestureDetector(
                onTap: () {
                  --overIndex;
                  overlayEntry1.remove();
                  overlayEntryList.removeLast();
                  Overlay.of(context).insert(overlayEntry2);
                },
                child: _itemGuideTop()))
      ]);
    });
    overlayEntryList.add(overlayBackgroundEntry);
    overlayEntryList.add(overlayEntry1);

    overlayEntry2 = OverlayEntry(builder: (context) {
      return Stack(children: <Widget>[
        Positioned(
            bottom: 105,
            right: 80,
            child: GestureDetector(
                onTap: () {
                  --overIndex;
                  overlayEntry2.remove();
                  Overlay.of(context).insert(overlayEntry3);
                },
                child: _itemGuideRight()))
      ]);
    });
    overlayEntry3 = OverlayEntry(builder: (context) {
      return Stack(children: <Widget>[
        Positioned(
            bottom: 85,
            left: (width - 260) * 0.5,
            child: GestureDetector(
                onTap: () {
                  --overIndex;
                  overlayEntry3.remove();
                  overlayBackgroundEntry.remove();
                  overlayEntryList.removeLast();
                },
                child: _itemGuideBottom()))
      ]);
    });

    Overlay.of(context).insertAll(overlayEntryList);
  }

  _itemGuideTop() {
    return Material(
        color: Color.fromARGB(0, 0, 0, 0),
        child: Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Container(
                child: BubbleWidget(
                    180.0,
                    60.0,
                    Colors.deepOrange.withOpacity(0.7),
                    BubbleArrowDirection.top,
                    length: 140.0,
                    child: Text('This is Setting Button!',
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Colors.white, fontSize: 16.0))))));
  }

  _itemGuideRight() {
    return Material(
        color: Color.fromARGB(0, 0, 0, 0),
        child: Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Container(
                child: BubbleWidget(240.0, 50.0, Colors.green.withOpacity(0.7),
                    BubbleArrowDirection.right,
                    child: Text('This is FloatingActionButton!',
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Colors.white, fontSize: 16.0))))));
  }

  _itemGuideBottom() {
    return Material(
        color: Color.fromARGB(0, 0, 0, 0),
        child: Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Container(
                child: BubbleWidget(
                    260.0,
                    80.0,
                    Colors.pinkAccent.withOpacity(0.7),
                    BubbleArrowDirection.bottom,
                    child: Text('This is ACEBottomNavigationBar! \nindex = 3',
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: Colors.white, fontSize: 16.0))))));
  }
}
