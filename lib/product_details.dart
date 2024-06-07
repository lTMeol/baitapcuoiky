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
          title: Text('Xóa Sản Phẩm'),
          content: Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete(widget.product['name']!);
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.of(context).pop(
                    _currentProduct); // Truyền lại dữ liệu sản phẩm đã chỉnh sửa
              },
              child: Text('Xóa'),
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
        title: Text('CHI TIẾT SẢN PHẨM'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => _editProduct(context),
            tooltip: 'Sửa Sản Phẩm',
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Xóa Sản Phẩm',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage: FileImage(File(_currentProduct['image']!)),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _currentProduct['name']!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _editProduct(context),
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text('Sửa'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showDeleteDialog(context),
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text('Xóa'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
