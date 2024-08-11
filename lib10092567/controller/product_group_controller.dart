import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductGroupController extends GetxController {
  RxMap<String, dynamic>? productGroupData = <String, dynamic>{}.obs;

  void resetProcductDataToDefault() {
    productGroupData!.value = {};
  }

  // สร้างเมธอดเพื่ออัปเดตข้อมูลผู้ใช้D
  Future<void> updateProductGroupData(
      QuerySnapshot<Map<String, dynamic>>? data) async {
    if (data != null && data.docs.isNotEmpty) {
      // แปลงข้อมูลจาก QuerySnapshot เป็น Map
      Map<String, dynamic> productMap = {};
      for (int index = 0; index < data.docs.length; index++) {
        final Map<String, dynamic> docData =
            data.docs[index].data() as Map<String, dynamic>;
        // print('123');
        // print(docData);

        productMap['key${index}'] = docData;
      }

      productMap.forEach((key, value) {
        productGroupData![key] = value;
      });
    }
  }

  Future<void> updateProductDataDoc(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> productMap =
          data.data() as Map<String, dynamic>;
      productGroupData!.addAll(productMap);
    }
  }
}
