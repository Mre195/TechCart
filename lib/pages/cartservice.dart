import 'package:cloud_firestore/cloud_firestore.dart';
import 'products.dart';
import 'cartitem.dart';

class CartService {
  final String userId;

  CartService(this.userId);

  CollectionReference get userCart => FirebaseFirestore.instance.collection('users').doc(userId).collection('cart');

  Future<void> addToCart(Product product, int quantity) async {
    final doc = userCart.doc(product.id.toString());
    final snapshot = await doc.get();

    if (snapshot.exists)
    {
      int currentQty = snapshot.get('quantity');
      await doc.update({'quantity': currentQty + quantity});
    }
    else
    {
      await doc.set({
        'productId': product.id,
        'quantity': quantity,
      });
    }
  }

  Future<List<CartItem>> getCart() async {
    final snapshot = await userCart.get();
    List<CartItem> cart = [];

    for (var doc in snapshot.docs) {
      final prodSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(doc['productId'].toString())
          .get();

      final product = Product.fromFirestore(prodSnapshot);
      cart.add(CartItem(product: product, quantity: doc['quantity']));
    }
    return cart;
  }

  Future<void> clearCart() async {
    final snapshot = await userCart.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
  Future<void> removeFromCart(int productId) async {
    await userCart.doc(productId.toString()).delete();
  }
  Future<void> updateQuantity(int productId, int newQuantity) async {
    final doc = userCart.doc(productId.toString());

    if (newQuantity <= 0) {
      await doc.delete();
    } else {
      await doc.update({'quantity': newQuantity});
    }
  }

}
