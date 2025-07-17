// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as developer;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'cart_model.dart';

// class CartRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;
//   final SharedPreferences _prefs;
//   final StreamController<Cart> _cartController =
//       StreamController<Cart>.broadcast();
//   StreamSubscription<DocumentSnapshot>? _remoteCartSubscription;

//   static const _localCartKey = 'local_cart';
//   static const _syncDebounceTime = Duration(seconds: 2);

//   Timer? _syncDebounceTimer;
//   Cart _localCart = Cart();
//   bool _isSyncing = false;

//   CartRepository({
//     required FirebaseFirestore firestore,
//     required FirebaseAuth auth,
//     required SharedPreferences prefs,
//   })  : _firestore = firestore,
//         _auth = auth,
//         _prefs = prefs;

//   Stream<Cart> get cartStream => _cartController.stream;

//   Cart get currentCart => _localCart;

//   Future<void> init() async {
//     final json = _prefs.getString(_localCartKey);
//     if (json != null) {
//       _localCart = _parseLocalCart(json);
//       _cartController.add(_localCart);
//     }

//     await _setupRemoteListener();
//     await _syncWithRemote(force: true);
//   }

//   Future<void> _setupRemoteListener() async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     _remoteCartSubscription?.cancel();
//     _remoteCartSubscription = _firestore
//         .collection('carts')
//         .doc(user.uid)
//         .snapshots()
//         .listen((snapshot) async {
//       if (!snapshot.exists) return;

//       final remoteCart = _parseRemoteCart(snapshot.data()!);

//       // Only update if remote cart is newer than our local version
//       if (remoteCart.lastLocalUpdate.isAfter(_localCart.lastLocalUpdate)) {
//         _localCart = remoteCart;
//         _cartController.add(_localCart);
//         await _saveLocalCart();
//       }
//     });
//   }

//   Future<void> _syncWithRemote({bool force = false}) async {
//     if (_isSyncing && !force) return;
//     _isSyncing = true;

//     try {
//       final user = _auth.currentUser;
//       if (user == null) return;

//       final cartRef = _firestore.collection('carts').doc(user.uid);
//       final remoteSnapshot = await cartRef.get();

//       if (!remoteSnapshot.exists) {
//         // No remote cart exists yet, just push our local version
//         await cartRef.set(_cartToFirestoreMap(_localCart));
//         return;
//       }

//       final remoteData = remoteSnapshot.data()!;
//       final remoteCart = _parseRemoteCart(remoteData);

//       // Only merge if our local cart is newer than remote
//       if (_localCart.lastLocalUpdate.isAfter(remoteCart.lastLocalUpdate)) {
//         await cartRef.set(_cartToFirestoreMap(_localCart));
//       }
//     } catch (e, stack) {
//       developer.log('Cart sync failed', error: e, stackTrace: stack);
//     } finally {
//       _isSyncing = false;
//     }
//   }

//   Future<void> addToCart({
//     required String productId,
//     int quantity = 1,
//   }) async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     final itemKey = productId;
//     _localCart = _localCart.copyWith(
//       userId: userId,
//       items: {
//         ..._localCart.items,
//         itemKey: (_localCart.items[itemKey] ??
//                 CartItem(
//                   productId: productId,
//                 ))
//             .copyWith(
//           quantity: (_localCart.items[itemKey]?.quantity ?? 0) + quantity,
//           updatedAt: DateTime.now(),
//         ),
//       },
//       lastLocalUpdate: DateTime.now(),
//     );
//     _cartController.add(_localCart);
//     await _saveLocalCart();
//     _scheduleRemoteSync();
//   }

//   Future<void> removeFromCart(String productId) async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     final itemKey = productId;
//     final newItems = {..._localCart.items};
//     newItems.remove(itemKey);

//     _localCart = _localCart.copyWith(
//       userId: userId,
//       items: newItems,
//       lastLocalUpdate: DateTime.now(),
//     );
//     _cartController.add(_localCart);
//     await _saveLocalCart();
//     _scheduleRemoteSync();
//   }

//   Future<void> decreaseQuantity(String productId) async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     final item = _localCart.items[productId];
//     if (item == null) return;

//     if (item.quantity > 1) {
//       _localCart = _localCart.copyWith(
//         userId: userId,
//         items: {
//           ..._localCart.items,
//           productId: item.copyWith(
//             quantity: item.quantity - 1,
//             updatedAt: DateTime.now(),
//           )
//         },
//         lastLocalUpdate: DateTime.now(),
//       );
//     } else {
//       await removeFromCart(productId);
//       return;
//     }

