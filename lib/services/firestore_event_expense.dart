import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agri_flutter/models/event_expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // **Get Current User ID**
  String get userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated. Please sign in.");
    }
    print("Current user UID: ${user.uid}");
    print("Auth UID: ${FirebaseAuth.instance.currentUser?.uid}");
    // Debug print
    return user.uid;
  }

  /// **Add Event to Firestore**
  Future<void> addEvent(EventExpense event) async {
    try {
      print("Adding event for user: $userId, event ID: ${event.id}");
      print("Auth UID: ${FirebaseAuth.instance.currentUser?.uid}");

      await _db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('events')
          .doc(event.id)
          .set(event.toJson());
      print("Event added successfully");
    } catch (e) {
      print("Error adding event: $e");
      throw Exception("Failed to add event: $e");
    }
  }

  /// **Add Expense to Firestore**
  Future<void> addExpense(EventExpense expense) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expense.id)
          .set(expense.toJson());
    } catch (e) {
      throw Exception("Failed to add expense: $e");
    }
  }

  /// **Fetch Events Once (Not a Stream)**
  Future<List<EventExpense>> getEventsOnce() async {
    try {
      final snapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('events')
              .orderBy('date', descending: true)
              .get();
      return snapshot.docs
          .map((doc) => EventExpense.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }

  /// **Fetch Expenses Once (Not a Stream)**
  Future<List<EventExpense>> getExpensesOnce() async {
    try {
      final snapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('expenses')
              .orderBy('date', descending: true)
              .get();
      return snapshot.docs
          .map((doc) => EventExpense.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error fetching expenses: $e");
    }
  }

  /// **Delete Event**
  Future<void> deleteEvent(String eventId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('events')
          .doc(eventId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete event: $e");
    }
  }

  /// **Delete Expense**
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete expense: $e");
    }
  }

  //

  // ===========================================
  // 🔹 FAVORITES FUNCTIONALITY
  // ===========================================

  /// **1️⃣ Add Product to Favorites**
  Future<void> addToFavorites(Product product) async {
    try {
      print("🔹 Adding to favorites: ${product.id}, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('fav_cart')
          .doc(product.id)
          .set(product.toJson());
      print("✅ Added to favorites: ${product.id}");
    } catch (e) {
      print("❌ Error adding to favorites: $e");
    }
  }

  /// **2️⃣ Remove Product from Favorites**
  Future<void> removeFromFavorites(String productId) async {
    try {
      print("🔹 Removing from favorites: $productId, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('fav_cart')
          .doc(productId)
          .delete();
      print("✅ Removed from favorites: $productId");
    } catch (e) {
      print("❌ Error removing from favorites: $e");
    }
  }

  /// **3️⃣ Fetch All Favorite Products**
  Future<List<Product>> getFavorites() async {
    try {
      print("🔹 Fetching favorite products for User: $userId");
      final snapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('fav_cart')
              .get();
      print("✅ Fetched ${snapshot.docs.length} favorite products.");
      return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    } catch (e) {
      print("❌ Error fetching favorites: $e");
      return [];
    }
  }

  // ===========================================
  // 🔹 CART FUNCTIONALITY
  // ===========================================

  /// **4️⃣ Add Product to Cart**
  Future<void> addToCart(Product product) async {
    try {
      print("🔹 Adding to cart: ${product.id}, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id)
          .set(product.toJson());
      print("✅ Added to cart: ${product.id}");
      print(userId);
    } catch (e) {
      print("❌ Error adding to cart: $e");
    }
  }

  /// **5️⃣ Remove Product from Cart**
  Future<void> removeFromCart(String productId) async {
    try {
      print("🔹 Removing from cart: $productId, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
      print("✅ Removed from cart: $productId");
    } catch (e) {
      print("❌ Error removing from cart: $e");
    }
  }

  /// **6️⃣ Fetch All Cart Products**
  Future<List<Product>> getCart() async {
    try {
      print("🔹 Fetching cart products for User: $userId");
      final snapshot =
          await _db.collection('users').doc(userId).collection('cart').get();
      print("✅ Fetched ${snapshot.docs.length} cart products.");
      return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    } catch (e) {
      print("❌ Error fetching cart: $e");
      return [];
    }
  }

  // ===========================================
  // 🔹 ORDER FUNCTIONALITY
  // ===========================================

  /// **7️⃣ Place Order**
  Future<void> placeOrder(List<Product> cartProducts) async {
    try {
      print(
        "🔹 Placing order for User: $userId, Products: ${cartProducts.length}",
      );
      final orderRef =
          _db.collection('users').doc(userId).collection('orders').doc();

      final orderData = {
        'orderId': orderRef.id,
        'products': cartProducts.map((p) => p.toJson()).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      await orderRef.set(orderData);
      print("✅ Order placed successfully: ${orderRef.id}");

      // Clear Cart After Order
      for (var product in cartProducts) {
        await removeFromCart(product.id);
      }
    } catch (e) {
      print("❌ Failed to place order: $e");
    }
  }

  /// **8️⃣ Fetch All Orders**
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      print("🔹 Fetching orders for User: $userId");
      final snapshot =
          await _db
              .collection('users')
              .doc(userId)
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .get();
      print("✅ Fetched ${snapshot.docs.length} orders.");
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("❌ Error fetching orders: $e");
      return [];
    }
  }

  // ✅ Update Quantity (Increase/Decrease)
  Future<void> updateCartItemQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .update({'quantity': quantity});
    } catch (e) {
      print("❌ Error updating quantity: $e");
    }
  }

  // ✅ Clear Cart
  Future<void> clearCart(String userId) async {
    try {
      final cartRef = _db.collection('users').doc(userId).collection('cart');
      final cartDocs = await cartRef.get();

      for (var doc in cartDocs.docs) {
        await doc.reference.delete();
      }

      print("✅ Cart cleared for user: $userId");
    } catch (e) {
      print("❌ Error clearing cart: $e");
    }
  }

  /// 🔹 Add Crop to Firestore
  Future<void> addCrop(CropDetails crop) async {
    try {
      print("🔹 Adding crop: ${crop.cropName}, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('crop')
          .doc(crop.id) // Using crop name as doc ID
          .set(crop.toMap());
      print("✅ Crop name: ${crop.cropName}");
    } catch (e) {
      print("❌ Error adding crop: $e");
    }
  }

  /// 🔹 Get All Crops from Firestore
  Future<List<CropDetails>> getCrops() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection('users').doc(userId).collection('crop').get();

      List<CropDetails> crops =
          snapshot.docs.map((doc) {
            return CropDetails.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

      print("✅ Retrieved ${crops.length} crops");
      return crops;
    } catch (e) {
      print("❌ Error fetching crops: $e");
      return [];
    }
  }

  /// 🔹 Remove Crop from Firestore
  Future<void> removeCrop(String cropName) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('crop')
          .doc(cropName)
          .delete();
      print("✅ Removed crop: $cropName");
    } catch (e) {
      print("❌ Error removing crop: $e");
    }
  }

  /// 🔹 Add Crop to Firestore
  Future<void> addLiveStock(LiveStockDetail live) async {
    try {
      print("🔹 Adding crop: ${live.liveStockName}, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('live')
          .doc(live.id) // Using crop name as doc ID
          .set(live.toMap());
      print("✅ Crop name: ${live.liveStockName}");
    } catch (e) {
      print("❌ Error adding crop: $e");
    }
  }

  /// 🔹 Get All Crops from Firestore
  Future<List<LiveStockDetail>> getLiveStock() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection('users').doc(userId).collection('live').get();

      List<LiveStockDetail> live =
          snapshot.docs.map((doc) {
            return LiveStockDetail.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

      print("✅ Retrieved ${live.length} crops");
      return live;
    } catch (e) {
      print("❌ Error fetching crops: $e");
      return [];
    }
  }

  /// 🔹 Remove Crop from Firestore
  Future<void> removeLive(LiveStockDetail live) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('live')
          .doc(live.id)
          .delete();
      print("✅ Removed crop: ${live.liveStockName}");
    } catch (e) {
      print("❌ Error removing crop: $e");
    }
  }

  Future<void> updateLivestock(String userId, LiveStockDetail livestock) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('live')
        .doc(livestock.id)
        .update({
          'liveStockName': livestock.liveStockName,
          'gender': livestock.gender,
          'vaccinatedDate': livestock.vaccinatedDate,
          'age': livestock.age,
          'liveStockLive': livestock.liveStockLive,
        });
  }

  /// 🔹 **Update Crop inside User**
  Future<void> updateCrop(String userId, CropDetails crop) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('crop')
        .doc(crop.id)
        .update({
          'cropName': crop.cropName,
          'location': crop.location,
          'location2': crop.location2,
          'fertilizer': crop.fertilizer,
          'pesticide': crop.pesticide,
          'growthStage': crop.growthStage,
          'startDate': crop.startDate,
          'harvestDate': crop.harvesDate,
        });
  }
}
