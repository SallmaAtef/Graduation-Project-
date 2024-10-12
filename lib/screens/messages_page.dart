import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapmart/widgets/constant.dart';

import '../models/uploadMessage.dart';

class ChatPage extends StatefulWidget {

  String userId;
  String userName;
  // Map userVa
  ChatPage({
    required this.userName,
    required this.userId});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final List<ChatMessage> _messages = [];
  // final TextEditingController _textController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List messages = [];
  // Map products = {};
  Map usersValue = {};
  Map messagesValue = {};
  @override
  void initState() {
    FirebaseDatabase.instance.ref("messages")
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(widget.userId).orderByChild("time")
        .onValue.listen((event) {
      if(event.snapshot.exists){
        Map o = event.snapshot.value as Map;
        if(mounted){
          setState(() {
            messagesValue = o;
          });
        }
        messages.clear();
        for(var v in event.snapshot.children){
          if(mounted){
            setState(() {
              messages.add(v.value);
            });
          }
        }
        o.forEach((key, value) {

        });
      }else{
        if(mounted){
          setState(() {
            messages.clear();
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print("AAAAAAAAAAAAAa $messages");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,

        title: Text(
          widget.userName,
          style: TextStyle(
            color: kPrimaryColor,
          ),
        ),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: kPrimaryColor,size: 28,)),
        backgroundColor:Colors.white,
        // leading: Transform(
        //   alignment: Alignment.center,
        //   transform: Matrix4.rotationY(3.14159265),
        //   child: IconButton(
        //     color: Colors.white,
        //     icon: Icon(Icons.close_rounded),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // controller: _scrollController,
              padding: EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: messages.elementAt(index)["from"]==FirebaseAuth.instance.currentUser!.uid.toString()
                        ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: messages.elementAt(index)["from"]==FirebaseAuth.instance.currentUser!.uid.toString() ? 
                         kPrimaryColor.withAlpha(90) : Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(messages.elementAt(index)["from"]==FirebaseAuth.instance.currentUser!.uid.toString() ? 12.0 : 0.0),
                            topRight: Radius.circular(messages.elementAt(index)["from"]==FirebaseAuth.instance.currentUser!.uid.toString() ? 0.0 : 12.0),
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (messages.elementAt(index)["type"].toString() == "text")
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  messages.elementAt(index)["message"].toString(),
                                  style: TextStyle(
                                    color:  Colors.black,
                                  ),
                                ),
                              ),
                            if (messages.elementAt(index)["type"] == "image")
                              Image.network(
                                messages.elementAt(index)["message"].toString(),
                                width: 300,
                                height: 240,
                                fit: BoxFit.cover,
                              ),
                            SizedBox(height: 4.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                );;
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(45.0),
                
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          color: kPrimaryColor,
                          icon: Icon(Icons.add_a_photo_outlined),
                          onPressed: () {
                            _handleImageSelection(context);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                        // onSubmitted: onSendMessage,
                      ),
                    ),
                    IconButton(
                      color: kPrimaryColor,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if(textController.text.trim().toString().isNotEmpty){
                          var upload = UploadMessage(FirebaseAuth.instance.currentUser!.uid.toString(),
                              "text",textController.text.trim().toString(),
                              "no", DateTime.now().microsecondsSinceEpoch);
                          var mId = FirebaseDatabase.instance.ref("messages").child(widget.userId)
                              .child(FirebaseAuth.instance.currentUser!.uid.toString()).push().key.toString();
                          FirebaseDatabase.instance.ref("messages")
                              .child(widget.userId).child(FirebaseAuth.instance.currentUser!.uid.toString()).child(mId).set(upload.toJson()).then((value){
                            var uploadMe = UploadMessage(
                                FirebaseAuth.instance.currentUser!.uid.toString(),"text",
                                textController.text.trim().toString(),
                                "seen", DateTime.now().microsecondsSinceEpoch);
                            FirebaseDatabase.instance.ref("messages")
                                .child(FirebaseAuth.instance.currentUser!.uid.toString())
                                .child(widget.userId)
                                .child(mId).set(uploadMe.toJson()).then((value){
                                 setState(() {
                                   textController.text = "";
                                 });
                          });
                          });
                        }else{

                        }
                        // onSendMessage(textController.text);
                      },
                    ),
                  ],
                ),
              ),
            )
            // ChatInput(
            //   textController: _textController,
            //   onSendMessage: _handleSendMessage,
            //   onSendImage: _handleSendImage,
            // ),
          ),
        ],
      ),
    );
  }

  void _handleImageSelection(BuildContext context) async {
    var currentUid = FirebaseAuth.instance.currentUser!.uid.toString();

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      showDialog(context: context, builder: (context) => Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),);
      // onSendImage(File(pickedFile.path));
      var firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(currentUid)
          .child("messages").child(widget.userId);
      var uploadTask = firebaseStorageRef.putFile(File(pickedFile.path)!);
      var taskSnapshot = await uploadTask;
      taskSnapshot.ref.getDownloadURL().then(
              (imageUrl) async {
                var upload = UploadMessage(FirebaseAuth.instance.currentUser!.uid.toString(),
                    "image",imageUrl,
                    "no", DateTime.now().microsecondsSinceEpoch);
                var mId = FirebaseDatabase.instance.ref("messages").child(widget.userId)
                    .child(FirebaseAuth.instance.currentUser!.uid.toString()).push().key.toString();
                FirebaseDatabase.instance.ref("messages")
                    .child(widget.userId).child(FirebaseAuth.instance.currentUser!.uid.toString()).child(mId).set(upload.toJson()).then((value){
                  var uploadMe = UploadMessage(
                      FirebaseAuth.instance.currentUser!.uid.toString(),"image",
                      imageUrl,
                      "seen", DateTime.now().microsecondsSinceEpoch);
                  FirebaseDatabase.instance.ref("messages")
                      .child(FirebaseAuth.instance.currentUser!.uid.toString())
                      .child(widget.userId)
                      .child(mId).set(uploadMe.toJson()).then((value){
                        Navigator.pop(context);
                    setState(() {
                      textController.text = "";
                    });
                  });
                });
              });
          }
  }

}


