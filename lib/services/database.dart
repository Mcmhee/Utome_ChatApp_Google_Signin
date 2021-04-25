import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_app/helper/shared_preference.dart';

// ignore: camel_case_types
class databasemethods {
  Future adduserinfotodb(
      String userId, Map<String, dynamic> userinfomap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userinfomap);
  }

  Future<Stream<QuerySnapshot>> getuserbyusername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addmessage(
      String chatroomid, String messageid, Map messageinfomap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomid)
        .collection("chats")
        .doc(messageid)
        .set(messageinfomap);
  }

  updatelastmessagesend(String chatroomid, Map lastmessageinfomap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomid)
        .update(lastmessageinfomap);
  }

  createchatroom(String chatroomid, Map chatroominfomap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomid)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomid)
          .set(chatroominfomap);
    }
  }

  Future<Stream<QuerySnapshot>> getchatroommessages(chatroomid) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatroomid)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getchatrooms() async {
    String myUsername = await sharedpreference().getusername();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastmessagesendTs", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getuserinfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}
