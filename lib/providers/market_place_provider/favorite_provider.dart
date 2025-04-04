import 'package:agri_flutter/models/product.dart';
import 'package:agri_flutter/services/firestore.dart';
import 'package:flutter/widgets.dart';

class FavoriteProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Product> _favoriteList = [];

  FavoriteProvider() {
    fetchFavorites(); // Fetch favorite items on provider initialization
  }

  // Get favorite products list
  List<Product> get favoriteList => _favoriteList;

  // Get total count
  int get totalFavoriteList => _favoriteList.length;

  // **Fetch Favorites from Firestore using FirestoreService**
  Future<void> fetchFavorites() async {
    try {
      print("🔹 Fetching favorite products from Firestore...");
      final favorites = await _firestoreService.getFavorites();

      _favoriteList.clear();
      _favoriteList.addAll(favorites);
      notifyListeners();

      print(
        "✅ Favorite list updated! Total favorites: ${_favoriteList.length}",
      );
    } catch (e) {
      print("❌ Error fetching favorites: $e");
    }
  }

  // **Add to Favorites using FirestoreService**
  Future<void> addFavorite(Product product) async {
    if (!_favoriteList.any((item) => item.id == product.id)) {
      _favoriteList.add(product); // Add locally first
      notifyListeners(); // Update UI

      try {
        await _firestoreService.addToFavorites(product);
        print("✅ Product added to favorites: ${product.id}");
      } catch (e) {
        print("❌ Error adding to favorites: $e");
      }
    }
  }

  Future<void> removeFavorite(Product product) async {
    if (_favoriteList.any((item) => item.id == product.id)) {
      _favoriteList.removeWhere(
        (item) => item.id == product.id,
      ); // Remove locally first
      notifyListeners(); // Update UI

      try {
        await _firestoreService.removeFromFavorites(product.id);
        print("✅ Product removed from favorites: ${product.id}");
      } catch (e) {
        print("❌ Error removing from favorites: $e");
      }
    }
  }

  // **Check if a product is in favorites**
  bool isFavorite(Product product) {
    final response = _favoriteList.any((item) => item.id == product.id);
    print(response);
    return response;
  }
}