//     _cartController.add(_localCart);
//     await _saveLocalCart();
//     _scheduleRemoteSync();
//   }

//   Future<void> clearCart() async {
//     final userId = _auth.currentUser?.uid;
//     if (userId == null) return;

//     _localCart = Cart(userId: userId);
//     _cartController.add(_localCart);
//     await _saveLocalCart();
//     await _syncWithRemote(force: true);
//   }

//   void _scheduleRemoteSync() {
//     _syncDebounceTimer?.cancel();
//     _syncDebounceTimer = Timer(_syncDebounceTime, () => _syncWithRemote());
//   }

//   // Future<void> _syncWithRemote({bool force = false}) async {
//   //   if (_isSyncing && !force) return;
//   //   _isSyncing = true;

//   //   try {
//   //     final user = _auth.currentUser;
//   //     if (user == null) return;

//   //     final cartRef = _firestore.collection('carts').doc(user.uid);
//   //     final remoteSnapshot = await cartRef.get();
//   //     final remoteData = remoteSnapshot.data();

//   //     final remoteCart = remoteData != null
//   //         ? _parseRemoteCart(remoteData)
//   //         : Cart(userId: user.uid);

//   //     final mergedCart = _mergeCarts(local: _localCart, remote: remoteCart);

//   //     await cartRef.set(_cartToFirestoreMap(mergedCart));

//   //     _localCart = mergedCart;
//   //     _cartController.add(_localCart);
//   //     await _saveLocalCart();
//   //   } catch (e, stack) {
//   //     developer.log('Cart sync failed', error: e, stackTrace: stack);
//   //   } finally {
//   //     _isSyncing = false;
//   //   }
//   // }

//   Cart _mergeCarts({required Cart local, required Cart remote}) {
//     final mergedItems = {...remote.items};

//     for (final entry in local.items.entries) {
//       final localItem = entry.value;
//       final remoteItem = mergedItems[entry.key];

//       if (localItem.updatedAt
//           .isAfter(remoteItem?.updatedAt ?? DateTime(1970))) {
//         mergedItems[entry.key] = localItem;
//       }
//     }

//     return Cart(
//       items: mergedItems,
//       userId: local.userId ?? remote.userId,
//       lastLocalUpdate: DateTime.now(),
//     );
//   }

//   Cart _parseRemoteCart(Map<String, dynamic> data) {
//     try {
//       return Cart(
//         userId: data['userId'],
//         lastLocalUpdate: (data['updatedAt'] as Timestamp).toDate(),
//         items: _parseCartItems(data['items']),
//       );
//     } catch (e, stack) {
//       developer.log('Error parsing remote cart', error: e, stackTrace: stack);
//       return Cart(userId: data['userId']);
//     }
//   }

//   Map<String, dynamic> _cartToFirestoreMap(Cart cart) {
//     return {
//       'userId': cart.userId,
//       'updatedAt': DateTime.now().toUtc(),
//       'items': cart.items.map((key, value) => MapEntry(key, value.toMap())),
//     };
//   }

//   Map<String, CartItem> _parseCartItems(dynamic itemsData) {
//     final Map<String, CartItem> items = {};
//     if (itemsData is Map) {
//       itemsData.forEach((key, value) {
//         try {
//           items[key] = CartItem.fromMap(value);
//         } catch (e, stack) {
//           developer.log('Error parsing cart item $key',
//               error: e, stackTrace: stack);
//         }
//       });
//     }
//     return items;
//   }

//   Future<void> _saveLocalCart() async {
//     await _prefs.setString(
//       _localCartKey,
//       jsonEncode({
//         'userId': _localCart.userId,
//         'lastLocalUpdate': _localCart.lastLocalUpdate.toIso8601String(),
//         'items': _localCart.items.map((k, v) => MapEntry(k, v.toMap())),
//       }),
//     );
//   }

//   Cart _parseLocalCart(String json) {
//     try {
//       final map = jsonDecode(json) as Map<String, dynamic>;
//       return Cart(
//         userId: map['userId'],
//         lastLocalUpdate: DateTime.parse(map['lastLocalUpdate']),
//         items: _parseCartItems(map['items']),
//       );
//     } catch (e, stack) {
//       developer.log('Error parsing local cart', error: e, stackTrace: stack);
//       return Cart();
//     }
//   }

//   Future<void> close() async {
//     _cartController.close();
//     _syncDebounceTimer?.cancel();
//   }
// }
