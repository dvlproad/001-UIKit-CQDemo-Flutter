import 'package:flutter/material.dart';
import './darg_widget.dart';
import './draggable_manager.dart';

class DraggablePage1 extends StatelessWidget {
  final GlobalKey _parentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Draggable Floating Action Button'),
      ),
      body: Container(
        child: Stack(
          key: _parentKey,
          children: [
            Container(color: Colors.cyan),
            DraggableFloatingActionButton(
              child: Container(
                width: 60,
                height: 60,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.white,
                ),
                // child: Image.asset("assets/logo.png"),
                child: Text('图片'),
              ),
              initialOffset: const Offset(120, 70),
              // parentKey: _parentKey,
              parentKey: ApplicationDraggableManager.globalKey,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
