import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  RxMap<String, dynamic>? newsData = <String, dynamic>{}.obs;

  void resetUserDataToDefault() {
    newsData!.value = {};
  }

  // สร้างเมธอดเพื่ออัปเดตข้อมูลผู้ใช้D
  void updateUserData(QuerySnapshot<Map<String, dynamic>>? data) async{
    if (data != null && data.docs.isNotEmpty) {
      // แปลงข้อมูลจาก QuerySnapshot เป็น Map
      Map<String, dynamic> userMap = {};
      //     data.docs.first.data() as Map<String, dynamic>;
      for (int index = 0; index < data.docs.length; index++) {
        final Map<String, dynamic> docData =
            data.docs[index].data() as Map<String, dynamic>;

        userMap['key${index}'] = docData;
        // print(userMap['key${index}']);
      }

      userMap.forEach((key, value) {
        newsData![key] = value;
      });
    }
    print('update News Complete');
  }

  Future<void> updateUserDataDoc(
      DocumentSnapshot<Map<String, dynamic>>? data) async {
    if (data!.data() != null && data.data()!.isNotEmpty) {
      final Map<String, dynamic> userMap = data.data() as Map<String, dynamic>;
      // userMap.forEach((key, value) {
      newsData!.addAll(userMap);
      // print(newsData!.values);
      // });
    }
    // else {
    //   resetUserDataToDefault();
    // }

    // print(newsData!['key7']);
    // print('news update');
  }
}
