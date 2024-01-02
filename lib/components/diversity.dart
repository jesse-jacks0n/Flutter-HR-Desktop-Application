import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../database/database.dart';

class CountData {
  final String label;
  final int count;
  final charts.Color color;

  CountData(this.label, this.count, this.color);
}

class DiversityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diversity Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Employees"),
            SizedBox(height: 10),
            FutureBuilder<List<int>>(
              future: MongoDatabase.connect(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final userCount = snapshot.data?[0] ?? 0;
                  final onLeaveUserCount = snapshot.data?[1] ?? 0;
                  return SizedBox(
                    height: 200,
                    child: charts.PieChart<Object>(
                      _createChartSeries(userCount, onLeaveUserCount) as List<charts.Series<dynamic, Object>>,
                      animate: true,
                      animationDuration: const Duration(milliseconds: 500),
                      defaultRenderer: charts.ArcRendererConfig(
                        arcWidth: 14,
                        arcRendererDecorators: [
                          charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<CountData, Object>> _createChartSeries(
      int userCount, int onLeaveUserCount) {
    final data = [
      CountData(
        'Users',
        userCount,
        charts.MaterialPalette.blue.shadeDefault,
      ),
      CountData(
        'On Leave',
        onLeaveUserCount,
        charts.MaterialPalette.green.shadeDefault,
      ),
    ];

    return [
      charts.Series<CountData, Object>(
        id: 'Counts',
        domainFn: (CountData count, _) => count.label,
        measureFn: (CountData count, _) => count.count,
        colorFn: (CountData count, _) => count.color,
        data: data,
        labelAccessorFn: (CountData count, _) => '${count.count}',
      )
    ];
  }
}
