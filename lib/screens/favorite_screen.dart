import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snapmart/screens/product_screen.dart';
import 'package:snapmart/widgets/constant.dart';

class FavoritePage extends StatefulWidget {

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List favorites = [];
  Map products = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("products").onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            products = o;
          });
        }
      }
    });

    if(FirebaseAuth.instance.currentUser!=null) {
      FirebaseDatabase.instance
          .ref("favorites")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          Map o = event.snapshot.value as Map;
          favorites.clear();
          o.forEach((key, value) {
            if (mounted) {
              setState(() {
                favorites.add(key);
              });
            }
          });
        } else {
          if (mounted) {
            setState(() {
              favorites.clear();
            });
          }
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Favorites',style: TextStyle(
          color: kPrimaryColor,fontWeight: FontWeight.bold,
          fontSize: 22
        ),),
        // leading: IconButton(
        //   icon: Icon(Icons.ar,color: Colors.black,),
        //   onPressed: (){
        //     //Navigator.of(context).pop();
        //     },
        // ),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        itemBuilder: (context, index) {
          Map product = products.containsKey(favorites.elementAt(index))?
          products[favorites.elementAt(index)]:{};
          var image = product.containsKey("image")?product["image"]:"";
          var name = product.containsKey("name")?product["name"]:"";
          var price = product.containsKey("price")?product["price"]:"";
          var desc = product.containsKey("desc")?product["desc"]:"";
          var id = product.containsKey("id")?product["id"]:"";
          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductScreen(product: product),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                ClipRRect(
                  borderRadius:BorderRadius.circular(15),
                  child: Image.network(
                    image,width: 140,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
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
                      Text(desc,style: TextStyle(
                          color: Colors.black54,fontWeight: FontWeight.normal
                          ,fontSize: 18
                      ),),
                    ],
                  ),
                ),
                InkWell(
                  onTap:(){
                    FirebaseDatabase.instance.ref("favorites")
                        .child(FirebaseAuth.instance.currentUser!.uid.toString()).child(id).remove();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.delete_outline,color: Colors.red,size: 28,),
                  ),
                )


              ],
            ),
          );
        },),
    );
  }
}