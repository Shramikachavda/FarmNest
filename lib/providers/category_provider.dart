import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();


  CategoryProvider(){
    fetchCategoty();
  }

  List<String> _categoryList = [];

  List<String> get CategotyList => _categoryList;

  void fetchCategoty() async {
    try {
      _categoryList = await _firestoreService.getCategory();
      print("fetching category succesful");
      notifyListeners();

    } catch(e){
      print("category problem $e");
      rethrow;
    }
  }
}
