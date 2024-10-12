import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapmart/screens/messages_page.dart';
import 'package:snapmart/widgets/constant.dart';
import 'package:url_launcher/url_launcher.dart';



class ProductScreen extends StatefulWidget {
   Map product;
   ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
    List favorites = [];
    Map users = {};
    @override
    void initState() {
      FirebaseDatabase.instance.ref("users")
          .onValue.listen((event) {
        if(event.snapshot.exists){
          Map o = event.snapshot.value as Map;
          if(mounted){
            setState(() {
              users = o;
            });
          }
        }else{
          if(mounted){
            setState(() {
              users = {};
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
      var from = widget.product["from"];
      Map user = users.containsKey(from)?users[from]:{};
      var driverImage = user.containsKey("image")?user["image"]:"";
      var sellerName = user.containsKey("name")?user["name"]:"";
      var address = user.containsKey("address")?user["address"]:"";
      var latitude = user.containsKey("latitude")?user["latitude"]:"";
      var longitude = user.containsKey("longitude")?user["longitude"]:"";
    return Scaffold(
      // floatingActionButton: AddToCart(
      //   cartItem: cartItem,
      //   currentNumber: currentNumber,
      //   onAdd: increment,
      //   onRemove: decrement,
      //   onAddToCart: (CartItem item){
      //     setState(() {
      //       cartItem = item;
      //       cartItems.add(item);
      //     });
      //   }
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 12),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32,),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:BorderRadius.circular(15),
                      child: Image.network(
                        widget.product["image"],width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withAlpha(40),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_back_ios,size: 28,color: Colors.black,),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Visibility(
                          visible: FirebaseAuth.instance.currentUser!=null,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                if(favorites.contains(widget.product["id"])){
                                  FirebaseDatabase.instance.ref("favorites")
                                      .child(FirebaseAuth.instance.currentUser!.uid.toString())
                                      .child(widget.product["id"]).remove();

                                }else{
                                  FirebaseDatabase.instance.ref("favorites")
                                      .child(FirebaseAuth.instance.currentUser!.uid.toString())
                                      .child(widget.product["id"]).set(widget.product["id"]);

                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:favorites.contains(widget.product["id"])?
                                  Colors.red.withAlpha(30):Colors.grey.withAlpha(30),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:Icon(Icons.favorite,size: 28,color: favorites.contains(widget.product["id"])?
                                    Colors.red:Colors.grey,)
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                    bottom: 100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            widget.product["name"],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12,),
                          const Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4,),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.product["price"]} EGP",
                                    style:  TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor
                                    ),
                                  ),
                                  // const SizedBox(height: 10),
                                ],
                              ),
                              // const Spacer(),
                              // const Text.rich(
                              //   TextSpan(
                              //     children: [
                              //       TextSpan(text: "Seller: "),
                              //       TextSpan(
                              //         text: "Fatma Muhammad",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.product["size"],style: TextStyle(
                        color: Colors.black,fontSize: 20
                      ),),
                      const SizedBox(height: 12),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(widget.product["desc"],style: TextStyle(
                        color: Colors.black,fontSize: 20
                      ),),
                      SizedBox(
                        height: 12,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: (){
                          _launchMapsUrl(double.parse(latitude.toString())
                              ,double.parse(longitude.toString()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(address,style: TextStyle(
                            color: kPrimaryColor.shade700,fontSize: 20
                          ),),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Provider",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: getImage(driverImage),
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                          ),

                          SizedBox(width: 8,),
                          Text(sellerName,style: TextStyle(
                              color: Colors.black,fontSize: 20
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      // const Text(
                      //   "Brand",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.black54,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      SizedBox(height: 8,),



                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: FirebaseAuth.instance.currentUser!=null,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(userName: sellerName,
                        userId: widget.product["from"],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kPrimaryColor.withAlpha(30)
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Chat with Provider",textAlign: TextAlign.center,style: TextStyle(
                      color: kPrimaryColor,fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
    void _launchMapsUrl(double lat, double lon) async {
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

  getImage(driverImage) {
      return driverImage.toString().isNotEmpty?
          NetworkImage(driverImage):AssetImage("images/online-shopping.png");
  }
}

