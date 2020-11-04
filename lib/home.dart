import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ordini/addorder.dart';
import 'package:ordini/globals.dart';

import 'package:ordini/dashboard.dart';
import 'package:ordini/orderdetail.dart';
import 'package:ordini/orders.dart';
import 'package:ordini/profile.dart';

class Home extends StatefulWidget {
  final String uid;
  //static String title;

  Home({Key key, this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  void fcmSubscribe() {
    firebaseMessaging.subscribeToTopic('AllDevices');
    print("subscribed");
  }

  void fcmUnSubscribe() {
    firebaseMessaging.unsubscribeFromTopic('AllDevices');
  }

  int _currentIndex = 0;
  bool refresh = false;
  final List<Widget> _children = [
    DashboardWidget(),
    OrdersWidget(),
    //ProductsWidget(),
    ProfileWidget()
  ];

  getAction(int body) {
    switch (body) {
      case 0:
        return [Container()];
      case 1:
        return [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              DocumentReference result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrder(),
                ),
              );
              if (result != null) {
                FirebaseFirestore db = FirebaseFirestore.instance;
                DocumentSnapshot qn =
                    await db.collection("orders").doc(result.id).get();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetail(
                      snapshot: qn.data(),
                      isPagato: qn.data()["pagato"],
                      isConsegnato: qn.data()["stato"],
                    ),
                  ),
                );
              }
            },
          )
        ];
      case 2:
        return [Container()];
      case 3:
        return [Container()];
    }
  }

  @override
  Widget build(BuildContext context) {
    fcmSubscribe();
    return Scaffold(
      appBar: AppBar(
        title: Text(titolo),
        actions: getAction(_currentIndex),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.lightBlue[800],
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.white,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))),
        child: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.next_week),
              label: 'Ordini',
            ),
            //BottomNavigationBarItem(
            //  icon: new Icon(Icons.add_business),
            //  label: 'Prodotti',
            //),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo')
          ],
        ),
      ),
    );
    //drawer: NavigateDrawer(uid: widget.uid));
  }

  void onTabTapped(int index) {
    setState(() {
      if (index == 0) {
        titolo = "Dashboard";
      } else if (index == 1) {
        titolo = "Ordini";
        //} else if (index == 2) {
        //  titolo = "Prodotti";
      } else if (index == 2) {
        titolo = "Profilo";
      }
      _currentIndex = index;
    });
  }
}

//class NavigateDrawer extends StatefulWidget {
//  final String uid;
//  NavigateDrawer({Key key, this.uid}) : super(key: key);
//  @override
//  _NavigateDrawerState createState() => _NavigateDrawerState();
//}
//
//class _NavigateDrawerState extends State<NavigateDrawer> {
//  @override
//  Widget build(BuildContext context) {
//    return Drawer(
//      child: ListView(
//        padding: EdgeInsets.zero,
//        children: <Widget>[
//          UserAccountsDrawerHeader(
//            accountEmail: FutureBuilder(
//                future: FirebaseDatabase.instance
//                    .reference()
//                    .child("Users")
//                    .child(widget.uid)
//                    .once(),
//                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
//                  if (snapshot.hasData) {
//                    return Text(snapshot.data.value['email']);
//                  } else {
//                    return CircularProgressIndicator();
//                  }
//                }),
//            accountName: FutureBuilder(
//                future: FirebaseDatabase.instance
//                    .reference()
//                    .child("Users")
//                    .child(widget.uid)
//                    .once(),
//                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
//                  if (snapshot.hasData) {
//                    return Text(snapshot.data.value['name']);
//                  } else {
//                    return CircularProgressIndicator();
//                  }
//                }),
//            decoration: BoxDecoration(
//              color: Colors.blue,
//            ),
//          ),
//          ListTile(
//            leading: new IconButton(
//              icon: new Icon(Icons.home, color: Colors.black),
//              onPressed: () => null,
//            ),
//            title: Text('Home'),
//            onTap: () {
//              print(widget.uid);
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => Home(uid: widget.uid)),
//              );
//            },
//          ),
//          ListTile(
//            leading: new IconButton(
//              icon: new Icon(Icons.settings, color: Colors.black),
//              onPressed: () => null,
//            ),
//            title: Text('Settings'),
//            onTap: () {
//              print(widget.uid);
//            },
//          ),
//        ],
//      ),
//    );
//  }
//}
