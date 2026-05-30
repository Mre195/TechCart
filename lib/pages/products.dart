import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cartservice.dart';
import 'drawer.dart';
import 'cart.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.stock,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: data['id'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      image: data['image'],
      category: data['category'],
      stock: data['stock'],
    );
  }
}

Future<List<Product>> fetchProducts(String category) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('category', isEqualTo: category)
      .get();

  return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
}

class ProductsPage extends StatefulWidget {
  final String initialCategory;

  const ProductsPage({super.key, required this.initialCategory});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late String selectedCategory;
  List<Product> filteredProducts = [];
  Map<int, int> quantities = {};
  CartService? cartService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      cartService = CartService(user.uid);
    }

    loadProducts();
  }

  void loadProducts() async {
    setState(() => isLoading = true);
    filteredProducts = await fetchProducts(selectedCategory);
    for (var p in filteredProducts) {
      quantities.putIfAbsent(p.id, () => 1);
    }
    setState(() => isLoading = false);
  }

  void addToCart(Product product, int qty) async {
    if (cartService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to add products to your cart")),
      );
      return;
    }

    await cartService!.addToCart(product, qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.name} added to your cart")),
    );

    setState(() {
      quantities[product.id] = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;


    Color scaffoldBg = isDark ? Colors.black : Colors.green.shade50;
    Color appBarBg = isDark ? Colors.black : Colors.green;
    Color appBarText = Colors.white;
    Color cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    Color cardShadow = Colors.black.withOpacity(0.08);
    Color cardText = isDark ? Colors.white : Colors.black;
    Color iconColor = const Color(0xFF4F8A63);
    Color iconBg = iconColor.withOpacity(0.12);

    return Scaffold(
      backgroundColor: scaffoldBg,
        appBar: AppBar(
          title: const Text('Products', style: TextStyle(color: Colors.white)),
          backgroundColor: appBarBg,
          centerTitle: true,
        elevation: 0,
        actions:
        [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: cartService != null
                ? () async {
              final cart = await cartService!.getCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CartPage(cart: cart, cartService: cartService!),
                ),
              );
            }
                : ()
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please log in to view cart")),);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: cardShadow,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                dropdownColor: cardBg,
                underline: const SizedBox(),
                iconEnabledColor: iconColor,
                style: TextStyle(color: cardText, fontSize: 16),
                items: ["GPU", "CPU", "RAM", "Storage"]
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    loadProducts();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                Product product = filteredProducts[index];
                return productCard(
                  product,
                  cardBg,
                  cardShadow,
                  cardText,
                  iconColor,
                  iconBg,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget productCard(Product product, Color bg, Color shadow, Color textColor, Color iconColor, Color iconBg) {
    int qty = quantities[product.id]!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Image(image: AssetImage(product.image), width: 55, height: 55),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: TextStyle(color: textColor, fontSize: 14)),
                    const SizedBox(height: 6),
                    Text("${product.price} JD",
                        style: TextStyle(color: textColor, fontSize: 14)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.remove, color: iconColor),
                  onPressed: () {
                    if (qty > 1) {
                      setState(() {
                        quantities[product.id] = qty - 1;
                      });
                    }
                  },
                ),
                Text(qty.toString(), style: TextStyle(color: textColor)),
                IconButton(
                  icon: Icon(Icons.add, color: iconColor),
                  onPressed: ()
                  {
                    if (qty < product.stock) {
                      setState(() {
                        quantities[product.id] = qty + 1;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Out of stock")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: FirebaseAuth.instance.currentUser != null
                ? () => addToCart(product, qty)
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please log in to add products")),
              );
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
