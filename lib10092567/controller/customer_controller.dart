import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  RxMap<String, dynamic>? customerData = <String, dynamic>{}.obs;

  void resetCustomerDataToDefault() {
    customerData!.value = {};
  }

  // สร้างเมธอดเพื่ออัปเดตข้อมูลผู้ใช้D
  Future<void> updateCustomerData(QuerySnapshot<Map<String, dynamic>>? data) async {
    if (data != null && data.docs.isNotEmpty) {
      // แปลงข้อมูลจาก QuerySnapshot เป็น Map
      Map<String, dynamic> customerMap = {};
      //     data.docs.first.data() as Map<String, dynamic>;

      // print(data.docs.length);
      for (int index = 0; index < data.docs.length; index++) {
        final Map<String, dynamic> docData =
            data.docs[index].data() as Map<String, dynamic>;

        customerMap['key${index}'] = docData;
      }

      customerMap.forEach((key, value) {
        customerData![key] = value;
      });
    }
    // print('update customer Complete');
  }

  Future<void> updatecustomerDataDoc(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> customerMap =
          data.data() as Map<String, dynamic>;
      // customerMap.forEach((key, value) {
      customerData!.addAll(customerMap);
      // print(customerData!.values);
      // });
    }
    // else {
    //   resetcustomerDataToDefault();
    // }

    // print(customerData!['key7']);
    // print('customer update');
  }
}
