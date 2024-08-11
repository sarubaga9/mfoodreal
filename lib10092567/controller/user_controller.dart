import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxMap<String, dynamic>? userData = <String, dynamic>{}.obs;

  RxMap<String, dynamic>? employeeData = <String, dynamic>{}.obs;

  void resetUserDataToDefault() {
    userData!.value = {};
  }

  void updateEmpoyeeDataInUserAppointment(
      List<Map<String, dynamic>> appointment) async {
    await FirebaseFirestore.instance
        .collection('1000')
        .doc('Company')
        .collection('User')
        .doc(userData!['UserID'])
        .update(
      {
        'UserTokenID': appointment,
        // 'UserAppointment': userMap['UserAppointment'],
      },
    );
  }

    void updateUserHistory(
      List stringHistory,List dateHistory) async {
    await FirebaseFirestore.instance
        .collection('1000')
        .doc('Company')
        .collection('User')
        .doc(userData!['UserID'])
        .update(
      {
        'สินค้าที่เคยสั่ง': stringHistory,
        'สินค้าที่เคยสั่ง_วันที่': dateHistory,
        // 'UserAppointment': userMap['UserAppointment'],
      },
    );
  }

  Future<void> updateUserDataPhone(
    DocumentSnapshot<Map<String, dynamic>>? data,
  ) async {
    // DateTime convertTimestampToDateTime(Timestamp timestamp) {
    //   return timestamp.toDate();
    // }

    if (data!.data() != null
        // && data.data()!.isNotEmpty
        ) {
      final Map<String, dynamic> userMap = data.data() as Map<String, dynamic>;
      // for (int i = 0; i < userMap['UserAppointment'].length; i++) {
      //   print('em phone');
      //   print(i);
      //   Map<String, dynamic>? employeeMap;
      //   await FirebaseFirestore.instance
      //       .collection('1000')
      //       .doc('Company')
      //       .collection('User')
      //       .doc(userMap['UserAppointment'][i]['EmployeeID'])
      //       .get()
      //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
      //     if (value.data() != null && value.data()!.isNotEmpty) {
      //       employeeMap = value.data() as Map<String, dynamic>;
      //       // employeeMap.forEach((key, value) {
      //       //   employeeData![key] = value;
      //       // });
      //     }
      //   });

      //   var userAppointment = userMap['UserAppointment'][i];
      //   DateTime date = convertTimestampToDateTime(userAppointment['Date']);
      //   DateTime statusDate =
      //       convertTimestampToDateTime(userAppointment['StatusDate']);
      //   DateTime dateAddData =
      //       convertTimestampToDateTime(userAppointment['DateAddData']);
      //   DateTime employeeConfirmDate =
      //       convertTimestampToDateTime(userAppointment['EmployeeConfirmDate']);
      //   DateTime goCustomerHomeDateTime = convertTimestampToDateTime(
      //       userAppointment['GoCustomerHomeDateTime']);

      //   userMap['UserAppointment'][i] = {
      //     'DateAddData': dateAddData,
      //     'UserTokenID': userMap['UserAppointment'][i]['UserTokenID'],
      //     'StatusDate': statusDate,
      //     'Latitude': userMap['UserAppointment'][i]['Latitude'],
      //     'Longitude': userMap['UserAppointment'][i]['Longitude'],
      //     'UserAppointmentID': userMap['UserAppointment'][i]
      //         ['UserAppointmentID'],
      //     'Number': userMap['UserAppointment'][i]['Number'],
      //     'UserCharactorRecord': userMap['UserAppointment'][i]
      //         ['UserCharactorRecord'],
      //     'Date': date,
      //     'Star': userMap['UserAppointment'][i]['Star'],
      //     'Status': userMap['UserAppointment'][i]['Status'],
      //     'Detail': userMap['UserAppointment'][i]['Detail'],
      //     'EmployeeConfirm': userMap['UserAppointment'][i]['EmployeeConfirm'],
      //     'EmployeeConfirmDate': employeeConfirmDate,
      //     'Address': userMap['UserAppointment'][i]['Address'],
      //     'NameAddress': userMap['UserAppointment'][i]['NameAddress'],
      //     'SurwayOrAppointment': userMap['UserAppointment'][i]
      //         ['SurwayOrAppointment'],
      //     //=============================================
      //     'EmployeeID': employeeMap!['UserID'],
      //     'Employee': '${employeeMap!['Name']} ${employeeMap!['Surname']}',
      //     'EmployeePhone': employeeMap!['Phone'],
      //     'ImageEmployee': employeeMap!['Img'],
      //     'GoCustomerHome': userMap['UserAppointment'][i]['GoCustomerHome'],
      //     'GoCustomerHomeDateTime': goCustomerHomeDateTime,
      //   };
      // }

      // await FirebaseFirestore.instance
      //     .collection('1000')
      //     .doc('Company')
      //     .collection('User')
      //     .doc(userMap['UserID'])
      //     .update(
      //   {
      //     'UserAppointment': userMap['UserAppointment'],
      //   },
      // );

      // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      // print('APNS Token: $apnsToken');

      // userMap['Level'] == 'User'
      //     ? await FirebaseMessaging.instance.subscribeToTopic('User')
      //     : print('is Employee');

      // userMap['Level'] == 'Employee'
      //     ? await FirebaseFirestore.instance
      //         .collection('1000')
      //         .doc('Company')
      //         .collection('User')
      //         .doc(userMap['UserID'])
      //         .collection('Employee')
      //         .doc(userMap['UserID'])
      //         .get()
      //         .then((DocumentSnapshot<Map<String, dynamic>> value) {
      //         final Map<String, dynamic> employeeMap =
      //             data.data() as Map<String, dynamic>;
      //         employeeMap.forEach((key, value) {
      //           employeeData![key] = value;
      //         });
      //         print('Employee Update');
      //       })
      //     : resetEmployeeDataToDefault();

      // print('phone login');

      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // String token = '';

      await messaging.getToken().then((valueToken) async {
        userMap.forEach((key, value) async {
          if (key == 'UserTokenID') {
            value = valueToken;
            // print(value);

            await FirebaseFirestore.instance
                .collection('User')
                .doc(userMap['UserID'])
                .update(
              {
                'UserTokenID': value,
                'DateUpdate' : DateTime.now()
                // 'UserAppointment': userMap['Level'] == 'User'
                //     ? userMap['UserAppointment']
                //     : [],
              },
            );
          }
          userData![key] = value;
          // if (key == 'UserAppointment') {}
        });
      });
      // print('token');
      // List<dynamic> dynamicList =
      //     userMap['UserAppointment']; // ข้อมูลเริ่มต้นที่เป็น List<dynamic>
      // List<Map<String, dynamic>> mapList =
      //     List<Map<String, dynamic>>.from(dynamicList);
      // updateEmpoyeeDataInUserAppointment(mapList);
    } else {
      print('reset user');
      resetUserDataToDefault();
    }

    // print(userData);

    print('user update');
  }

  updateUserDataUsername(Map<String, dynamic>? userMap) async {
    // print('updateUser');

    // DateTime convertTimestampToDateTime(Timestamp timestamp) {
    //   // print(timestamp.toString());
    //   return timestamp.toDate();
    // }

    if (userMap != null && userMap.isNotEmpty) {
      // FirebaseMessaging messaging = FirebaseMessaging.instance;

      // String token = '';
      print('username login');

      // print('suptopic');
      // String? apnsToken = await messaging.getAPNSToken();
      // print('APNS Token: $apnsToken');
      // userMap['Level'] == 'User'
      //     ? await messaging.subscribeToTopic("User")
      //     : print('is Employee');
      // print('in 123');

      // messaging.requestPermission();
      // print('in 321');
      // for (int i = 0; i < userMap['UserAppointment'].length; i++) {
      //   print(i);
      //   print(userMap['UserAppointment'].length);
      //   print('2232323232');
      //   print(userMap['UserAppointment'][i]['EmployeeID']);
      //   Map<String, dynamic>? employeeMap;
      //   await FirebaseFirestore.instance
      //       .collection('1000')
      //       .doc('Company')
      //       .collection('User')
      //       .doc(userMap['UserAppointment'][i]['EmployeeID'])
      //       .get()
      //       .then((DocumentSnapshot<Map<String, dynamic>> value) {
      //     if (value.data() != null && value.data()!.isNotEmpty) {
      //       employeeMap = value.data() as Map<String, dynamic>;
      //       // employeeMap.forEach((key, value) {
      //       //   employeeData![key] = value;
      //       // });
      //       // print('vvvvvvvvvvvvvvvvvvvvv');
      //       // print(employeeMap!['UserID']);
      //     }
      //   });

      //   // print(userMap['UserAppointment'][i]['Date']);

      //   var userAppointment = userMap['UserAppointment'][i];
      //   DateTime date = convertTimestampToDateTime(userAppointment['Date']);
      //   print('1');
      //   DateTime statusDate =
      //       convertTimestampToDateTime(userAppointment['StatusDate']);
      //   print('2');
      //   DateTime dateAddData =
      //       convertTimestampToDateTime(userAppointment['DateAddData']);
      //   print('3');
      //   DateTime employeeConfirmDate =
      //       convertTimestampToDateTime(userAppointment['EmployeeConfirmDate']);
      //   print('4');

      //   DateTime goCustomerHomeDateTime = convertTimestampToDateTime(
      //       userAppointment['GoCustomerHomeDateTime']);
      //   print('5');

      //   // print(date.toString());
      //   // print(statusDate.toString());
      //   // print(dateAddData.toString());
      //   // print(employeeConfirmDate.toString());
      //   // print('update Em555555');
      //   // print('${employeeMap!['Name']} ${employeeMap!['Surname']}');
      //   // print('22222');
      //   // print(userMap['UserAppointment'][i]['GoCustomerHome']);

      //   userMap['UserAppointment'][i] = {
      //     'DateAddData': dateAddData,
      //     'UserTokenID': userMap['UserAppointment'][i]['UserTokenID'],
      //     'StatusDate': statusDate,
      //     'Latitude': userMap['UserAppointment'][i]['Latitude'],
      //     'Longitude': userMap['UserAppointment'][i]['Longitude'],
      //     'UserAppointmentID': userMap['UserAppointment'][i]
      //         ['UserAppointmentID'],
      //     'Number': userMap['UserAppointment'][i]['Number'],
      //     'UserCharactorRecord': userMap['UserAppointment'][i]
      //         ['UserCharactorRecord'],
      //     'Date': date,
      //     'Star': userMap['UserAppointment'][i]['Star'],
      //     'Status': userMap['UserAppointment'][i]['Status'],
      //     'Detail': userMap['UserAppointment'][i]['Detail'],
      //     'EmployeeConfirm': userMap['UserAppointment'][i]['EmployeeConfirm'],
      //     'EmployeeConfirmDate': employeeConfirmDate,
      //     'Address': userMap['UserAppointment'][i]['Address'],
      //     'NameAddress': userMap['UserAppointment'][i]['NameAddress'],
      //     'SurwayOrAppointment': userMap['UserAppointment'][i]
      //         ['SurwayOrAppointment'],
      //     //=============================================
      //     'EmployeeID': employeeMap!['UserID'],
      //     'Employee': '${employeeMap!['Name']} ${employeeMap!['Surname']}',
      //     'EmployeePhone': employeeMap!['Phone'],
      //     'ImageEmployee': employeeMap!['Img'],
      //     'GoCustomerHome': userMap['UserAppointment'][i]['GoCustomerHome'],
      //     'GoCustomerHomeDateTime': goCustomerHomeDateTime,
      //   };
      // }
      // await messaging.getToken().then((valueToken) async {
        // print(valueToken);
        userMap.forEach((key, value) async {
          // print(key);
          // print(value);

          if (key == 'UserTokenID') {
            // value = valueToken;
            print(value);

            await FirebaseFirestore.instance
                // .collection('1000')
                // .doc('Company')
                .collection('User')
                .doc(userMap['UserID'])
                .update(
              {
                // 'UserTokenID': value,
                'DateUpdate' : DateTime.now()
                // 'UserAppointment': userMap['Level'] == 'User'
                //     ? userMap['UserAppointment']
                //     : [],
                // 'UserAppointment': userMap['UserAppointment'],
              },
            );
          }
          userData![key] = value;
          // if (key == 'UserAppointment' && userMap['Level'] == 'User') {}
        });
      // });
      // userMap.forEach((key, value) {
      //   userData![key] = value;
      // });
//       List<dynamic> dynamicList =
//           userMap['UserAppointment']; // ข้อมูลเริ่มต้นที่เป็น List<dynamic>
//       List<Map<String, dynamic>> mapList =
//           List<Map<String, dynamic>>.from(dynamicList);

// // ตอนนี้คุณมี mapList ที่เป็น List<Map<String, dynamic>>

//       updateEmpoyeeDataInUserAppointment(mapList);
    } else {
      print('reset user');
      resetUserDataToDefault();
    }
    // print(userData);
    print('user update');
  }

  void resetEmployeeDataToDefault() async {
    try {
      await FirebaseFirestore.instance
          .collection('1000')
          .doc('Company')
          .collection('User')
          .doc(userData!['UserID'])
          .collection('Employee')
          .doc(userData!['UserID'])
          .set({
        'EmployeeCode': 'xxxx-xxxxx-xxx',
        'EmployeeAppointment': [],
        'EmployeeAppointmentSurWayHome': [],
        'EmployeeEquipment': [],
        'EmployeePayRecordMonth': [],
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    employeeData!.value = {
      'EmployeeCode': 'xxxx-xxxxx-xxx',
      'EmployeeAppointment': [],
      'EmployeeAppointmentSurWayHome': [],
      'EmployeeEquipment': [],
      'EmployeePayRecordMonth': [],
    };
    print('reset Employee Data');
  }

  Future<void> updateEmployeeData(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
        
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> employeeMap =
          data.data() as Map<String, dynamic>;
      employeeMap.forEach((key, value) {
        employeeData![key] = value;
      });
    } else {
      resetEmployeeDataToDefault();
      print('reset Employee Data');
    }
    // print(employeeData);
    print('Employee Update');
  }
}
