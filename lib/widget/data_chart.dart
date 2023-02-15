import 'package:doccano_flutter/models/label.dart';
import 'package:doccano_flutter/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataChart extends StatelessWidget {
  final Map<String, dynamic>? data;
  final List<Label>? fetchedLabels;

  const DataChart(this.data,this.fetchedLabels, {super.key});

  @override
  Widget build(BuildContext context) {
    
    
    TooltipBehavior toolTipBehavior = TooltipBehavior(enable: true);

    
    // Create a list of data for the chart
    final chartData = data?.entries.map((entry) => ChartData(entry.key, entry.value)).toList().reversed.toList();

    // Create a chart with the data and customize its appearance
    return SfCartesianChart(
      title: ChartTitle(text: 'PROJECT SPAN DISTRIBUTION'),
      tooltipBehavior: toolTipBehavior,
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        title: AxisTitle(text: 'SPANS')
      ),
      series: [
        BarSeries<ChartData, String>(
          name: 'SPAN',
          dataSource: chartData ?? List.generate(0, (index) => ChartData('', 0)),
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          enableTooltip: true,
          pointColorMapper: (ChartData data, _) {
            if(fetchedLabels?.isNotEmpty ?? false){
              for ( int i = 0; i < fetchedLabels!.length; i++){
                if(fetchedLabels?[i].text == data.category){
                  return Color(hexStringToInt(fetchedLabels![i].backgroundColor!));
                }
              }
            } else {
              return null;
            }
            return null;
            
          }
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final int value;

  ChartData(this.category, this.value);
}