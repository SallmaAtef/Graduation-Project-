import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/uploadProduct.dart';
import '../widgets/constant.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _productImage;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productStockController = TextEditingController();
  TextEditingController _productSize = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title:  Row(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 26,
                  color: kPrimaryColor.shade700,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              'Add New Item',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _uploadProductImages(context);
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(80),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: _productImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _productImage!,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Press to pick item Image',
                          style: TextStyle(
                            color: kPrimaryColor.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // _buildUploadedImages(),
            // const SizedBox(height: 20),
            const Text(
              'Item Data',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                  labelText: 'Name',
                  fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productPriceController,
              decoration: InputDecoration(
                  labelText: 'Price',
                  fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productSize,
              decoration: InputDecoration(
                  labelText: 'Size',
                  fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _productStockController,
              decoration: InputDecoration(
                  labelText: 'Quantity',
                  fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
              keyboardType: TextInputType.number,
            ),
            // const SizedBox(height: 20),
            // buildDropdown("Category", categories, (value) {
            //   setState(() {
            //     selectedCategory = value ?? selectedCategory;
            //     selectedSubcategory = ""; // Reset subcategory when category changes
            //   });
            // }),
            // const SizedBox(height: 10),
            // buildDropdown("Subcategory", subcategories[selectedCategory] ?? [], (value) {
            //   setState(() {
            //     selectedSubcategory = value ?? selectedSubcategory;
            //   });
            // }),
            const SizedBox(height: 40),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                onPressed: () {
                  if (_productNameController.text.isNotEmpty &&
                      _productDescriptionController.text.isNotEmpty &&
                      _productPriceController.text.isNotEmpty &&
                      _productStockController.text.isNotEmpty &&
                      // selectedCategory.isNotEmpty &&
                      // selectedSubcategory.isNotEmpty &&
                      _productImage != null) {
                    _saveProduct();
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error All fields are required"),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor.shade700),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: const Text('Add Item',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadProductImages(BuildContext context) async {
    final pickedImages = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (pickedImages != null) {
      var path = pickedImages.path;
      setState(() {
        _productImage = File(path);
      });
    }
  }

  _saveProduct() async {
    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = FirebaseDatabase.instance.ref("products");
    var productId = ref.push().key.toString();
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(currentUid)
        .child("products")
        .child(productId);
    var uploadTask = firebaseStorageRef.putFile(_productImage!);
    var taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((imageUrl) async {
      var upload = UploadProduct(
          productId,
          _productNameController.text.trim(),
          imageUrl,
          _productPriceController.text.trim(),
          _productDescriptionController.text.trim(),
          _productSize.text.trim(),
          _productStockController.text.trim(),
          currentUid);

      ref.child(productId).set(upload.toJson()).then((value) {
        Navigator.pop(context);
        // Navigator.pop(context);
      });
    });

    // Navigator.pop(
    //   context,
    //   Product(
    //     name: _productNameController.text,
    //     description: _productDescriptionController.text,
    //     price: double.parse(_productPriceController.text),
    //     stockStatus: _productStockController.text,
    //     category: selectedCategory,
    //     subcategory: selectedSubcategory,
    //     imageFile: _productImage!,
    //   ),
    // );
  }

  showLoaderDialog(BuildContext context) {
    showGeneralDialog(context: context,
        barrierDismissible: false,

        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                margin: EdgeInsets.all(12),
                height: 140,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 48,vertical: 24),
                child: Column(
                  children: [
                    // SizedBox(width: 24,),
                    Spacer(),
                    Text("Adding new item...",
                      style: TextStyle(fontSize: 18, color: Colors.indigo,fontWeight: FontWeight.bold
                      ),)
                    , SizedBox(height: 24,),
                    SizedBox(
                      width: 140,
                      height: 4,
                      child: LinearProgressIndicator(
                        color: Colors.indigo,
                      ),
                    ),
                    Spacer(),
                  ],),
              ),
            ),
          );
        });
  }

}
