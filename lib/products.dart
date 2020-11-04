import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsWidget extends StatefulWidget {
  final edit = "";
  ProductsWidget({edit});

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  void reload() {
    setState(() {
      getProducts();
    });
  }

  Future getProducts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot qn = await db.collection("products").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new RefreshIndicator(
        onRefresh: () {
          reload();
          return getProducts();
        },
        child: FutureBuilder(
          future: getProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Caricamento Prodotti"),
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
                        title: Text(snapshot.data[index]["name"]),
                        subtitle: Text(
                            snapshot.data[index]["regular_price"].toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: null,
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
