import 'package:get/get.dart';

class SharedPreferenceController extends GetxController {
  // สร้าง Reactive Variable เพื่อเก็บค่าของ String
  RxString sharedePreferenceControl =
      "".obs; // obs คือการทำให้ตัวแปรเป็น Reactive

  // เมธอดสำหรับการอัปเดตค่า String
  Future<void> updateString(String newValue) async {
    sharedePreferenceControl.value = newValue;
    // print(sharedePreferenceControl.value);
  }

  // เมื่อคอนโทรลเลอร์ถูกสร้าง
  @override
  void onInit() {
    // กำหนดค่าเริ่มต้นให้ sharedePreferenceControl ที่นี่
    sharedePreferenceControl.value = "ค่าเริ่มต้น";

    super.onInit();
  }
}

// MessageController.dart
// class MessageController extends GetxController {
//   RxString message = "initial_message".obs;

//   void setMessage(String newMessage) {
//     message.value = newMessage;
//     print('-----');
//     print(message.value);
//   }
// }
