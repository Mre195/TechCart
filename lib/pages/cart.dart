import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/pages/cartitem.dart';
import 'package:project/pages/cartservice.dart';
import 'package:project/pages/drawer.dart';
import 'package:project/pages/home.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final CartService cartService;

  const CartPage({super.key, required this.cart, required this.cartService});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isProcessing = false;

  void payment(BuildContext context) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    for (CartItem item in widget.cart) {
      if (item.quantity > item.product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Not enough stock for ${item.product.name}")),
        );
        setState(() => isProcessing = false);
        return;
      }
    }

    try {
      for (CartItem item in widget.cart) {
        final docRef = FirebaseFirestore.instance
            .collection('products')
            .doc(item.product.id.toString());

        await docRef.update({'stock': FieldValue.increment(-item.quantity)});

        item.product.stock -= item.quantity;
      }

      await widget.cartService.clearCart();
      setState(() => widget.cart.clear());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Payment successful")));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Payment failed")));
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color scaffoldBg = isDark ? Colors.black : Colors.green.shade50;
    Color appBarBg = isDark ? Colors.black : Colors.green;
    Color appBarText = Colors.white;
    Color cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    Color cardText = isDark ? Colors.white : Colors.black;
    Color cardShadow = Colors.black.withOpacity(0.08);
    Color totalBg = isDark ? const Color(0xFF2A2A2A) : Colors.green.shade100;

    return Scaffold(
      backgroundColor: scaffoldBg,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(color: appBarText)),
        backgroundColor: appBarBg,
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(color: cardText, fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      CartItem item = widget.cart[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: cardShadow,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              item.product.image,
                              width: 65,
                              height: 65,
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: TextStyle(
                                      color: cardText,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${item.product.price} JD",
                                    style: TextStyle(
                                      color: cardText,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        int newQty = item.quantity - 1;

                                        await widget.cartService.updateQuantity(
                                          item.product.id,
                                          newQty,
                                        );

                                        setState(() {
                                          if (newQty <= 0) {
                                            widget.cart.removeAt(index);
                                          } else {
                                            item.quantity = newQty;
                                          }
                                        });
                                      },
                                    ),

                                    Text(
                                      item.quantity.toString(),
                                      style: TextStyle(
                                        color: cardText,
                                        fontSize: 16,
                                      ),
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        int newQty = item.quantity + 1;

                                        if (newQty > item.product.stock) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Not enough stock"),
                                            ),
                                          );
                                          return;
                                        }

                                        await widget.cartService.updateQuantity(
                                          item.product.id,
                                          newQty,
                                        );

                                        setState(() {
                                          item.quantity = newQty;
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                Text(
                                  "${item.product.price * item.quantity} JD",
                                  style: TextStyle(
                                    color: cardText,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Total Cost Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(color: cardText, fontSize: 18),
                          ),
                          Text(
                            "${totalCost().toStringAsFixed(2)} JD",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Payment Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 3,
                          ),
                          onPressed: isProcessing
                              ? null
                              : () => payment(context),
                          child: isProcessing
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Payment",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  double totalCost() {
    double total = 0;
    for (CartItem item in widget.cart) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
