import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription? _streamSubs;
  var value = [];
  String nodata = '0';
  late String sensor1data = nodata,
      sensor2data = nodata,
      sensor3data = nodata,
      sensor4data = nodata,
      sensor5data = nodata,
      sensor6data = nodata,
      sensor7data = nodata,
      sensor8data = nodata;
  bool _canVibrate = true;
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 500),
    const Duration(milliseconds: 1000),
    const Duration(milliseconds: 500),
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _refreshData();
            },
            icon: Icon(
              Icons.refresh,
            ),
            color: Colors.white,
          ),
        ],
        elevation: 0.0,
        title: Center(
          child: Text(
            'Air Monitoring',
            style: TextStyle(
              color: const Color(0xFF000000),
              letterSpacing: 4.0,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFC78441),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[

              status(),
              SizedBox(height: 5.0),
              averagePPM(
                data1: double.parse(sensor1data),
                data2: double.parse(sensor2data),
                data3: double.parse(sensor3data),
                data4: double.parse(sensor4data),
              ),
              DroneSensor(
                data1: double.parse(sensor1data),
                data2: double.parse(sensor2data),
                data3: double.parse(sensor3data),
                data4: double.parse(sensor4data),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override

  void _refreshData() {
    // Retrieve data from Firebase Realtime Database
    databaseReference.child('drone_sensor').once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> droneSensorData = snapshot.value;

      // Access latest value from sensor1
      Map<dynamic, dynamic> sensor1Data = droneSensorData['sensor1'];
      dynamic latestSensor1Value = sensor1Data.values.last;
      setState(() {
        sensor1data = '$latestSensor1Value';
      });
      print(latestSensor1Value);

      // Access latest value from sensor2
      Map<dynamic, dynamic> sensor2Data = droneSensorData['sensor2'];
      dynamic latestSensor2Value = sensor2Data.values.last;
      setState(() {
        sensor2data = '$latestSensor2Value';
      });
      print(latestSensor2Value);

      // Access latest value from sensor3
      Map<dynamic, dynamic> sensor3Data = droneSensorData['sensor3'];
      dynamic latestSensor3Value = sensor3Data.values.last;
      setState(() {
        sensor3data = '$latestSensor3Value';
      });
      print(latestSensor3Value);

      // Access latest value from sensor4
      Map<dynamic, dynamic> sensor4Data = droneSensorData['sensor4'];
      dynamic latestSensor4Value = sensor4Data.values.last;
      setState(() {
        sensor4data = '$latestSensor4Value';
      });
      print(latestSensor4Value);
    });
  }

  @override
  void deactivate() {
    _streamSubs?.cancel();
    super.deactivate();
  }
}

class status extends StatelessWidget {
  const status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/status');
          },
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 30.0,
                width: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFC48C5A),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              Container(
                child: Text('Status',
                  style: TextStyle(
                    color: const Color(0xFFFFFFFF))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class averagePPM extends StatefulWidget {
  final double data1, data2, data3, data4;
  const averagePPM(
      {Key? key,
        required this.data1,
        required this.data2,
        required this.data3,
        required this.data4})
      : super(key: key);

  @override
  State<averagePPM> createState() => _averagePPMState();
}

class _averagePPMState extends State<averagePPM> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Average',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF000000),
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: Align(
            alignment: Alignment.center,
            heightFactor: 1,
            child: average(
                context,
                widget.data1.toString(),
                widget.data2.toString(),
                widget.data3.toString(),
                widget.data4.toString()),
          ),
        ),
      ],
    );
  }

  Widget average(BuildContext context, String data1, String data2, String data3,
      String data4) {
    double mean = (
        double.parse(data1) +
        double.parse(data2) +
        double.parse(data3) +
        double.parse(data4))/4;
        //int.parse(data5) +
        // int.parse(data6) +
        // int.parse(data7) +
        // int.parse(data8)) /

    String meanText = '$mean';
    return colorIndicator(context, meanText);
  }

  Widget colorIndicator(BuildContext context, String data) {
    var a = double.parse(data);
    if (a < 500) {
      return Text(
        data, //data for fixed sensor 4
        style: TextStyle(
          color: const Color(0xFF00FF93),
          fontSize: 80.0,
        ),
      );
    } else if (a >= 500) {
      return Text(
        data, //data for fixed sensor 4
        style: TextStyle(
            color: Colors.red, fontSize: 80.0, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        "Error", //data for fixed sensor 4
        style: TextStyle(
          color: const Color(0xFF00FF93),
          fontSize: 80.0,
        ),
      );
    }
  }
}



class DroneSensor extends StatefulWidget {
  final double data1, data2, data3, data4;
  const DroneSensor({
    Key? key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
  }) : super(key: key);
  @override
  State<DroneSensor> createState() => _DroneSensorState();
}

class _DroneSensorState extends State<DroneSensor> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                child: SfCircularChart(
                  legend: Legend(
                      isVisible: true,
                      iconHeight: 30,
                      iconWidth: 30,
                      title: LegendTitle(
                          text:'Drone Sensor',
                          textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900,

                          )
                      ),
                      // Border color and border width of legend
                  ),
                  // Initialize category axis
                  series: <CircularSeries>[
                    // Initialize line series
                    RadialBarSeries<ChartData2, String>(
                        dataSource: [
                          // Bind data source
                          ChartData2('1', widget.data1),
                          ChartData2('2', widget.data2),
                          ChartData2('3', widget.data3),
                          ChartData2('4', widget.data4)
                        ],
                        xValueMapper: (ChartData2 data, _) => data.a,
                        yValueMapper: (ChartData2 data, _) => data.b,
                        cornerStyle: CornerStyle.endCurve,
                        useSeriesColor: true,
                        trackOpacity: 0.3,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true
                        )
                         ) ,
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
class ChartData2 {
  ChartData2(this.a, this.b);
  final String a;
  final double b;
}

