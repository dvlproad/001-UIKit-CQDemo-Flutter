/*
 * @Author: dvlproad
 * @Date: 2022-08-07 16:54:57
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 11:46:24
 * @Description: 
 */
import 'package:flutter/cupertino.dart';

class RoundImage extends StatelessWidget {
  final double size;

  final String networkSrc;

  const RoundImage({
    Key? key,
    required this.size,
    this.networkSrc =
        'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1091405991,859863778&fm=26&gp=0.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        networkSrc,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
