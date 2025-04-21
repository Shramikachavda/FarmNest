import 'package:agri_flutter/models/crop_details.dart';
import 'package:agri_flutter/models/post_sign_up/default_farmer_address.dart';
import 'package:agri_flutter/models/post_sign_up/farm_detail.dart';
import 'package:agri_flutter/models/live_stock_detail.dart';
import 'package:agri_flutter/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agri_flutter/models/event_expense.dart';
import '../models/post_sign_up/farmer_address.dart';

import '../models/user_data.dart';

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
          .set(product.toMap());
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
          .set(product.toMap());
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



  Future<void> placeOrder(
      List<Product> cartProducts,
      DefaultFarmerAddress? address,
      ) async {
    try {
      if (userId == null) {
        throw Exception("User not logged in");
      }
      print(
        "🔹 Placing orders for User: $userId, Products: ${cartProducts.length}",
      );

      // Calculate total price (if needed for individual products)
      final total = cartProducts.fold<double>(
        0.0,
            (sum, product) => sum + (product.price * product.quantity),
      );

      // Loop through each product and create an individual order for each
      for (var product in cartProducts) {
        final orderRef = _db.collection('users').doc(userId).collection('orders').doc();

        final orderData = {
          'orderId': orderRef.id,
          'product': product.toMap(), // Each product gets its own entry
          'total': product.price * product.quantity, // Price for each product
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'Pending',
          'address': address?.toJson(), // Include address for each order
        };

        await orderRef.set(orderData);
        print("✅ Order placed successfully for product ${product.id}: ${orderRef.id}");
      }

      // Clear Cart After Order
      for (var product in cartProducts) {
        await removeFromCart(product.id);
      }
    } catch (e) {
      print("❌ Failed to place order: $e");
      throw e;
    }
  }


  Future<List<Map<String, dynamic>>> getOrders({String? userId}) async {
    try {
      if (userId == null && this.userId == null) {
        throw Exception("User ID not provided");
      }
      final effectiveUserId = userId ?? this.userId!;
      final querySnapshot =
          await _db
              .collection('users')
              .doc(effectiveUserId)
              .collection('orders')
              .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("❌ Failed to fetch orders: $e");
      throw e;
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

  /*

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


  */

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
          'liveStockType': livestock.liveStockType,
        });
  }

  /*

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
  }    */

  //user

  //// ✅ Add User

  /// ➕ Add User
  Future<void> addUser(UserModelDb user) async {
    try {
      await _db.collection("users").doc(user.id).set(user.toMap());
      print("✅ User added successfully");
    } catch (e) {
      print("❌ Error adding user: $e");
      rethrow;
    }
  }

  /// 🔍 Get User by ID
  Future<UserModelDb?> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await _db.collection("users").doc(id).get();
      if (doc.exists) {
        return UserModelDb.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("❌ Error fetching user: $e");
      rethrow;
    }
  }

  /// 🔄 Update User
  Future<void> updateUser(UserModelDb user) async {
    try {
      await _db.collection("users").doc(user.id).update(user.toMap());
      print("✅ User updated successfully");
    } catch (e) {
      print("❌ Error updating user: $e");
      rethrow;
    }
  }

  //farmer address

  Future<void> addFamerAddress(FarmerAddress farm) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection("FarmerAddress")
          .doc(farm.name)
          .set(farm.toJson());
      print("✅ User added successfully");
    } catch (e) {
      print("❌ Error adding user: $e");
      rethrow;
    }
  }

  Future<FarmerAddress?> getFarmerAddress() async {
    try {
      final data =
          await _db
              .collection("users")
              .doc(userId)
              .collection("FarmerAddress")
              .get();

      if (data.docs.isNotEmpty) {
        final doc = data.docs.first.data();

        return FarmerAddress.fromJson(doc);
      } else {
        print("No address found.");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateFarmerAddress(FarmerAddress farm) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection("FarmerAddress")
          .doc(farm.name)
          .update(farm.toJson());
      print("update sucessfully");
    } catch (e) {
      rethrow;
    }
  }

  //farm detail

  //add
  Future<void> addFarm(FarmDetail farm) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection("Farm")
          .doc(farm.id)
          .set(farm.toJson());
      print("✅ User added successfully");
    } catch (e) {
      print("❌ Error adding user: $e");
      rethrow;
    }
  }

  //get farm
  Future<List<FarmDetail>?> getFarm() async {
    try {
      final snapshot =
          await _db.collection("users").doc(userId).collection("Farm").get();

      print("Actual farms in Firestore after delete:");
      for (var doc in snapshot.docs) {
        print(" - ${doc.id}");
      }
      return snapshot.docs
          .map((doc) => FarmDetail.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("❌ Error fetching farm: $e");
      return null;
    }
  }



  Future<void> deleteFarm(String farmId) async {
    print("Attempting to delete farm: $farmId for userId: $userId");

    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection('Farm')
          .doc(farmId)
          .delete();

      print("Farm deleted successfully");
    } catch (e, stackTrace) {
      print("Delete failed: $e");
      print(stackTrace);
      rethrow;
    }
  }

  Future<void> updateFarm(FarmDetail farm) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection("Farm")
          .doc(farm.fieldName)
          .update(farm.toJson());

      print("✅ Farm updated successfully");
    } catch (e) {
      print("❌ Error updating farm: $e");
      rethrow;
    }
  }


  Future<void> updateFarmBoundary(
      String farmId,
      List<LatLongData> boundaries,
      ) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection('Farm')
        .doc(farmId)
        .update({
      'farmBoundaries': boundaries.map((p) => p.toJson()).toList(),
    });
  }


  //farm address default
  Future<void> addNewAddress(DefaultFarmerAddress farm) async {
    try {
      final userRef = _db.collection("users").doc(userId);
      await userRef
          .collection("defaultAddress")
          .doc(farm.name)
          .set(farm.toJson());
      print("✅ New address added");
    } catch (e) {
      print("❌ Error adding address: $e");
      rethrow;
    }
  }

  Future<DefaultFarmerAddress?> getDefaultAddress() async {
    try {
      final snapshot =
          await _db
              .collection("users")
              .doc(userId)
              .collection("defaultAddress")
              .where('isDefault', isEqualTo: true)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        return DefaultFarmerAddress.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<DefaultFarmerAddress>> getAllAddresses() async {
    try {
      final snapshot =
          await _db
              .collection("users")
              .doc(userId)
              .collection("defaultAddress")
              .get();

      return snapshot.docs
          .map((doc) => DefaultFarmerAddress.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("❌ Error fetching addresses: $e");
      return [];
    }
  }

  Future<void> addDefaultLocation(DefaultFarmerAddress farm) async {
    try {
      final addressRef = _db
          .collection("users")
          .doc(userId)
          .collection("defaultAddress");

      final allAddresses = await addressRef.get();
      final isFirst = allAddresses.docs.isEmpty;

      await addressRef.doc(farm.name).set({
        'name': farm.name,
        'address1': farm.address1,
        'address2': farm.address2,
        'landmark': farm.landmark,
        'contactNumber': farm.contactNumber,
        'isDefault': isFirst ? true : farm.isDefault,
      });

      print("✅ Address saved. Default: ${isFirst ? true : farm.isDefault}");
    } catch (e) {
      print("❌ Failed to save address: $e");
      rethrow;
    }
  }

  Future<void> updateAddress(DefaultFarmerAddress farm) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection("defaultAddress")
          .doc(farm.name)
          .update(farm.toJson());
      print("✅ Address updated");
    } catch (e) {
      print("❌ Error updating address: $e");
    }
  }

  Future<void> deleteAddress(String addressName) async {
    try {
      final addressRef = _db
          .collection("users")
          .doc(userId)
          .collection("defaultAddress");

      final deletedDoc = await addressRef.doc(addressName).get();
      final wasDefault =
          deletedDoc.exists && deletedDoc.data()?['isDefault'] == true;

      await addressRef.doc(addressName).delete();
      print("🗑️ Address deleted");

      if (wasDefault) {
        final remainingAddresses = await addressRef.get();
        if (remainingAddresses.docs.isNotEmpty) {
          await remainingAddresses.docs.first.reference.update({
            'isDefault': true,
          });
          print("✅ Set new default address");
        }
      }
    } catch (e) {
      print("❌ Error deleting address: $e");
    }
  }

  Future<void> setDefaultAddress(String addressName) async {
    try {
      final addressRef = _db
          .collection("users")
          .doc(userId)
          .collection("defaultAddress");

      final allAddresses = await addressRef.get();
      for (var doc in allAddresses.docs) {
        await doc.reference.update({'isDefault': false});
      }

      await addressRef.doc(addressName).update({'isDefault': true});
      print("✅ Default address set to $addressName");
    } catch (e) {
      print("❌ Error setting default address: $e");
      rethrow;
    }
  }

  // crops with gimini
  Future<void> addCrop(String userId, CropDetails crop) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('crops')
        .doc(crop.id)
        .set(crop.toMap());
  }

  Future<void> updateCrop(String userId, CropDetails crop) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('crops')
        .doc(crop.id)
        .update(crop.toMap());
  }

  Future<List<CropDetails>> getCrops() async {
    try {
      final snapshot =
          await _db.collection('users').doc(userId).collection('crops').get();
      print(snapshot.docs.length);
      return snapshot.docs
          .map((doc) => CropDetails.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("faild $e");
      return [];
    }
  }

  Future<void> deleteCrop(CropDetails id) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('crops')
          .doc(id.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  //order

  /* Future<void> addToOrders(Product product) async {
    try {
      print("🛒 Placing order for: ${product.id}, User: $userId");
      await _db
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(product.id)
          .set(product.toMap());
      print("✅ Order placed: ${product.id}");
    } catch (e) {
      print("❌ Error placing order: $e");
    }
  }  */

  Future<List<String>> getCategory() async {
    List<String> categories = [];

    try {
      final snapshot = await _db.collection("categories").get();

      for (var doc in snapshot.docs) {
        final category = doc.data()["name"];
        if (category != null) {
          categories.add(category);
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }

    return categories;
  }
}
