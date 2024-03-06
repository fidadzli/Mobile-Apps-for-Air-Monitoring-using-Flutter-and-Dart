import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';

class sensor5 extends StatefulWidget {
  const sensor5({Key? key}) : super(key: key);

  @override
  State<sensor5> createState() => _sensor5State();
}

class _sensor5State extends State<sensor5> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription? _streamSubs;
  late int sensor5data = 0;

  @override
  void initState() {
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
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
            child: Text('Air Monitoring',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 4.0,
                )),
          ),
          backgroundColor: const Color(0xFFC78441),
        ),
        body: SfCartesianChart(
            series: <LineSeries<LiveData, int>>[
              LineSeries<LiveData, int>(
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
                  height : 5,
                  width: 5,
                  color: Colors.red,
                ),
              )
            ],
            primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                interval: 3,
                title: AxisTitle(text: 'Time (seconds)')),
            primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                title: AxisTitle(text: 'Combustible Gas (PPM)'))),
      ),
    );
  }

  void _activateListeners() {
    databaseReference
        .child('drone_sensor/sensor1')
        .orderByKey()
        .onChildAdded
        .listen((event) {
      final int sensor5 = event.snapshot.value;
      setState(() {
        sensor5data = sensor5;
      });
    });
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, sensor5data));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
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
      LiveData(18, 0)
    ];
  }

  @override
  void deactivate() {
    _streamSubs?.cancel();
    super.deactivate();
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}
