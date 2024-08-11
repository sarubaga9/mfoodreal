import 'package:flutter/material.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';

class ColorsListPage extends StatefulWidget {
  ColorsListPage(
      {super.key, required this.color, required this.title, this.onPush});
  final MaterialColor color;
  final String title;
  final ValueChanged<int>? onPush;

  @override
  State<ColorsListPage> createState() => _ColorsListPageState();
}

class _ColorsListPageState extends State<ColorsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
          ),
          backgroundColor: widget.color,
        ),
        body: Container(
          color: Colors.white,
          child: _buildList(),
        ));
  }

  final List<int> materialIndices = [
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100,
    50
  ];

  Widget _buildList() {
    return ListView.builder(
        itemCount: materialIndices.length,
        itemBuilder: (BuildContext content, int index) {
          int materialIndex = materialIndices[index];
          return Container(
            color: widget.color[materialIndex],
            child: ListTile(
              title: Text('$materialIndex',
                  style: const TextStyle(fontSize: 24.0)),
              trailing: const Icon(Icons.chevron_right),
              // onTap: () => onPush?.call(materialIndex),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => A0101HomeWidget(),
                  )),
            ),
          );
        });
  }
}
