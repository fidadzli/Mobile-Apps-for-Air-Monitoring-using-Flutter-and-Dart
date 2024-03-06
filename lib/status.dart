import 'package:flutter/material.dart';
import "dart:async";
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
//import 'package:flutter_vibrate/flutter_vibrate.dart';

String _displayText = 'N/A';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
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
        leading: BackButton(
            color: Colors.white,
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
          child: Text('Air Monitoring',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 4.0,
              )),
        ),
        backgroundColor: const Color(0xFFC78441),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.all(20.0),
                color: const Color(0xFFFFFDE5),
                height: height / 2, //height of the scrollview
                width: width,
                child: Row(
                  children: <Widget>[
                    DroneSensor(
                      data1: double.parse(sensor1data),
                      data2: double.parse(sensor2data),
                      data3: double.parse(sensor3data),
                      data4: double.parse(sensor4data),
                    ),
                    // FixedSensor(
                    //   data1: sensor1data,
                    //   data2: sensor2data,
                    //   data3: sensor3data,
                    //   data4: sensor4data,
                    // ),
                    SizedBox(
                      width: 20.0,
                    ),

                  ],
                ),
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


class DroneSensor extends StatefulWidget {
  final double data1, data2, data3, data4;
  const DroneSensor(
      {Key? key,
        required this.data1,
        required this.data2,
        required this.data3,
        required this.data4})
      : super(key: key);

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
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/dsensor1');
                },
                child: ListTile(
                  title: Text(
                    'DRONE SENSOR 1',
                    style: TextStyle(color: Colors.white,
                        fontSize: 12,
                        height: 2),
                  ),
                  subtitle: colorIndicator(
                      context, widget.data1.toString()),
                  tileColor: const Color(0xFFDC9D5A),
                  trailing: Icon(
                    Icons.sensors_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ), //Drone Sensor 1
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/dsensor2');
                },
                child: ListTile(
                  title: Text(
                    'DRONE SENSOR 2',
                    style: TextStyle(color: Colors.white,
                        fontSize: 12,
                        height: 2),
                  ),
                  subtitle: colorIndicator(
                      context, widget.data2.toString()),
                  tileColor: const Color(0xFFDC9D5A),
                  trailing: Icon(
                    Icons.sensors_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ), //Drone Sensor 2
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/dsensor3');
                },
                child: ListTile(
                  title: Text(
                    'DRONE SENSOR 3',
                    style: TextStyle(color: Colors.white,
                        fontSize: 12,
                        height: 2),
                  ),
                  subtitle: colorIndicator(
                      context, widget.data3.toString()),
                  tileColor: const Color(0xFFDC9D5A),
                  trailing: Icon(
                    Icons.sensors_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ), //Drone Sensor 3
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/dsensor4');
                },
                child: ListTile(
                  title: Text(
                    'DRONE SENSOR 4',
                    style: TextStyle(color: Colors.white,
                        fontSize: 12,
                        height: 2),
                  ),
                  subtitle: colorIndicator(
                      context, widget.data4.toString()),
                  tileColor: const Color(0xFFDC9D5A),
                  trailing: Icon(
                    Icons.sensors_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ), //Drone Sensor 4
        ],
      ),
    );
  }

  Widget colorIndicator(BuildContext context, String data) {
    //String b = data.substring(0, data.indexOf('.'));
    var a = double.parse(data);
    if (a < 500) {
      return Text(
        data, //data for fixed sensor 4
        style: TextStyle(color: const Color(0xFF00FF93),
        ),
      );
    } else if (a >= 500) {
      return Text(
        data, //data for fixed sensor 4
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        "Error", //data for fixed sensor 4
        style: TextStyle(color: const Color(0xFF00FF93)),
      );
    }
  }
}
