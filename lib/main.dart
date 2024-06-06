import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_product.dart';
import 'product_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductCatalog(),
    );
  }
}

class ProductCatalog extends StatefulWidget {
  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  List<Map<String, String>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productString = prefs.getString('products');
    if (productString != null) {
      final List<dynamic> productList = jsonDecode(productString);
      setState(() {
        products = productList.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  void _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productString = jsonEncode(products);
    prefs.setString('products', productString);
  }

  void _addProduct(Map<String, String> product) {
    setState(() {
      products.add(product);
    });
    _saveProducts();
  }

  void _deleteProduct(String productName) {
    setState(() {
      products.removeWhere((product) => product['name'] == productName);
    });
    _saveProducts();
  }

  void _editProduct(Map<String, String> editedProduct) {
    setState(() {
      final index = products
          .indexWhere((product) => product['name'] == editedProduct['name']);
      if (index != -1) {
        products[index] = editedProduct;
      }
    });
    _saveProducts(); // Cập nhật dữ liệu sau khi chỉnh sửa sản phẩm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Catalog',
          textAlign: TextAlign.center, // Căn giữa tiêu đề
        ),
        centerTitle: true, // Đặt tiêu đề ở giữa
        elevation: 4, // Thêm độ nâng của AppBar
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              final editedProduct = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    product: products[index],
                    onDelete: _deleteProduct,
                    onEdit: _editProduct,
                  ),
                ),
              );
              if (editedProduct != null) {
                _editProduct(editedProduct);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: ClipOval(
                  child: Image.file(
                    File(products[index]['image']!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  products[index]['name']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8.0);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
          if (result != null) {
            _addProduct(result);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
