import 'package:flutter/material.dart';
import 'dart:io';
import 'edit_product.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, String> product;
  final Function(String) onDelete;
  final Function(Map<String, String>) onEdit;

  ProductDetails(
      {required this.product, required this.onDelete, required this.onEdit});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, String> _currentProduct = {};

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete(widget.product['name']!);
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop(
                    _currentProduct); // Truyền lại dữ liệu sản phẩm đã chỉnh sửa
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(BuildContext context) async {
    final updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProduct(
          product: widget.product,
        ),
      ),
    );
    if (updatedProduct != null) {
      setState(() {
        _currentProduct = updatedProduct;
      });
      widget.onEdit(updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentProduct['name']!),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editProduct(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80.0,
              backgroundImage: FileImage(File(_currentProduct['image']!)),
            ),
            SizedBox(height: 20),
            Text(
              _currentProduct['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
