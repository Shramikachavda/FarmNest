import 'dart:async';
import '../../../models/post_sign_up/farm_detail.dart';
import '../../../services/firestore.dart';

class FarmBloc {


  final StreamController<List<FarmDetail>> _streamController = StreamController.broadcast();
  final FirestoreService _firestoreService = FirestoreService();
  Stream<List<FarmDetail>> get farmList => _streamController.stream;

  Future<void> getFarmDetail() async {
    try {
      final result = await _firestoreService.getFarm();
      print("result  : $result");
      _streamController.add(result ?? []);
    } catch (e) {
      _streamController.addError("something went wrong $e");
    }
  }
}
