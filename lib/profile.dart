import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ordini/email_login.dart';

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Padding(
        //  padding: EdgeInsets.all(5.0),
        //  child: Center(
        //    child: Text('UserId: ' + FirebaseAuth.instance.currentUser.uid),
        //  ),
        //),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: FirebaseAuth.instance.currentUser.displayName != null
              ? Center(
                  child: Text(FirebaseAuth.instance.currentUser.displayName),
                )
              : Center(
                  child: Text('Nome non impostato'),
                ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: Text('Email: ' + FirebaseAuth.instance.currentUser.email),
          ),
        ),
        //Padding(
        //  padding: EdgeInsets.all(5.0),
        //  child: OutlineButton(
        //    color: Colors.lightBlue,
        //    onPressed: () {
        //      FirebaseAuth auth = FirebaseAuth.instance;
        //      auth.currentUser.updateProfile(
        //          displayName: "Andrea Possidente", photoURL: null);
        //    },
        //    child: Text(
        //      'Imposta Nome',
        //      style: new TextStyle(
        //        fontSize: 17.0,
        //      ),
        //    ),
        //  ),
        //),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 40.0,
              child: OutlineButton(
                color: Colors.lightBlue,
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut().then((res) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => EmailLogIn()),
                        (Route<dynamic> route) => false);
                  });
                },
                child: Text(
                  'Esci',
                  style: new TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
