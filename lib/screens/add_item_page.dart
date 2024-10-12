import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
 
void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        AddItemPage.id: (context) => AddItemPage(vendorId: '1'),
      },
    );
  }
}
 
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AddItemPage.id);
          },
          child: Text('Go to Add Item Page'),
        ),
      ),
    );
  }
}
 
class RoundedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
 
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
 
class AddItemPage extends StatefulWidget {
  static const String id = 'AddItemPage'; // Add this line for route identifier
 
  final String vendorId;
 
  AddItemPage({required this.vendorId});
 
  @override
  _AddItemPageState createState() => _AddItemPageState();
}
 
class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  double _price = 0.0;
  String _size = '';
  String _location = '';
  File? _image;
 
  final picker = ImagePicker();
 
  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
 
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
 
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;
 
    _formKey.currentState!.save();
 
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/vendors/${widget.vendorId}/products'),
    );
    request.fields['name'] = _productName;
    request.fields['price'] = _price.toString();
    request.fields['size'] = _size;
    request.fields['location'] = _location;
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', _image!.path));
    }
 
    final response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Return to the previous page
    } else {
      print('Failed to add product');
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: ClipPath(
          clipper: RoundedAppBarClipper(),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Add New Item',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) => _productName = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
                onSaved: (value) => _price = double.parse(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Size'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a size';
                  }
                  return null;
                },
                onSaved: (value) => _size = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) => _location = value!,
              ),
              SizedBox(height: 16),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              ElevatedButton(
                onPressed: _getImage,
                child: Text(
                  'Choose Image',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text(
                  'Add Product',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}