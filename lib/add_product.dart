import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  File? _image;

  // Hàm để chọn ảnh từ camera hoặc thư viện
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Lỗi chọn ảnh: $e')), // Hiển thị thông báo khi có lỗi khi chọn ảnh
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Sản Phẩm'), // Tiêu đề trang
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên Sản Phẩm',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm'; // Kiểm tra xem người dùng đã nhập tên sản phẩm chưa
                  }
                  return null;
                },
                onSaved: (value) {
                  _name =
                      value!; // Lưu tên sản phẩm khi người dùng hoàn thành nhập liệu
                },
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text(
                      'Chưa chọn ảnh.', // Hiển thị thông báo nếu chưa có ảnh được chọn
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    )
                  : Container(
                      constraints: BoxConstraints(
                        maxWidth: 300,
                        maxHeight: 300,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(_image!), // Hiển thị ảnh đã chọn
                    ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () =>
                        _pickImage(ImageSource.camera), // Chọn ảnh từ camera
                    icon: Icon(Icons.camera_alt),
                    label: Text('Chụp Ảnh'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _pickImage(ImageSource.gallery), // Chọn ảnh từ thư viện
                    icon: Icon(Icons.photo_library),
                    label: Text('Chọn từ Thư Viện'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _image != null) {
                    _formKey.currentState!
                        .save(); // Lưu dữ liệu biểu mẫu khi hợp lệ
                    Navigator.pop(context, {
                      'name': _name,
                      'image': _image!.path
                    }); // Trả về dữ liệu sản phẩm đã thêm
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Vui lòng hoàn thành biểu mẫu và chọn ảnh.'), // Hiển thị thông báo khi biểu mẫu chưa hoàn thành
                      ),
                    );
                  }
                },
                child: Text('Thêm Sản Phẩm'), // Text của nút thêm sản phẩm
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
