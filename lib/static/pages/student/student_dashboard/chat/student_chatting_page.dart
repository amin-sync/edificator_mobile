// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../commons/colors.dart';
import '../../../../../commons/loader.dart';
import '../../../../../commons/utility.dart';
import '../../../../../dynamic/chat/models/message_model.dart';
import '../../../../../dynamic/chat/services/chat_service.dart';
import '../../../../../dynamic/providers/user_provider.dart';
import '../../../../widgets/texts/custom_text.dart';

class StudentChattingPage extends StatefulWidget {
  final String receiverUserId;
  final String currentUserId;
  final String receiverName;
  final String receiverProfileUrl;
  const StudentChattingPage({super.key, required this.receiverName, required this.receiverProfileUrl, required this.receiverUserId, required this.currentUserId});

  @override
  State<StudentChattingPage> createState() => _StudentChattingPageState();
}

class _StudentChattingPageState extends State<StudentChattingPage> {
  bool isWriting = false;
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: MyColor.whiteColor,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: MyColor.tealColor,
          title: CustomText(
            text: widget.receiverName,
            fontSize: 18,
            color: MyColor.whiteColor,
            fontWeight: FontWeight.w700,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyColor.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(userProvider),
          ),
          chatControls(userProvider),
        ],
      ),
    );
  }

  Widget messageList(UserProvider userProvider) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .doc(widget.currentUserId)
          .collection(widget.receiverUserId)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: Loader());
        }
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Container(
        alignment: snapshot['senderId'] == widget.currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderId'] ==  widget.currentUserId
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    if (snapshot['senderId'] == widget.currentUserId) {
      return Padding(
        padding: EdgeInsets.only(left: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: MyColor.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: MyColor.greyColor,
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  snapshot['message'],
                  style: TextStyle(color: MyColor.tealColor),
                ),
              ),
            ),
            snapshot['senderId'] == widget.currentUserId
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  Utility.readTimestamp(snapshot["timestamp"]),
                  style: TextStyle(
                    fontSize: 12, color: MyColor.greyColor,),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
                : Container(
            ),
          ],
        ),
      );
    } else{
      return Container();
    }
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    if (snapshot['senderId'] != widget.currentUserId) {
      return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                // constraints: BoxConstraints(),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: MyColor.tealColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  snapshot['message'],
                  style: TextStyle(color: MyColor.whiteColor,),
                ),
              ),
            ),
            snapshot['receiverId'] == widget.currentUserId
                ? Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utility.readTimestamp(snapshot["timestamp"]),
                    style: TextStyle(
                      fontSize: 12, color: MyColor.greyColor,),
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            )
                : Container(child: null),
          ],
        ),
      );
    } else{
      return Container();
    }
  }

  Widget chatControls(UserProvider userProvider) {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;

      MessageModel _message = MessageModel(
        receiverId: widget.receiverUserId,
        senderId: widget.currentUserId,
        message: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      setState(() {
        isWriting = false;
      });

      ChatService.addMessage(_message, userProvider.getUserProfileState.response!.fullName, widget.receiverName, userProvider.getUserProfileState.response!.profileUrl, widget.receiverProfileUrl);
      textFieldController.clear();
    }

    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(color: theme.primaryColor),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Send message...",
                hintStyle: TextStyle(
                  color: MyColor.greyColor,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Colors.white60)),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: MyColor.whiteColor,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(shape: BoxShape.circle,  color: MyColor.blueColor,),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 25,
                  color: MyColor.whiteColor,
                ),
                onPressed: () => sendMessage(),
              ))
        ],
      ),
    );
  }
}
