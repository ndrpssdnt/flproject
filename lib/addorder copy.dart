import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordini/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class AddOrder extends StatefulWidget {
  AddOrder();
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  Future getProducts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot qn = await db.collection("orders").get();
    return qn.docs;
  }

  void createRecord(
      {String cliente = "",
      Timestamp createdat,
      String creatore = "",
      String descrizione = "",
      double importo = 0,
      bool pagato = false,
      bool stato = false}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference ref = await db.collection("orders").add({
      'cliente': cliente,
      'created_at': createdat,
      'creatore': creatore,
      'descrizione': descrizione,
      'importo': importo,
      'pagato': pagato,
      'stato': stato,
    });

    print(ref.id);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController clienteController = TextEditingController();
  TextEditingController descrizioneController = TextEditingController();
  TextEditingController importoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Nuovo Ordine"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                FCustomInput(nome: "Cliente", tcontroller: clienteController),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 16,
                    controller: descrizioneController,
                    decoration: InputDecoration(
                      labelText: "Descrizione",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        borderSide: new BorderSide(
                          color: Color.fromARGB(255, 200, 200, 200),
                        ),
                      ),
                    ),
                  ),
                ),
                FCustomInput(nome: "Importo", tcontroller: importoController),
              ],
            )),
      ),
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              createRecord(
                  cliente: clienteController.text,
                  createdat: Timestamp.now(),
                  creatore: FirebaseAuth.instance.currentUser.displayName,
                  descrizione: descrizioneController.text,
                  importo: double.parse(importoController.text),
                  pagato: false,
                  stato: false);

              //PushNotificationMessage(body: "test_body", title: "test");

              Navigator.pop(context, "Done");
            }
          }),
    );
  }
}
