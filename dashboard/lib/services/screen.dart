import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/const.dart';

class ScreenService {
  // get screen
  Stream<QuerySnapshot<Map<String, dynamic>>> getScreens() {
    return firestore.collection('screens').orderBy('title').snapshots();
  }

  void setScreenContent({required String id, required String content}) {
    firestore.collection('screens').doc(id).update({
      'content': content,
    });
  }
}
