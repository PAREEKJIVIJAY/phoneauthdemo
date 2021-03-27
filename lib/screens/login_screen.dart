import 'package:bhavjnapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  

  final formKey = GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  @override
  void initState() {
    super.initState();

    
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("lib/images/logo.png"),
                          fit: BoxFit.fitHeight)),
                ),
                SizedBox(height: 20.0),
                Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              maxLength: 10,
                              //controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                contentPadding:
                                    EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
                                prefixIcon: Icon(Icons.phone),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 32.0),
                                    borderRadius: BorderRadius.circular(25.0)),
                                focusedBorder: OutlineInputBorder(
                                    /*borderSide: BorderSide(
                              color: Colors.white, width: 32.0),*/
                                    borderRadius: BorderRadius.circular(25.0)),
                              ),

                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Mobile No is required';
                                }
                                if (val.length < 10) {
                                  return "invalid number";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                setState(() {
                                  this.phoneNo = val;
                                });
                              },
                            )),
                        SizedBox(height: 20),
                        codeSent
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: 25.0, right: 25.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      hintText: 'Enter OTP',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          25.0, 20.0, 25.0, 20.0),
                                      prefixIcon: Icon(Icons.sms),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 32.0),
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              // color: Colors.white, width: 32.0
                                              ),
                                          borderRadius:
                                              BorderRadius.circular(25.0))),
                                  onSaved: (val) {
                                    setState(() {
                                      this.smsCode = val;
                                    });
                                  },
                                ))
                            : Container(),
                        SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.only(left: 40.0, right: 40.0),
                            child: Container(
                              height: 50.0,
                              child: RaisedButton(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red[400],
                                          Colors.red,
                                          Colors.red[600]

                                          // Color(0xff374ABE),
                                          //Color(0xff64B6FF)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    //width: 80,
                                    //height: 30,
                                    child: Center(
                                        child: codeSent
                                            ? Text('Login',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Helvetica",
                                                    fontSize: 25))
                                            : Text(
                                                'Verify',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Helvetica",
                                                    fontSize: 25),
                                              )),
                                  ),
                                ),
                                onPressed: () {
                                  if (!formKey.currentState.validate()) {
                                    return;
                                  }
                                  formKey.currentState.save();
                                 

                                  codeSent
                                      ? AuthService().signInWithOTP(
                                          smsCode, verificationId)
                                      : verifyPhone(phoneNo);
                                  
                                },
                              ),
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    
    String phoneNoo = "+91" + phoneNo.toString();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNoo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}