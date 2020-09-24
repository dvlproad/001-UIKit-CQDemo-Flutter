import 'package:flutter/cupertino.dart';

class RoundImage extends StatelessWidget {
  final double size;

  final String networkSrc;

  RoundImage({
    Key key,
    this.size,
    this.networkSrc =
        'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        this.networkSrc,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
