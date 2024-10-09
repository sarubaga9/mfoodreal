import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxMap<String, dynamic>? productData = <String, dynamic>{}.obs;

  void resetProcductDataToDefault() {
    productData!.value = {};
  }

  // สร้างเมธอดเพื่ออัปเดตข้อมูลผู้ใช้D
  Future<void> updateProcutData(
      QuerySnapshot<Map<String, dynamic>>? data) async {
    if (data != null && data.docs.isNotEmpty) {
      // แปลงข้อมูลจาก QuerySnapshot เป็น Map
      Map<String, dynamic> productMap = {};
      for (int index = 0; index < data.docs.length; index++) {
        final Map<String, dynamic> docData =
            data.docs[index].data() as Map<String, dynamic>;

        productMap['key${index}'] = docData;
      }
      // List<Map<String, dynamic>> list = [];

      productMap.forEach((key, value) {
        productData![key] = value;

        // list.add(value);
      });
    }
  }

  Future<void> updateProductDataDoc(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> productMap =
          data.data() as Map<String, dynamic>;
      productData!.addAll(productMap);
    }
  }
}
