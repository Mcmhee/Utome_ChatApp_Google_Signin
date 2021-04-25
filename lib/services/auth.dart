import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/helper/shared_preference.dart';
import 'package:first_flutter_app/views/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';

class AuthFunctions {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getcurrentuser() {
    return auth.currentUser;
  }

  signinwithgoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googlesignin = GoogleSignIn();

    final GoogleSignInAccount googlesigninaccount =
        await _googlesignin.signIn();

    final GoogleSignInAuthentication googlesigninauthentication =
        await googlesigninaccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googlesigninauthentication.idToken,
        accessToken: googlesigninauthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    //result.user.sososo

    User userDetails = result.user;

    if (result != null) {
      sharedpreference().saveuseremail(userDetails.email);
      sharedpreference().saveuserid(userDetails.uid);
      sharedpreference().saveuserdisplayname(userDetails.displayName);
      sharedpreference().saveuserprofileurl(userDetails.photoURL);
      sharedpreference()
          .saveusername(userDetails.email.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userinfomap = {
        "email": userDetails.email,
        "username": userDetails.email.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL
      };

      databasemethods()
          .adduserinfotodb(userDetails.uid, userinfomap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home()));
      });
    }

    // ignore: unused_element
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
