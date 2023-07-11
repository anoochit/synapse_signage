import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screen/const.dart';

class ScreenService {
  /// snapshot screen content
  Stream<DocumentSnapshot> getScreenContent({required String id}) {
    return firestore.collection('screens').doc(id).snapshots();
  }
}
