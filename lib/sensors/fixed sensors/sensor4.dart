import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sensor4(),
    );
  }
}

class Sensor4 extends StatefulWidget {
  const Sensor4({Key? key}) : super(key: key);

  @override
  State<Sensor4> createState() => _Sensor4State();
}

class _Sensor4State extends State<Sensor4> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription<Event>? _streamSubs;
  late double sensor4data;
  String a = ''; // Declare the variable
  double time = 19;

  @override
  void initState() {
    chartData = getChartData();
    super.initState();
    _activateListeners();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDE5),
        appBar: AppBar(
          elevation: 0.0,
          title: Center(
            child: Text(
              'Air Monitoring',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 4.0,
              ),
            ),
          ),
          backgroundColor: const Color(0xFFC78441),
        ),
        body: SfCartesianChart(
          series: <LineSeries<LiveData, double>>[
            LineSeries<LiveData, double>(
              onRendererCreated: (ChartSeriesController controller) {
                _chartSeriesController = controller;
              },
              dataSource: chartData,
              color: const Color.fromRGBO(192, 108, 132, 1),
              xValueMapper: (LiveData sales, _) => sales.time,
              yValueMapper: (LiveData sales, _) => sales.speed,
              markerSettings: MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
                height: 5,
                width: 5,
                color: Colors.red,
              ),
            ),
          ],
          primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 3,
              title: AxisTitle(text: 'Time (seconds)')),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              title: AxisTitle(text: 'Combustible Gas (PPM)')),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubs?.cancel();
    super.dispose();
  }

  void _activateListeners() {
    _streamSubs = databaseReference
        .child('drone_sensor')
        .onValue
        .listen((Event event) {
      Map<dynamic, dynamic> droneSensorData =
      event.snapshot.value as Map<dynamic, dynamic>;

      // Access latest value from sensor1
      Map<dynamic, dynamic> sensor4Data = droneSensorData['sensor4'] as Map<dynamic, dynamic>;
      dynamic latestSensor4Value = sensor4Data.values.last;

      setState(() {
        a = '$latestSensor4Value';
        sensor4data = double.parse(a);
        chartData.add(LiveData(time++, sensor4data));
        chartData.removeAt(0);
        _chartSeriesController.updateDataSource(
            addedDataIndex: chartData.length - 1, removedDataIndex: 0);
      });
    });
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, 0),
      LiveData(6, 0),
      LiveData(7, 0),
      LiveData(8, 0),
      LiveData(9, 0),
      LiveData(10, 0),
      LiveData(11, 0),
      LiveData(12, 0),
      LiveData(13, 0),
      LiveData(14, 0),
      LiveData(15, 0),
      LiveData(16, 0),
      LiveData(17, 0),
      LiveData(18, 0),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final num speed;
}
