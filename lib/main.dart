import 'package:flutter/material.dart';
import 'package:airmonitoring_ui/home.dart';
import 'package:airmonitoring_ui/loading.dart';
import 'package:airmonitoring_ui/sensors/fixed sensors/sensor1.dart';
import 'package:airmonitoring_ui/sensors/fixed sensors/sensor2.dart';
import 'package:airmonitoring_ui/sensors/fixed sensors/sensor3.dart';
import 'package:airmonitoring_ui/sensors/fixed sensors/sensor4.dart';
import 'package:airmonitoring_ui/sensors/drone sensors/sensor5.dart';
import 'package:airmonitoring_ui/sensors/drone sensors/sensor6.dart';
import 'package:airmonitoring_ui/sensors/drone sensors/sensor7.dart';
import 'package:airmonitoring_ui/sensors/drone sensors/sensor8.dart';
import 'package:airmonitoring_ui/status.dart';

void main() async {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/loading': (context) => Loading(),
      '/home': (context) => Home(),
      '/dsensor1': (context) => Sensor1(),
      '/dsensor2': (context) => Sensor2(),
      '/dsensor3': (context) => Sensor3(),
      '/dsensor4': (context) => Sensor4(),
      // '/dsensor5': (context) => sensor5(),
      // '/dsensor6': (context) => sensor6(),
      // '/dsensor7': (context) => sensor7(),
      // '/dsensor8': (context) => sensor8(),
      '/status': (context) => Status(),
    },
  ));
}
