import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ordini/orderdetail.dart';

class OrdersWidget extends StatefulWidget {
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  void reload() {
    setState(() {
      getOrders();
    });
  }

  getStato(bool x) {
    if (x == false) {
      return new Container(
        child: Text(
          "Inviato",
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        decoration: new BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: new EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
      );
    } else {
      return new Container(
        child: Text(
          "Consegnato",
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        decoration: new BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: new EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
      );
    }
  }

  getPagato(bool x) {
    if (x == false) {
      return new Container(
        child: Text(
          "Da Saldare",
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: new EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
      );
    } else {
      return new Container(
        child: Text(
          "Pagato",
          style: TextStyle(
              fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        decoration: new BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        padding: new EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
      );
    }
  }

  Future getOrders() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot qn = await db
        .collection("orders")
        .orderBy('created_at', descending: true)
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new RefreshIndicator(
        onRefresh: () {
          reload();
          return getOrders();
        },
        child: FutureBuilder(
          future: getOrders(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Caricamento Ordini"),
              );
            } else {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        onTap: (() => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetail(
                                    snapshot: snapshot.data[index],
                                    isPagato: snapshot.data[index]["pagato"],
                                    isConsegnato: snapshot.data[index]["stato"],
                                  ),
                                ),
                              ).then((value) => setState(() {})),
                            }),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 10.0, top: 5.0),
                                  child: new Container(
                                    child: Text(
                                      (DateFormat('yyyy-MM-dd kk:mm').format(
                                                  DateTime.parse(snapshot
                                                      .data[index]["created_at"]
                                                      .toDate()
                                                      .toString())))
                                              .toString() +
                                          " di " +
                                          snapshot.data[index]["creatore"],
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    padding: new EdgeInsets.fromLTRB(
                                        6.0, 3.0, 6.0, 3.0),
                                  )),
                              Text(snapshot.data[index]["cliente"],
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700)),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 5.0),
                                  child: Row(
                                    children: [
                                      getStato(
                                        snapshot.data[index]["stato"],
                                      ),
                                      SizedBox(width: 8.0),
                                      getPagato(
                                        snapshot.data[index]["pagato"],
                                      ),
                                    ],
                                  )),
                            ]),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "€ " +
                                    snapshot.data[index]["importo"].toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
