import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapmart/widgets/constant.dart';

import 'messages_page.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _chatsScreen();
  // const ChatsScreen({Key? key}) : super(key: key);
}
  class _chatsScreen extends State<ChatsScreen> {

  List messagers = [];
  // Map products = {};
  Map usersValue = {};
  Map messagesValue = {};
  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance.ref("users")
    // .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            usersValue = o;
          });
        }
      }else{
        if(mounted){
          setState(() {
            usersValue.clear();
          });
        }
      }
    });

    if(FirebaseAuth.instance.currentUser!=null) {
      FirebaseDatabase.instance
          .ref("messages")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .onValue
          .listen((event) {
        if (event.snapshot.exists) {
          Map o = event.snapshot.value as Map;
          if (mounted) {
            setState(() {
              messagesValue = o;
            });
          }
          messagers.clear();
          o.forEach((key, value) {
            if (mounted) {
              setState(() {
                messagers.add(key);
              });
            }
          });
        } else {
          if (mounted) {
            setState(() {
              messagers.clear();
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
        // shadowColor: Colors.white,
        backgroundColor: Colors.white,
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        title:  Text(
          "All Chats",
          style: TextStyle(
            fontSize: 22,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: messagers.isEmpty?Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text("You have no messages yet",style: TextStyle(
              fontSize: 20,color: Colors.black54
          ),),
        ),
      ):ListView.builder(
        itemCount: messagers.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Map o = messagesValue.containsKey(messagers.elementAt(index))?
              messagesValue[messagers.elementAt(index)]:{};
          Map user = usersValue.containsKey(messagers.elementAt(index))?
              usersValue[messagers.elementAt(index)]:{};

        var userImage = user.containsKey("image")?user["image"]:"";
        var userName = user.containsKey("name")?user["name"]:"";

        return InkWell(
          onTap:(){
           Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userName:userName,
               userId:messagers.elementAt(index)),));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical:8),
            margin: EdgeInsets.all(4),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:getImage(userImage),
                    ),

                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        // Opacity(
                        //   opacity: 0.64,
                        //   child: Text(
                        //    " chat.lastMessage",
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Opacity(
                //   opacity: 0.64,
                //   child: Text(chat.time),
                // ),
              ],
            ),
          ),
        );
      },),
    );
  }

  getImage(String userImage) {
    return  userImage.isNotEmpty?NetworkImage(userImage):AssetImage("images/image-not-found.jpg");
  }
}
