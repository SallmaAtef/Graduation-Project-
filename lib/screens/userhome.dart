import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snapmart/screens/product_screen.dart';
import 'package:snapmart/screens/profile.dart';
import 'package:snapmart/screens/takephoto.dart';
import 'dart:convert';

import '../widgets/constant.dart';
import 'enter.dart';

class UserHome extends StatefulWidget {
  static String id = 'UserHome';

  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final TextEditingController _searchController = TextEditingController();
  List<Map> _products = []; // List to store fetched products
  List<String> _filteredProducts = []; // List to store filtered products
  Map productsValue = {};
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }
  List favorites = [];

  // Example function to fetch products from a fake API
  Future<void> _fetchProducts() async {
 FirebaseDatabase.instance.ref("products").onValue.listen((event) {
   if(event.snapshot.exists){
     Map o = event.snapshot.value as Map;
     if(mounted){
       setState(() {
         productsValue = o;
       });
     }
     _products.clear();
     o.forEach((key, value) {
       if(mounted){
         setState(() {
           _products.add(value);
         });
       }
     });
   }else{
     if(mounted){
       setState(() {
         _products.clear();
         productsValue.clear();
       });
     }
   }
 });

 if(FirebaseAuth.instance.currentUser!=null){
   FirebaseDatabase.instance.ref("favorites")
       .child(FirebaseAuth.instance.currentUser!.uid.toString())
       .onValue.listen((event) {
     if(event.snapshot.exists){
       Map o = event.snapshot.value as Map;
       favorites.clear();
       o.forEach((key, value) {
         if(mounted){
           setState(() {
             favorites.add(key);
           });
         }
       });
     }else{
       if(mounted){
         setState(() {
           favorites.clear();
         });
       }
     }
   });
 }

  }

  void searchProducts(String s) {
    setState(() {
      _products.clear();
    });
    productsValue.forEach((key, value) {
      var name = value["name"];
      if(name.toString().toLowerCase().contains(s)){
        setState(() {
          _products.add(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 64,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  'SNAPMART',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (s){
                      searchProducts(s);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Products',
                      filled: true,
                      fillColor: kPrimaryColor.withAlpha(40),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45),
                        borderSide: BorderSide.none
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _products.length,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      Map product = _products.elementAt(index);
                      var image = product["image"];
                      var name = product["name"];
                      var price = product["price"];
                      var desc = product["desc"];
                      var id = product["id"];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(product: product),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withAlpha(20)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    ClipRRect(
                                      borderRadius:BorderRadius.circular(15),
                                      child: Image.network(
                                        image,width: double.infinity,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(name,style: TextStyle(
                                              color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20
                                          ),),
                                          SizedBox(height: 8,),
                                          Text(price+" EGP",style: TextStyle(
                                              color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 18
                                          ),),
                                          SizedBox(height: 8,),
                                          Text(desc,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                                              color: Colors.black54,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal
                                              ,fontSize: 18
                                          ),),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                              Visibility(
                                visible: FirebaseAuth.instance.currentUser!=null,
                                child: Align(
                                  alignment:Alignment.topRight,
                                  child: InkWell(
                                    onTap:(){
                                      if(favorites.contains(id)){
                                        FirebaseDatabase.instance.ref("favorites")
                                            .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(id).remove();

                                      }else{
                                        FirebaseDatabase.instance.ref("favorites")
                                            .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(id).set(id);

                                      }
                                    },
                                    child:  Container(
                                      decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade300
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.favorite,color: favorites.contains(id)?Colors.red:Colors.black45,size: 28,),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,childAspectRatio: 0.73,crossAxisSpacing: 8),),

                  // ListView.builder(
                  //   itemCount: _filteredProducts.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text(_filteredProducts[index]),
                  //       // Add onTap action for product details if needed
                  //     );
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ],
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
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
