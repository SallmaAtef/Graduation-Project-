import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/uploadProduct.dart';
import '../widgets/constant.dart';

class EditProductScreen extends StatefulWidget {
  Map product;

  EditProductScreen({ required this.product});

  @override
  _editProductScreen createState() => _editProductScreen();
}

class _editProductScreen extends State<EditProductScreen> {
  File? _productImage;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productStockController = TextEditingController();
  TextEditingController _productSize = TextEditingController();

  var imageUrl = "";
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _productNameController.text = widget.product["name"];
      _productDescriptionController.text = widget.product["desc"];
      _productPriceController.text = widget.product["price"];
      _productStockController.text = widget.product["stock"];
      _productSize.text = widget.product["size"];
      imageUrl = widget.product["image"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.arrow_back_ios,size: 26,color: kPrimaryColor.shade700,),
              ),
            ),
            SizedBox(width: 12,),
            Text('Edit Item',style: TextStyle(
              color: kPrimaryColor,fontWeight: FontWeight.bold
            ),),
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
                  child: _productImage!=null
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
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black54),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productNameController,
              decoration:  InputDecoration(labelText: 'Name',
              fillColor: kPrimaryColor.withAlpha(40),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide: BorderSide.none
              )),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productPriceController,
              decoration:  InputDecoration(labelText: 'Price', fillColor: kPrimaryColor.withAlpha(40),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45),
                      borderSide: BorderSide.none
                  )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productDescriptionController,
              decoration:  InputDecoration(labelText: 'Description' ,
                  fillColor: kPrimaryColor.withAlpha(40),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                )),
              maxLines: 3,

            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _productSize,
              decoration:  InputDecoration(labelText: 'Size' ,
                  fillColor: kPrimaryColor.withAlpha(40),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                )),
              maxLines: 3,

            ),

            const SizedBox(height: 10),
            TextFormField(
              controller: _productStockController,
              decoration:  InputDecoration(labelText: 'Quantity' ,
    fillColor: kPrimaryColor.withAlpha(40),
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(45),
    borderSide: BorderSide.none
    )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_productNameController.text.isNotEmpty &&
                            _productDescriptionController.text.isNotEmpty &&
                            _productPriceController.text.isNotEmpty &&
                            _productStockController.text.isNotEmpty


                           ){
                          _saveProduct();
                        }
                      },
                      // _canSaveProduct() ?  : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        kPrimaryColor.shade700
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: const Text('Save Changes',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      onPressed: () {
                      FirebaseDatabase.instance.ref("products").child(widget.product["id"]).remove().then((value){
                        // Navigator.pop(context);
                        Navigator.pop(context);
                      });
                      },
                      // _canSaveProduct() ?  : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.red
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _uploadProductImages(BuildContext context) async {
    final pickedImages = await ImagePicker().
    pickImage(source: ImageSource.gallery,imageQuality: 30);
    if (pickedImages!=null) {
      var path = pickedImages.path;
      setState(() {
        _productImage = File(path);
      });
    }
  }





  _saveProduct() async {

    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();
    var ref = FirebaseDatabase.instance.ref("products");
    var productId = widget.product["id"];
    if(_productImage!=null){
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(currentUid)
          .child("products").child(productId);
      var uploadTask = firebaseStorageRef.putFile(_productImage!);
      var taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (imageUrl) async {

            var upload = UploadProduct(
                productId,
                _productNameController.text.trim(),
                imageUrl,
                _productPriceController.text.trim(),
                _productDescriptionController.text.trim(),
                _productSize.text.trim(),
                _productStockController.text.trim(),
                currentUid
            );

            ref
                .child(productId).set(upload.toJson()).then((value) {
              Navigator.pop(context);
              // Navigator.pop(context);
            });
          });


    }else{
      var upload = UploadProduct(
          productId,
          _productNameController.text.trim(),
          imageUrl,
          _productPriceController.text.trim(),
          _productDescriptionController.text.trim(),
          _productSize.text.trim(),
          _productStockController.text.trim(),
          currentUid
      );

      ref
          .child(productId).set(upload.toJson()).then((value) {
        Navigator.pop(context);
        // Navigator.pop(context);
      });
    }

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
}
