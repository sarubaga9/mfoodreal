import 'dart:io' show Platform;

import 'package:dart_ping/dart_ping.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class WidgetService {
  void checkSpeedInternet(context) async {
    final ping = Ping('google.com', count: 5);

    // Begin ping process and listen for output
    var sumAvgSpeed = 0.0;
    ping.stream.listen((event) {
      print('jak ping ${event.toMap()}');
      if (event.toMap()['response'] != null) {
        if (event.toMap()['response']['time'] != null) {
          sumAvgSpeed += event.toMap()['response']['time']!;
        }
      }
      if (event.summary != null) {
        print('sumAvgSpeed ${sumAvgSpeed / 5}');
        var avgSpeed = sumAvgSpeed / 5;
        var internetSpeedText = 'normal';
        if (avgSpeed > 150) {
          internetSpeedText = 'slow';
          QuickAlert.show(
            context: context,
            title: 'ความเร็วอินเตอร์เน็ตของคุณช้ามาก\nแนะนำให้หาพื้นที่ที่มีอินเทอร์เน็ตเร็วกว่านี้ครับ',
            type: QuickAlertType.warning,
            // confirmButtonText: 'ฉันเข้าใจแล้ว',
            // onConfirm: (isConfirm) {
            //   if (isConfirm) {
            //     Navigator.pop(context);
            //   }
            // },
            // onDispose: () {
            //
            //   print('onDispose');
            // },
          );
        }
      }
    });
  }

  void checkSpeedInternetSnackbar(context) async {
    final ping = Ping('google.com', count: 5);

    // Begin ping process and listen for output
    var sumAvgSpeed = 0.0;
    ping.stream.listen((event) {
      print('jak ping ${event.toMap()}');
      if (event.toMap()['response'] != null) {
        if (event.toMap()['response']['time'] != null) {
          sumAvgSpeed += event.toMap()['response']['time']!;
        }
      }
      if (event.summary != null) {
        print('sumAvgSpeed ${sumAvgSpeed / 5}');
        var avgSpeed = sumAvgSpeed / 5;
        var internetSpeedText = 'normal';
        if (avgSpeed > 150) {
          internetSpeedText = 'slow';
          showTopSnackBar(
            context,
            displayDuration: Duration(seconds: 10),
            CustomSnackBar.error(
              message: "อินเทอร์เน็ตของคุณช้ามาก!!! \nแนะนำ: ให้หาพื้นที่ที่อินเทอร์เน็ตเร็วกว่านี้ครับ",
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
              backgroundColor: Colors.red.shade800,
            ),
          );

          // final snackBar = SnackBar(
          //   content: const Text('เน็ตของคุณช้ามาก!!! แนะนำให้ ปิดอินเทอร์เน็ต ไปเลย แล้วใช้งานในโหมดออฟไลน์ครับ'),
          //
          //   action: SnackBarAction(
          //     label: 'ฉันเข้าใจแล้ว',
          //     onPressed: () {
          //       // Some code to undo the change.
          //     },
          //
          //   ),
          //
          // );
          //
          // // Find the ScaffoldMessenger in the widget tree
          // // and use it to show a SnackBar.
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });
  }

  // void checkOpenGPS(context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     // alert(context,
  //     //     title: Text('ไม่สามารถเข้าถึงตำแหน่งได้'),
  //     //     content: Text('กรุณาเปิดใช้งานตำแหน่งที่ตั้งในการตั้งค่าอุปกรณ์'));
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       // alert(context,
  //       //     title: Text('ไม่สามารถเข้าถึงตำแหน่งได้'),
  //       //     content: Text(
  //       //         'กรุณาอนุญาตให้แอปเข้าถึงตำแหน่งที่ตั้งสามารถตั้งค่าได้ที่การตั้งค่าอุปกรณ์'));
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     // alert(context,
  //     //     title: Text('ไม่สามารถเข้าถึงตำแหน่งได้'),
  //     //     content: Text(
  //     //         'กรุณาอนุญาตให้แอปเข้าถึงตำแหน่งที่ตั้งสามารถตั้งค่าได้ที่การตั้งค่าอุปกรณ์'));
  //     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   Position location = await Geolocator.getCurrentPosition();
  // }

  Future<String> checkSpeedInternetReturnString() async {
    final ping = Ping('google.com', count: 5);
    var sumAvgSpeed = 0.0;
    var arr = [];
    var internetSpeedText = 'slow';
    await ping.stream.listen((event) {
      if (event.toMap()['response'] != null) {
        if (event.toMap()['response']['time'] != null) {
          sumAvgSpeed += event.toMap()['response']['time']!;
          arr.add(event.toMap()['response']['time']!);
        }
      }
      if (event.summary != null) {
        var avgSpeed = sumAvgSpeed / 5;

        if (avgSpeed > 150) {
          internetSpeedText = 'slow';
        } else {
          internetSpeedText = 'normal';
        }
      }
    });
    return internetSpeedText;
  }
}
