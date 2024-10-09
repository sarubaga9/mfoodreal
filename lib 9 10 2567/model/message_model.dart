import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MessageModel {
  final String senderID;
  final String receiverID;
  final String message;
  final DateTime sentTime;
  // final MessageType messageType;
  final String messageType;

  MessageModel({
    required this.senderID,
    required this.receiverID,
    required this.sentTime,
    required this.message,
    required this.messageType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        receiverID: json['receiverID'],
        senderID: json['senderID'],
        sentTime: DateTime.parse(json['sentTime'].toDate().toString()),
        message: json['message'],
        // messageType: MessageType.fromJson(json['messageType']),
        messageType: json['messageType'],
      );

  Map<String, dynamic> toJson() => {
        'receiverID': receiverID,
        'senderID': senderID,
        'sentTime': sentTime,
        'message': message,
        // 'messageType': messageType.toJson(),
        'messageType': messageType,
      };
}

enum MessageType {
  text,
  image;

  String toJson() => name;

  static MessageType fromJson(String json) {
    if (json == 'text') {
      return MessageType.text;
    } else if (json == 'image') {
      return MessageType.image;
    } else {
      throw ArgumentError('Invalid MessageType: $json');
    }
  }
}

class UserAppointmentSurwayHome {
  final String userAppointmentHomeID;
  final String number;
  final DateTime date;
  final bool status;
  final DateTime statusDate;
  final String detail;
  final String employee;
  final String employeePhone;
  final String employeeConfirm;
  final DateTime employeeConfirmDate;
  final String address;
  final String lat;
  final String lot;
  final String nameAddress;
  final String imageEmployee;

  UserAppointmentSurwayHome({
    required this.userAppointmentHomeID,
    required this.number,
    required this.date,
    required this.status,
    required this.statusDate,
    required this.detail,
    required this.employee,
    required this.employeePhone,
    required this.employeeConfirm,
    required this.employeeConfirmDate,
    required this.address,
    required this.lat,
    required this.lot,
    required this.nameAddress,
    required this.imageEmployee,
  });
  factory UserAppointmentSurwayHome.fromJson(Map<String, dynamic> json) {
    return UserAppointmentSurwayHome(
      userAppointmentHomeID: json['UserAppointmentHomeID'] as String,
      number: json['Number'] as String,
      date: (json['Date'] as Timestamp).toDate(),
      status: json['Status'] as bool,
      statusDate: (json['StatusDate'] as Timestamp).toDate(),
      detail: json['Detail'] as String,
      employee: json['Employee'] as String,
      employeePhone: json['EmployeePhone'] as String,
      employeeConfirm: json['EmployeeConfirm'] as String,
      employeeConfirmDate: (json['EmployeeConfirmDate'] as Timestamp).toDate(),
      address: json['Address'] as String,
      lat: json['Lat'] as String,
      lot: json['Lot'] as String,
      nameAddress: json['NameAddress'] as String,
      imageEmployee: json['ImageEmployee'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserAppointmentHomeID': userAppointmentHomeID,
      'Number': number,
      'Date': date,
      'Status': status,
      'StatusDate': statusDate,
      'Detail': detail,
      'Employee': employee,
      'EmployeePhone': employeePhone,
      'EmployeeConfirm': employeeConfirm,
      'EmployeeConfirmDate': employeeConfirmDate,
      'Address': address,
      'Lat': lat,
      'Lot': lot,
      'NameAddress': nameAddress,
      'ImageEmployee': imageEmployee,
    };
  }
}

class UserAppointment {
  final String userAppointmentID;
  final String number;
  final DateTime date;
  final bool status;
  final DateTime statusDate;
  final String detail;
  final String employeeID;
  final String employee;
  final String employeePhone;
  final String employeeConfirm;
  final DateTime employeeConfirmDate;
  final String userTokenID;
  final String latitude;
  final String longitude;
  final String address;
  final String nameAddress;
  final String imageEmployee;
  final DateTime dateAddData;
  final bool surwayOrAppointment;
  final String userCharactorRecord;
  final bool? goCustomerHome;
  final DateTime? goCustomerHomeDateTime;
  final String star;
  final CustomerPayConfirm? customerPayConfirm;

  UserAppointment({
    required this.userTokenID,
    required this.userAppointmentID,
    required this.number,
    required this.date,
    required this.status,
    required this.statusDate,
    required this.detail,
    required this.employeeID,
    required this.employee,
    required this.employeePhone,
    required this.employeeConfirm,
    required this.employeeConfirmDate,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.nameAddress,
    required this.imageEmployee,
    required this.dateAddData,
    required this.surwayOrAppointment,
    required this.userCharactorRecord,
    required this.goCustomerHome,
    required this.goCustomerHomeDateTime,
    required this.star,
    required this.customerPayConfirm,
  });

  factory UserAppointment.fromJson(Map<String, dynamic> json) {
    return UserAppointment(
      userAppointmentID: json['UserAppointmentID'] as String,
      userTokenID: json['UserTokenID'] as String,
      number: json['Number'] as String,
      date: (json['Date'] as Timestamp).toDate(),
      status: json['Status'] as bool,
      statusDate: (json['StatusDate'] as Timestamp).toDate(),
      detail: json['Detail'] as String,
      employeeID: json['EmployeeID'] as String,
      employee: json['Employee'] as String,
      employeePhone: json['EmployeePhone'] as String,
      employeeConfirm: json['EmployeeConfirm'] as String,
      employeeConfirmDate: (json['EmployeeConfirmDate'] as Timestamp).toDate(),
      address: json['Address'] as String,
      latitude: json['Latitude'] as String,
      longitude: json['Longitude'] as String,
      nameAddress: json['NameAddress'] as String,
      imageEmployee: json['ImageEmployee'] as String,
      dateAddData: (json['DateAddData'] as Timestamp).toDate(),
      surwayOrAppointment: json['SurwayOrAppointment'] as bool,
      userCharactorRecord: json['UserCharactorRecord'] as String,
      goCustomerHome: json['GoCustomerHome'] as bool,
      goCustomerHomeDateTime: DateTime.parse(json['AdminConfirmDate']),
      star: json['Star'] as String,
      customerPayConfirm:
          CustomerPayConfirm.fromJson(json['CustomerPayConfirm']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserAppointmentID': userAppointmentID,
      'UserTokenID': userTokenID,
      'Number': number,
      'Date': date,
      'Status': status,
      'StatusDate': statusDate,
      'Detail': detail,
      'EmployeeID': employeeID,
      'Employee': employee,
      'EmployeePhone': employeePhone,
      'EmployeeConfirm': employeeConfirm,
      'EmployeeConfirmDate': employeeConfirmDate,
      'Address': address,
      'Latitude': latitude,
      'Longitude': longitude,
      'NameAddress': nameAddress,
      'ImageEmployee': imageEmployee,
      'DateAddData': dateAddData,
      'SurwayOrAppointment': surwayOrAppointment,
      'UserCharactorRecord': userCharactorRecord,
      'GoCustomerHome': goCustomerHome,
      'GoCustomerHomeDateTime': goCustomerHomeDateTime,
      'Star': star,
      'CustomerPayConfirm': customerPayConfirm?.toJson(),
    };
  }
}

class EmployeeAppointment {
  final String? employeeTokenID;
  final String? employeeAppointmentID;
  final String? number;
  final String? totalNumber;
  final DateTime? date;
  final DateTime? dateFinish;
  final bool? status;
  final DateTime statusDate;
  final String? detail;
  final String? customerID;
  final String? customerName;
  final String? customerAppointmentID;
  final String? customerPhone;
  final String? adminNameConfirm;
  final DateTime? adminConfirmDate;
  final String? customerLatitude;
  final String? customerLongitude;
  final String? customerAddress;
  final String? customerNameAddress;
  final bool? customerPdpaConfirm;
  final String? customerPDPAImg;
  final AppointmentRecord? appointmentRecord;
  final CustomerPayConfirm? customerPayConfirm;
  final bool? surwayOrAppointment;
  final bool? goCustomerHome;
  final DateTime? goCustomerHomeDateTime;

  EmployeeAppointment({
    this.employeeTokenID,
    this.employeeAppointmentID,
    this.number,
    this.totalNumber,
    this.date,
    this.dateFinish,
    this.status,
    required this.statusDate,
    this.detail,
    this.customerID,
    this.customerAppointmentID,
    this.customerName,
    this.customerPhone,
    this.adminNameConfirm,
    this.adminConfirmDate,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAddress,
    this.customerNameAddress,
    this.customerPDPAImg,
    this.customerPdpaConfirm,
    this.appointmentRecord,
    this.customerPayConfirm,
    this.surwayOrAppointment,
    this.goCustomerHome,
    this.goCustomerHomeDateTime,
  });

  factory EmployeeAppointment.fromJson(Map<String, dynamic> json) {
    return EmployeeAppointment(
      employeeAppointmentID: json['EmployeeAppointmentID'],
      number: json['Number'],
      employeeTokenID: json['EmployeeTokenID'],
      totalNumber: json['TotalNumber'],
      date: DateTime.parse(json['Date']),
      dateFinish: DateTime.parse(json['DateFinish']),
      status: json['Status'],
      statusDate: (json['StatusDate'] as Timestamp).toDate(),
      detail: json['Detail'],
      customerID: json['CustomerID'],
      customerAppointmentID: json['CustomerAppointmentID'],
      customerName: json['CustomerName'],
      customerPhone: json['CustomerPhone'],
      adminNameConfirm: json['AdminNameConfirm'],
      adminConfirmDate: DateTime.parse(json['AdminConfirmDate']),
      customerLatitude: json['CustomerLatitude'],
      customerLongitude: json['CustomerLongitude'],
      customerAddress: json['CustomerAddress'],
      customerNameAddress: json['CustomerNameAddress'],
      customerPDPAImg: json['CustomerPDPAImg'],
      customerPdpaConfirm: json['CustomerPdpaConfirm'],
      appointmentRecord: AppointmentRecord.fromJson(json['AppointmentRecord']),
      customerPayConfirm:
          CustomerPayConfirm.fromJson(json['CustomerPayConfirm']),
      surwayOrAppointment: json['SurwayOrAppointment'] as bool,
      goCustomerHome: json['GoCustomerHome'] as bool,
      goCustomerHomeDateTime: DateTime.parse(json['AdminConfirmDate']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'EmployeeAppointmentID': employeeAppointmentID,
  //     'Number': number,
  //     'TotalNumber': totalNumber,
  //     'Date': date!,
  //     'DateFinish': dateFinish,
  //     'Status': status,
  //     'StatusDate': statusDate,
  //     'Detail': detail,
  //     'CustomerID': customerID,
  //     'CustomerName': customerName,
  //     'CustomerPhone': customerPhone,
  //     'AdminNameConfirm': adminNameConfirm,
  //     'AdminConfirmDate': adminConfirmDate!,
  //     'CustomerLatitude': customerLatitude,
  //     'CustomerLongitude': customerLongitude,
  //     'CustomerAddress': customerAddress,
  //     'CustomerNameAddress': customerNameAddress,
  //     'CustomerPDPAImg': customerPDPAImg,
  //     'CustomerPdpaConfirm': customerPdpaConfirm,
  //     'AppointmentRecord': appointmentRecord!.toJson(),
  //     'CustomerPayConfirm': customerPayConfirm!.toJson(),
  //   };
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SurwayOrAppointment'] = surwayOrAppointment;
    data['EmployeeTokenID'] = employeeTokenID;
    data['EmployeeAppointmentID'] = employeeAppointmentID;
    // print(data['EmployeeAppointmentID']);
    data['Number'] = number;
    // print(data['Number']);
    data['TotalNumber'] = totalNumber;
    // print(data['TotalNumber']);
    data['Date'] = date;
    // print(data['Date']);
    data['DateFinish'] = dateFinish;
    // print(data['DateFinish']);
    data['Status'] = status;
    // print(data['Status']);
    data['StatusDate'] = statusDate;
    // print(data['StatusDate']);
    data['Detail'] = detail;
    // print(data['Detail']);
    data['CustomerID'] = customerID;
    data['CustomerAppointmentID'] = customerAppointmentID;
    // print(data['CustomerID']);
    data['CustomerName'] = customerName;
    // print(data['CustomerName']);
    data['CustomerPhone'] = customerPhone;
    // print(data['CustomerPhone']);
    data['AdminNameConfirm'] = adminNameConfirm;
    // print(data['AdminNameConfirm']);
    data['AdminConfirmDate'] = adminConfirmDate;
    // print(data['AdminConfirmDate']);
    data['CustomerLatitude'] = customerLatitude;
    // print(data['CustomerLatitude']);
    data['CustomerLongitude'] = customerLongitude;
    // print(data['CustomerLongitude']);
    data['CustomerAddress'] = customerAddress;
    // print(data['CustomerAddress']);
    data['CustomerNameAddress'] = customerNameAddress;
    // print(data['CustomerNameAddress']);
    data['CustomerPDPAImg'] = customerPDPAImg;
    // print(data['CustomerPDPAImg']);
    data['CustomerPdpaConfirm'] = customerPdpaConfirm;
    // print(data['CustomerPdpaConfirm']);
    data['AppointmentRecord'] = appointmentRecord?.toJson();
    // print(data['AppointmentRecord']);
    data['CustomerPayConfirm'] = customerPayConfirm?.toJson();
    // print(data['CustomerPayConfirm']);
    // print('--------------------------------------------------');
    data['GoCustomerHome'] = goCustomerHome;
    data['GoCustomerHomeDateTime'] = goCustomerHomeDateTime;

    return data;
  }
}

class AppointmentRecord {
  String? homeWidth;
  String? homeLength;
  String? areaSize;
  String? homeHeight;
  String? homeCount;
  String? areaTotal;
  String? date;
  String? customerConfirmPay;
  String? appointmentTotal;
  String? firstDate;
  List<String>? workImage;
  String? customerAppointmentPDPA;
  bool? recordConfirm;

  AppointmentRecord({
    this.homeWidth,
    this.homeLength,
    this.areaSize,
    this.homeHeight,
    this.homeCount,
    this.areaTotal,
    this.date,
    this.customerConfirmPay,
    this.appointmentTotal,
    this.firstDate,
    this.workImage,
    this.customerAppointmentPDPA,
    this.recordConfirm,
  });

  factory AppointmentRecord.fromJson(Map<String, dynamic> json) {
    return AppointmentRecord(
      homeWidth: json['HomeWidth'],
      homeLength: json['HomeLength'],
      areaSize: json['AreaSize'],
      homeHeight: json['HomeHeight'],
      homeCount: json['HomeCount'],
      areaTotal: json['AreaTotal'],
      date: json['Date'],
      customerConfirmPay: json['CustomerConfirmPay'],
      appointmentTotal: json['AppointmentTotal'],
      firstDate: json['FirstDate'],
      workImage: List<String>.from(json['WorkImage']),
      customerAppointmentPDPA: json['CustomerAppointmentPDPA'],
      recordConfirm: json['RecordConfirm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'HomeWidth': homeWidth,
      'HomeLength': homeLength,
      'AreaSize': areaSize,
      'HomeHeight': homeHeight,
      'HomeCount': homeCount,
      'AreaTotal': areaTotal,
      'Date': date!,
      'CustomerConfirmPay': customerConfirmPay,
      'AppointmentTotal': appointmentTotal,
      'FirstDate': firstDate,
      'WorkImage': List<dynamic>.from(workImage!),
      'CustomerAppointmentPDPA': customerAppointmentPDPA,
      'RecordConfirm': recordConfirm,
    };
  }
}

class CustomerPayConfirm {
  String? payTotal;
  DateTime? payDate;
  List<String>? payImage;
  bool? payStatus;
  String? gbQrcode;
  bool? adminConfirmStatusPay;

  CustomerPayConfirm({
    this.payTotal,
    this.payDate,
    this.payImage,
    this.payStatus,
    this.gbQrcode,
    this.adminConfirmStatusPay,
  });

  factory CustomerPayConfirm.fromJson(Map<String, dynamic> json) {
    return CustomerPayConfirm(
      payTotal: json['PayTotal'],
      payDate: DateTime.parse(json['PayDate']),
      payImage: List<String>.from(json['PayImage']),
      payStatus: json['PayStatus'],
      adminConfirmStatusPay: json['AdminConfirmStatusPay'],
      gbQrcode: json['GbQrcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PayTotal': payTotal,
      'PayDate': payDate!,
      'PayImage': List<dynamic>.from(payImage!),
      'PayStatus': payStatus,
      'AdminConfirmStatusPay': adminConfirmStatusPay,
      'GbQrcode': gbQrcode,
    };
  }
}

class Equipment {
  String equipmentID;
  String equipmentName;
  String equipmentDetail;
  String equipmentImage;
  String equipmentCount;

  Equipment({
    required this.equipmentID,
    required this.equipmentName,
    required this.equipmentDetail,
    required this.equipmentImage,
    required this.equipmentCount,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      equipmentID: json['EquipmentID'] ?? '',
      equipmentName: json['EquipmentName'] ?? '',
      equipmentDetail: json['EquipmentDetail'] ?? '',
      equipmentImage: json['EquipmentImage'] ?? '',
      equipmentCount: json['EquipmentCount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EquipmentID': equipmentID,
      'EquipmentName': equipmentName,
      'EquipmentDetail': equipmentDetail,
      'EquipmentImage': equipmentImage,
      'EquipmentCount': equipmentCount,
    };
  }
}

class EmployeeEquipment {
  DateTime? date;
  String employeeEquipmentID;
  String employeeTokenID;
  bool status;
  List<Equipment> equipment;
  bool surwayOrAppointment;
  String employeeAppointmentID;
  String customerName;
  String customerNameAddress;

  EmployeeEquipment({
    required this.date,
    required this.customerName,
    required this.employeeTokenID,
    required this.employeeEquipmentID,
    required this.status,
    required this.equipment,
    required this.surwayOrAppointment,
    required this.employeeAppointmentID,
    required this.customerNameAddress,
  });

  factory EmployeeEquipment.fromJson(Map<String, dynamic> json) {
    final List<dynamic> equipmentData = json['Equipment'] ?? [];
    final List<Equipment> parsedEquipment = equipmentData
        .map((equipmentJson) => Equipment.fromJson(equipmentJson))
        .toList();

    return EmployeeEquipment(
      date: DateTime.parse(json['Date']),
      customerName: json['CustomerName'] ?? '',
      employeeTokenID: json['EmployeeTokenID'] ?? '',
      employeeEquipmentID: json['EmployeeEquipmentID'] ?? '',
      status: json['Status'] ?? false,
      equipment: parsedEquipment,
      surwayOrAppointment: json['SurwayOrAppointment'] ?? false,
      employeeAppointmentID: json['EmployeeAppointmentID'] ?? '',
      customerNameAddress: json['CustomerNameAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> equipmentData =
        equipment.map((e) => e.toJson()).toList();

    return {
      'Date': date,
      'CustomerName': customerName,
      'CustomerNameAddress': customerNameAddress,
      'EmployeeEquipmentID': employeeEquipmentID,
      'Status': status,
      'Equipment': equipmentData,
      'SurwayOrAppointment': surwayOrAppointment,
      'EmployeeAppointmentID': employeeAppointmentID,
      'EmployeeTokenID': employeeTokenID,
    };
  }
}
