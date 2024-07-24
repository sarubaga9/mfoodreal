import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryProductController extends GetxController {
  RxMap<String, dynamic>? categoryProductsData = <String, dynamic>{}.obs;

  void resetCategoryProductsDataToDefault() {
    categoryProductsData!.value = {};
  }

  Future<void> updateCategoryProductsData(
      QuerySnapshot<Map<String, dynamic>>? data) async {
    if (data != null && data.docs.isNotEmpty) {
      Map<String, dynamic> categoryProductMap = {};

      for (int index = 0; index < data.docs.length; index++) {
        final Map<String, dynamic> docData =
            data.docs[index].data() as Map<String, dynamic>;

        categoryProductMap['key${index}'] = docData;
      }

      categoryProductMap.forEach((key, value) {
        if (value['IS_ACTIVE'] == true) {
          print('product cate');
          print(value);
          categoryProductsData![key] = value;


        }
      });
    } else {
      print('reset category product');
      resetCategoryProductsDataToDefault();
    }
              print(categoryProductsData);
    print('update News Complete');
  }

  Future<void> updateCategoryProductsDataDoc(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> categoryProductMap =
          data.data() as Map<String, dynamic>;

      categoryProductsData!.addAll(categoryProductMap);
    }
  }
}
