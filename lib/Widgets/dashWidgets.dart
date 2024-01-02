import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../components/diversity.dart';
import '../database/database.dart';
import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;

List<Widget> dashWidgets() {
  const txtColor2 = Color(0xFFEDEDED);
  const CardBack = Color.fromARGB(81, 101, 103, 116);
  const attacheColor = Color(0xFFD0AB79);
  const internColor = Color(0xFF86A5A1);
  const empColor = Color(0xFFB67CEC);
  const onleaveColor = Color(0xFFF3CCBE);
  double Wid = 200;
  double CWid = 15;
  double CHei = 15;
  double Hei = 180;
  double scl = 15;
  double loadingSize = 30;
  double fontDataSize = 30;
  return [
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //color:CardBack,
          //color:Colors.transparent,
          color:  CardBack,
        ),
        height: Hei,
        width: Wid,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: empColor,

              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "lib/icons/employees.png",
                  scale: scl,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5.0,left: 5),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Active Employees",
                      style: TextStyle(
                        fontSize: 15,
                        // color: txtColor2
                      ),
                    ),
                  ),

                  FutureBuilder<List<int>>(
                    future: MongoDatabase.connect(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingAnimationWidget.staggeredDotsWave(
                          color: txtColor2,
                          size: loadingSize,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}');
                      } else {
                        final userCount = snapshot.data?[0] ?? 0;
                        final activeCount = snapshot.data?[4] ?? 0;
                        return Text("$activeCount of $userCount",
                            style:  TextStyle(
                              fontSize: fontDataSize,
                              //color: txtColor2
                            ));
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: CardBack,
        ),
        height: Hei,
        width: Wid,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: onleaveColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "lib/icons/leave.png",
                  scale: scl,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0,left: 5),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "On Leave",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),

                  FutureBuilder<List<int>>(
                    future: MongoDatabase.connect(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingAnimationWidget.staggeredDotsWave(
                          color: txtColor2,
                          size: loadingSize,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}');
                      } else {
                        final onLeaveUserCount = snapshot.data?[1] ?? 0;
                        final userCount = snapshot.data?[0] ?? 0;
                        return Text("$onLeaveUserCount of $userCount",
                            style:  TextStyle(
                              fontSize: fontDataSize,
                            ));
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: CardBack
        ),
        height: Hei,
        width: Wid,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: internColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  "lib/icons/graduated.png",
                  scale: scl,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0,left: 5),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Interns",
                      style: TextStyle(
                        fontSize: 15,

                      ),
                    ),
                  ),

                  FutureBuilder<List<int>>(
                    future: MongoDatabase.connect(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingAnimationWidget.staggeredDotsWave(
                          color: txtColor2,
                          size: loadingSize,
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}');
                      } else {
                        final internCount =
                            snapshot.data?[2] ?? 0;
                        return Text("$internCount",
                            style:  TextStyle(
                              fontSize: fontDataSize,
                            ));
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CardBack
          ),
          height: Hei,
          width: Wid,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: attacheColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "lib/icons/graduating-student.png",
                    scale: scl,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 5),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Attaches",
                        style: TextStyle(
                          fontSize: 15,

                        ),
                      ),
                    ),

                    FutureBuilder<List<int>>(
                      future: MongoDatabase.connect(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingAnimationWidget.staggeredDotsWave(
                            color: txtColor2,
                            size: loadingSize,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}');
                        } else {
                          final attacheCount =
                              snapshot.data?[3] ?? 0;
                          return Text("$attacheCount",
                              style:  TextStyle(
                                fontSize: fontDataSize,

                              ));
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CardBack

          ),
          height: Hei,
          width: Wid * 1.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3, // Adjust the flex value as needed to control the width of the chart
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 10),
                      child: Text("Department Diversity",),
                    ),
                    FutureBuilder<List<int>>(
                      future: MongoDatabase.connect(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return LoadingAnimationWidget.staggeredDotsWave(
                            color: txtColor2,
                            size: loadingSize,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {

                          final userCount = snapshot.data?[0] ?? 0;
                          final onLeaveUserCount = snapshot.data?[1] ?? 0;
                          final internCount = snapshot.data?[2] ?? 0;
                          final attacheCount = snapshot.data?[3] ?? 0;

                          return SizedBox(
                            height: 148,
                            child: charts.PieChart<Object>(
                              _createChartSeries(
                                userCount,
                                onLeaveUserCount,
                                internCount,
                                attacheCount,
                              ),
                              animate: true,
                              animationDuration: const Duration(milliseconds: 500),
                              defaultRenderer: charts.ArcRendererConfig(
                                arcWidth: 10,
                                arcRendererDecorators: [

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
              Expanded(
                flex: 3, // Adjust the flex value as needed to control the width of the column
                child: Padding(
                  padding: const EdgeInsets.only(top: 42.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add your percentage values widgets here
                      // Example:
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: empColor,
                              ),
                              height: CHei,
                              width: CWid,
                            ),
                            const SizedBox(width: 4,),
                            Row(
                              children: [
                                FutureBuilder<List<double>>(
                                  future: MongoDatabase.calculatePercentage(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return LoadingAnimationWidget.staggeredDotsWave(
                                        color: txtColor2,
                                        size: loadingSize/3,
                                      );// Replace with your loading widget
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final userPercentage = snapshot.data?[0] ?? 0;
                                      final onLeavePercentage = snapshot.data?[1] ?? 0;
                                      final internPercentage = snapshot.data?[2] ?? 0;
                                      final attachePercentage = snapshot.data?[3] ?? 0;

                                      return Text(
                                        "${userPercentage.toStringAsFixed(0)}%",
                                        style: const TextStyle(fontSize: 15,),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 7,),
                                const Text("Employees",),
                              ],
                            ),
                          ],

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: onleaveColor
                              ),
                              height: CHei,
                              width: CWid,
                            ),
                            const SizedBox(width: 4,),
                            Row(
                              children: [
                                FutureBuilder<List<double>>(
                                  future: MongoDatabase.calculatePercentage(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return LoadingAnimationWidget.staggeredDotsWave(
                                        color: txtColor2,
                                        size: loadingSize/3,
                                      ); // Replace with your loading widget
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final userPercentage = snapshot.data?[0] ?? 0;
                                      final onLeavePercentage = snapshot.data?[1] ?? 0;
                                      final internPercentage = snapshot.data?[2] ?? 0;
                                      final attachePercentage = snapshot.data?[3] ?? 0;

                                      return Text(
                                        "${onLeavePercentage.toStringAsFixed(0)}%",
                                        style: const TextStyle(fontSize: 15,),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 7,),
                                const Text("On Leave", ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: internColor
                              ),
                              height: CHei,
                              width: CWid,
                            ),
                            const SizedBox(width: 4,),
                            Row(
                              children: [
                                FutureBuilder<List<double>>(
                                  future: MongoDatabase.calculatePercentage(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return LoadingAnimationWidget.staggeredDotsWave(
                                        color: txtColor2,
                                        size: loadingSize/3,
                                      ); // Replace with your loading widget
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final userPercentage = snapshot.data?[0] ?? 0;
                                      final onLeavePercentage = snapshot.data?[1] ?? 0;
                                      final internPercentage = snapshot.data?[2] ?? 0;
                                      final attachePercentage = snapshot.data?[3] ?? 0;

                                      return Text(
                                        "${internPercentage.toStringAsFixed(0)}%",
                                        style: const TextStyle(fontSize: 15, ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 7,),
                                const Text("Interns",),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0,),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: attacheColor
                              ),
                              height: CHei,
                              width: CWid,
                            ),
                            const SizedBox(width: 4,),
                            Row(
                              children: [
                                FutureBuilder<List<double>>(
                                  future: MongoDatabase.calculatePercentage(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return LoadingAnimationWidget.staggeredDotsWave(
                                        color: txtColor2,
                                        size: loadingSize/3,
                                      ); // Replace with your loading widget
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final userPercentage = snapshot.data?[0] ?? 0;
                                      final onLeavePercentage = snapshot.data?[1] ?? 0;
                                      final internPercentage = snapshot.data?[2] ?? 0;
                                      final attachePercentage = snapshot.data?[3] ?? 0;

                                      return Text(
                                        "${attachePercentage.toStringAsFixed(0)}%",
                                        style: const TextStyle(fontSize: 15, ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 7,),
                                const Text("Attaches",),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CardBack
          ),
          height: Hei,
          width: Wid-40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('dd').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    // Add more child widgets here
  ];

}
List<charts.Series<CountData, Object>> _createChartSeries(
    int userCount, int onLeaveUserCount, int internCount, int attacheCount) {
  final data = [
    CountData(
      'Users',
      userCount,
      charts.Color.fromHex(code: '#A968EB'), // Custom color for 'Users'
    ),
    CountData(
      'On Leave',
      onLeaveUserCount,
      charts.Color.fromHex(code: '#F2BDAA'), // Custom color for 'On Leave'
    ),
    CountData(
      'Interns',
      internCount,
      charts.Color.fromHex(code: '#739691'), // Custom color for 'Interns'
    ),
    CountData(
      'Attaches',
      attacheCount,
      charts.Color.fromHex(code: '#C1955A'), // Custom color for 'Attaches'
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
