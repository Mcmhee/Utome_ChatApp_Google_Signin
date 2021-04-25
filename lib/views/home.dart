import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_flutter_app/helper/shared_preference.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:first_flutter_app/services/database.dart';
import 'package:first_flutter_app/views/signin.dart';
import 'package:flutter/material.dart';

import 'chatscreen.dart';

class home extends StatefulWidget {
  home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool isSearching = false;
  String myName, myProfilePic, myUserName, myEmail;
  Stream usersStream, chatRoomsStream;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await sharedpreference().getuserdisplayname();
    myProfilePic = await sharedpreference().getuserprofilepicurl();
    myUserName = await sharedpreference().getusername();
    myEmail = await sharedpreference().getuseremail();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await databasemethods()
        .getuserbyusername(searchUsernameEditingController.text);

    setState(() {});
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(ds["lastMessage"], ds.id, myUserName);
                })
            : Center(
                child: Text(
                "Chat List Empty...Search for your friends",
                style: TextStyle(
                    color: Color(0xff854bb0),
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ));
      },
    );
  }

  Widget searchListUserTile({String profileUrl, name, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };
        databasemethods().createchatroom(chatRoomId, chatRoomInfoMap);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => chatRoom(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name), Text(email)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return searchListUserTile(
                      profileUrl: ds["imgUrl"],
                      name: ds["name"],
                      email: ds["email"],
                      username: ds["username"]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await databasemethods().getchatrooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  onAddButtonTapped<Widget>() {
    return Column(
      children: [
        Container(
          height: 30.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    isSearching
                        ? GestureDetector(
                            onTap: () {
                              isSearching = false;
                              searchUsernameEditingController.text = "";
                              setState(() {});
                            },
                            child: Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.arrow_back)),
                          )
                        : Container(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(24)),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "username"),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                isSearching ? searchUsersList() : chatRoomsList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onSearchBtnClick();
        },
        child: Icon(Icons.add, size: 40),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 9.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          'UToMe',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.outbond_outlined),
            iconSize: 40.0,
            color: Colors.white,
            onPressed: () {
              AuthFunctions().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => signin()));
              });
            },
          ),
        ],
      ),
      body: onAddButtonTapped(),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastmessage, chatroomid, myusername;
  ChatRoomListTile(this.lastmessage, this.chatroomid, this.myusername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatroomid.replaceAll(widget.myusername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await databasemethods().getuserinfo(username);
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["imgUrl"]}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => chatRoom(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastmessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}
