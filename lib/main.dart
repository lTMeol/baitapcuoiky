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
      title: 'Danh mục sản phẩm', // Tiêu đề ứng dụng
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductCatalog(), // Trang chính của ứng dụng
      debugShowCheckedModeBanner: false,
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
    _loadProducts(); // Load danh sách sản phẩm từ SharedPreferences khi widget được tạo
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
    prefs.setString('products',
        productString); // Lưu danh sách sản phẩm vào SharedPreferences
  }

  void _addProduct(Map<String, String> product) {
    setState(() {
      products.add(product); // Thêm sản phẩm mới vào danh sách
    });
    _saveProducts(); // Lưu danh sách sản phẩm sau khi thêm mới
  }

  void _deleteProduct(String productName) {
    setState(() {
      products.removeWhere((product) =>
          product['name'] == productName); // Xóa sản phẩm khỏi danh sách
    });
    _saveProducts(); // Lưu danh sách sản phẩm sau khi xóa
  }

  void _editProduct(Map<String, String> editedProduct) {
    setState(() {
      final index = products
          .indexWhere((product) => product['name'] == editedProduct['name']);
      if (index != -1) {
        products[index] =
            editedProduct; // Chỉnh sửa thông tin sản phẩm trong danh sách
      }
    });
    _saveProducts(); // Lưu danh sách sản phẩm sau khi chỉnh sửa
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DANH MỤC SẢN PHẨM', // Tiêu đề của trang
          style: TextStyle(
            color: Colors.white, // Màu chữ
            fontSize: 24, // Kích thước chữ
            fontWeight: FontWeight.bold, // Độ đậm
          ),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        elevation: 4, // Độ nâng của AppBar
        backgroundColor: Colors.blue, // Màu nền của AppBar
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
            _addProduct(
                result); // Thêm sản phẩm mới khi nhận được kết quả từ màn hình thêm sản phẩm
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor, // Màu nền của nút thêm
        tooltip: 'Thêm sản phẩm', // Tooltip cho nút thêm
      ),
    );
  }
}
