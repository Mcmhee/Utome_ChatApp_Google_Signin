import 'package:shared_preferences/shared_preferences.dart';

class sharedpreference {
  static String useridkey = "USERKEY";
  static String usernamekey = "USERNAMEKEY";
  static String displaynamekey = "USERDISPLAYNAMEKEY";
  static String useremailkey = "USEREMAILKEY";
  static String userprofilekey = "USERPROFILEKEY";

  Future<bool> saveusername(String getusername) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString(usernamekey, getusername);
  }

  Future<bool> saveuserid(String getuserid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString(useridkey, getuserid);
  }

  Future<bool> saveuseremail(String getuseremail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString(useremailkey, getuseremail);
  }

  Future<bool> saveuserdisplayname(String getuserdisplayname) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString(displaynamekey, getuserdisplayname);
  }

  Future<bool> saveuserprofileurl(String getuserprofile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.setString(userprofilekey, getuserprofile);
  }

//get functions
  Future<String> getusername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(useridkey);
  }

  Future<String> getuseremail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(useremailkey);
  }

  Future<String> getuserid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(useridkey);
  }

  Future<String> getuserprofilepicurl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userprofilekey);
  }

  Future<String> getuserdisplayname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(displaynamekey);
  }
}
