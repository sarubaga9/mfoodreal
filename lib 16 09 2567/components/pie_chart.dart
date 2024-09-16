// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import 'dart:math';

import 'package:m_food/model/TeamGoal.dart';

class HalfDonut extends StatelessWidget {
  final List<charts.Series<dynamic,String>> seriesList;
  final bool animate;
  final String formPage;


  const HalfDonut(this.seriesList, {this.animate =false,this.formPage = 'home'});

  factory HalfDonut.simpleData() {
    return HalfDonut(
      _createSimple(),
      animate: false,
    );
  }

  static List<charts.Series<TeamGoal, String>> _createSimple() {
    Map<String, TeamGoal> chartData;

    chartData = {
      'sell':
          TeamGoal(charts.ColorUtil.fromDartColor(Colors.blue), 'sell', 0),
      'goal': TeamGoal(
          charts.ColorUtil.fromDartColor(const Color(0xFFf1f1f1)), 'goal', 100)
    };

    return [
      charts.Series(
        id: 'teamgoal',
        domainFn: (TeamGoal data, i) => data.text,
        measureFn: (TeamGoal data, i) => data.total,
        colorFn: (TeamGoal data, i) => data.color,
        labelAccessorFn: (TeamGoal data, u) => data.text,
        data: chartData.values.toList(),

      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("formPage${formPage}");
    if(formPage=='margin5'){
      // print('sss');
      return charts.PieChart(

        seriesList,
        animate: animate,

        defaultRenderer: charts.ArcRendererConfig<Object>(
            arcWidth: 35, startAngle: pi, arcLength: pi
        ),
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(7),
          topMarginSpec: charts.MarginSpec.fixedPixel(7),
          rightMarginSpec: charts.MarginSpec.fixedPixel(7),
          bottomMarginSpec:charts.MarginSpec.fixedPixel(7),
        ),
      );
    }else if(formPage=='margin0'){
      print('sss');
      return charts.PieChart(

        seriesList,
        animate: animate,

        defaultRenderer: charts.ArcRendererConfig<Object>(
            arcWidth: 30, startAngle: pi, arcLength: pi
        ),
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
        ),
      );
    }
    else{
      print('jakelse');
      return charts.PieChart(
        seriesList,
        animate: animate,
          defaultRenderer: charts.ArcRendererConfig<Object>(
            customRendererId: 'pie',
            arcWidth: 30,
            startAngle: pi,
            arcLength: pi,
          ),

      );
      // return PieChart(
      //   PieChartData(
      //
      //     startDegreeOffset: 90,
      //     sectionsSpace: 2,
      //     centerSpaceRadius: 100,
      //     sections: [
      //       PieChartSectionData(
      //         color: kPrimaryColor,
      //         value: 50,
      //         title: '',
      //         radius: 100,
      //
      //         titleStyle: TextStyle(
      //           fontSize: 0,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //       PieChartSectionData(
      //         color: Colors.grey,
      //         value: 40,
      //         title: '',
      //         radius: 100,
      //         titleStyle: TextStyle(
      //           fontSize: 0,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //     ],
      //
      //   ),
      //   swapAnimationDuration: Duration(milliseconds: 150), // Optional
      //   swapAnimationCurve: Curves.linear, //
      //
      // );
      return Container(
        child: Text('sss'),
      );

    }

  }
}

class CeoPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final bool enableLabel;
  final bool horizontalFirst;

  const CeoPieChart(this.seriesList,
      {this.animate = false , this.enableLabel = false, this.horizontalFirst = false});

  factory CeoPieChart.withSampleData() {
    return CeoPieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  static List<charts.Series<TeamGoal, String>> _createSampleData() {
    final data = [
      TeamGoal(charts.ColorUtil.fromDartColor(Colors.grey), 'เงินสด', 5),
      TeamGoal(charts.ColorUtil.fromDartColor(Colors.green), 'เครดิต', 15),
    ];

    return [
      charts.Series<TeamGoal, String>(
        id: 'Sales',
        domainFn: (TeamGoal sales, _) => sales.text,
        measureFn: (TeamGoal sales, _) => sales.total,
        colorFn: (TeamGoal sales, _) => sales.color,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (enableLabel) {
      return charts.PieChart(
        seriesList,
        animate: animate,
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.bottom,
            outsideJustification: charts.OutsideJustification.middleDrawArea,
            horizontalFirst: horizontalFirst,
            desiredMaxRows: 2,
          )
        ],
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
        ),
        defaultRenderer: charts.ArcRendererConfig(
            arcRendererDecorators: [charts.ArcLabelDecorator()]),
      );
    } else {
      return charts.PieChart(
        seriesList,
        animate: animate,
        //behaviors: [new charts.DatumLegend()],
        layoutConfig: charts.LayoutConfig(
          leftMarginSpec: charts.MarginSpec.fixedPixel(0),
          topMarginSpec: charts.MarginSpec.fixedPixel(0),
          rightMarginSpec: charts.MarginSpec.fixedPixel(0),
          bottomMarginSpec:charts.MarginSpec.fixedPixel(0),
        ),
      );
    }
  }
}