import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_app/helper/shared_preference.dart';
import 'package:first_flutter_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class chatRoom extends StatefulWidget {
  final String chatwithusername, name;
  chatRoom(this.chatwithusername, this.name);

  @override
  _chatRoomState createState() => _chatRoomState();
}

class _chatRoomState extends State<chatRoom> {
  String chatroomid, messageid = "";
  Stream messagestream;
  String myname, myprofilepic, myusername, myemail;
  TextEditingController messagetextedittingcontroller = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myname = await sharedpreference().getuserdisplayname();
    myprofilepic = await sharedpreference().getuserprofilepicurl();
    myusername = await sharedpreference().getusername();
    myemail = await sharedpreference().getuseremail();

    chatroomid = getchatroomidbyusernames(widget.chatwithusername, myusername);
  }

  getchatroomidbyusernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addmessage(bool sendClicked) {
    if (messagetextedittingcontroller.text != "") {
      String message = messagetextedittingcontroller.text;

      var lastmessageTs = DateTime.now();

      Map<String, dynamic> messageinfomap = {
        "message": message,
        "sendBy": myusername,
        "ts": lastmessageTs,
        "imgUrl": myprofilepic
      };

      //messageId
      if (messageid == "") {
        messageid = randomAlphaNumeric(12);
      }

      databasemethods()
          .addmessage(chatroomid, messageid, messageinfomap)
          .then((value) {
        Map<String, dynamic> lastmessageinfomap = {
          "lastMessage": message,
          "lastMessageSendTs": lastmessageTs,
          "lastMessageSendBy": myusername
        };

        databasemethods().updatelastmessagesend(chatroomid, lastmessageinfomap);

        if (sendClicked) {
          // remove the text in the message input field
          messagetextedittingcontroller.text = "";
          // make message id blank to get regenerated on next message send
          messageid = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? Color(0xB0A74F98) : Color(0xfff1f0f0),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatmessages() {
    return StreamBuilder(
      stream: messagestream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                      ds["message"], myusername == ds["sendBy"]);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getandsetmessages() async {
    messagestream = await databasemethods().getchatroommessages(chatroomid);
    setState(() {});
  }

  dothisonlaunch() async {
    await getMyInfoFromSharedPreference();
    getandsetmessages();
  }

  @override
  void initState() {
    dothisonlaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            chatmessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.9),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attachment_sharp),
                      iconSize: 25.0,
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    Expanded(
                        child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: messagetextedittingcontroller,
                      onChanged: (value) {
                        addmessage(false);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintText: "type a message",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                    )),
                    GestureDetector(
                      onTap: () {
                        addmessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
