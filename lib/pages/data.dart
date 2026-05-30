import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/drawer.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  void addProduct() async {
    if (_formKey.currentState!.validate()) {
      int id = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('products').doc(id.toString()).set({
        'id': id,
        'name': nameController.text,
        'price': double.parse(priceController.text),
        'image': imageController.text,
        'category': categoryController.text,
        'stock': int.parse(stockController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully')),
      );

      nameController.clear();
      priceController.clear();
      imageController.clear();
      categoryController.clear();
      stockController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: "Image Path"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: "Category (GPU/CPU/RAM/Storage)"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: stockController,
                decoration: InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addProduct,
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
