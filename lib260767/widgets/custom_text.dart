import 'package:flutter/material.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';

//สร้าง Custom text class เพื่อใช้เรียกได้สะดวก
class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final String? fontFamily;

  const CustomText({
    Key? key,
    this.text,
    this.size,
    this.color,
    this.weight,
    this.overflow,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Kanit',
            color: color ??Colors.blue.shade900,
            fontSize: 16.0,
          ),
    );
  }
}
