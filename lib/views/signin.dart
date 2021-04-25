import 'package:first_flutter_app/services/FadeAnimation.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class signin extends StatefulWidget {
  signin({Key key}) : super(key: key);

  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  TextEditingController email = TextEditingController();
  TextEditingController a = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Container(
            height: h / 1.2,
            width: w,
            child: RotatedBox(
              quarterTurns: 0,
              child: FlareActor(
                'lib/assets/images/curve.flr',
                animation: 'Flow',
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fill,
                // isPaused: x,
              ),
            ),
          ),
          Center(
            child: FadeAnimation(
              1.7,
              Container(
                margin: EdgeInsets.only(top: w / 4, left: w / 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "UtoMe ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Welcome Back ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Please Sign In with Your Google Account ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: h / 1.3),
              height: h / 12,
              width: h / 5,
              child: RaisedButton(
                color: Color(0xff854bb0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 3,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  AuthFunctions().signinwithgoogle(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
