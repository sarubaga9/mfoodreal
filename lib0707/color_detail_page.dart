import 'package:flutter/material.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';

class ColorDetailPage extends StatelessWidget {
  const ColorDetailPage(
      {super.key,
      required this.color,
      required this.title,
      this.materialIndex = 500});
  final MaterialColor color;
  final String title;
  final int materialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          '$title[$materialIndex]',
        ),
      ),
      body: Container(
        color: color[materialIndex],
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => A0101HomeWidget(),
              )),
          child: Text('data'),
        ),
      ),
    );
  }
}
