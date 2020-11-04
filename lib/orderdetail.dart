import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordini/editorder.dart';

class OrderDetail extends StatefulWidget {
  var snapshot;
  bool isPagato;
  bool isConsegnato;

  OrderDetail({this.snapshot, this.isPagato, this.isConsegnato});

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updatePagato(docid, bool pagato) {
    return orders
        .doc(docid)
        .update({'pagato': pagato})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStato(docid, bool stato) {
    return orders
        .doc(docid)
        .update({'stato': stato})
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteOrder(docid) {
    return orders
        .doc(docid)
        .delete()
        .then((value) => print("Deleted"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          "Ordine " + widget.snapshot["cliente"].toString(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOrder(
                    snapshot: widget.snapshot,
                    isPagato: widget.snapshot["pagato"],
                    isConsegnato: widget.snapshot["stato"],
                  ),
                ),
              ).then((value) => Navigator.pop(context));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          new Container(
            child: Text(
              (DateFormat('yyyy-MM-dd kk:mm').format(DateTime.parse(
                          widget.snapshot["created_at"].toDate().toString())))
                      .toString() +
                  " di " +
                  widget.snapshot["creatore"],
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
            ),
            decoration: new BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: new EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Card(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  widget.snapshot["descrizione"].toString(),
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Card(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Importo Ordine: € " + widget.snapshot["importo"].toString(),
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Card(
              child: SwitchListTile(
                title: Text("Consegnato"),
                value: widget.isConsegnato,
                onChanged: (value) {
                  setState(() {
                    widget.updateStato(widget.snapshot.id, value);
                    widget.isConsegnato = value;
                    print(widget.isConsegnato);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: Text("Pagato"),
              value: widget.isPagato,
              onChanged: (value) {
                setState(() {
                  widget.updatePagato(widget.snapshot.id, value);
                  widget.isPagato = value;
                  print(widget.isPagato);
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RaisedButton(
              onPressed: () {
                setState(() async {
                  final value = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              'Sei sicuro di voler eliminare quest\'ordine?'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              child: Text('Si'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      });
                  if (value == true) {
                    widget.deleteOrder(widget.snapshot.id);
                    Navigator.of(context).pop();
                  }
                });
              },
              child: new Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Elimina Ordine",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              color: Colors.red,
            ),
          ),
        ]),
      ),
    );
  }
}
