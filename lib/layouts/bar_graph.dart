import 'package:dict_cat_archives/models/project.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityCountChart extends StatelessWidget {
  final List<Project> data;
  const ActivityCountChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double maxCount = 0;

    for (var project in data) {
      if (project.count! > maxCount) {
        maxCount = project.count!.toDouble();
      }
    }
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData(),
        barGroups: getBarGroups(),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxCount + 2,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Color.fromARGB(180, 0, 83, 184),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 18,
    );

    String text = data.isNotEmpty ? data[value.toInt()].docId : '';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [Colors.cyan, Colors.blue],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> getBarGroups() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < data.length; i++) {
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
              width: data.length.toDouble(),
              toY: data[i].count!.toDouble(),
              gradient: _barsGradient),
        ],
        showingTooltipIndicators: [0],
      ));
    }

    return barGroups;
  }
}

class ActivityChart extends StatefulWidget {
  final List<Project> project;
  const ActivityChart({super.key, required this.project});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<ActivityChart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ActivityCountChart(data: widget.project),
    );
  }
}
