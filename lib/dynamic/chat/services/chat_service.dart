import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edificators_hub_mobile/dynamic/chat/models/message_model.dart';

class ChatService {
  // REGISTER USER
  static Future<void> registerChatUser(
      String userId, String name, String profileUrl) async {
    // CHATS COLLECTION
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(userId)
        .collection(userId)
        .doc("INITIALS")
        .set({
      "userId": "initial",
      "timestamp": "initial",
      "message": "initial",
      "profileUrl": "initial",
      "name": "initial"
    });
  }

  // ADD MESSAGE
  static Future<void> addMessage(MessageModel message, senderName, receiverName, senderProfile, receiverProfile) async {
    var map = message.toJson();

    await FirebaseFirestore.instance
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId)
        .doc()
        .set(map);

    populateChatList(message, senderName, receiverName, senderProfile, receiverProfile);

    await FirebaseFirestore.instance
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .doc()
        .set(map);
  }

  static Future populateChatList(MessageModel message, senderName, receiverName, senderProfile, receiverProfile) async {
    //CHECK SENDER
    DocumentSnapshot snapshotSender = await FirebaseFirestore.instance
        .collection("chats")
        .doc(message.senderId)
        .collection(message.senderId)
        .doc(message.receiverId)
        .get();

    if (snapshotSender.exists) {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(message.senderId)
          .collection(message.senderId)
          .doc(message.receiverId)
          .update({
        "userId": message.receiverId,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profileUrl": receiverProfile ?? "",
        "name": receiverName,
      });
    } else {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(message.senderId)
          .collection(message.senderId)
          .doc(message.receiverId)
          .set({
        "userId": message.receiverId,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profileUrl": receiverProfile ?? "",
        "name": receiverName,
      });
    }

    //CHECK RECEIVER
    DocumentSnapshot snapshotReceiver = await FirebaseFirestore.instance
        .collection("chats")
        .doc(message.receiverId)
        .collection(message.receiverId)
        .doc(message.senderId)
        .get();

    if (snapshotReceiver.exists) {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(message.receiverId)
          .collection(message.receiverId)
          .doc(message.senderId)
          .update({
        "userId": message.senderId,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profileUrl": senderProfile ?? "",
        "name": senderName,
      });
    } else {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(message.receiverId)
          .collection(message.receiverId)
          .doc(message.senderId)
          .set({
        "userId": message.senderId,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profileUrl": senderProfile ?? "",
        "name": senderName,
      });
    }
  }

}
