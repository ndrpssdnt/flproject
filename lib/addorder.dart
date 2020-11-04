import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordini/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:ordini/orders.dart';

class AddOrder extends StatefulWidget {
  bool isPagato = false;
  bool isConsegnato = false;

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
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
              SizedBox(
                height: 15,
              ),
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
              FCustomInput(
                nome: "Importo",
                tcontroller: importoController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Card(
                  child: SwitchListTile(
                    title: Text("Consegnato"),
                    value: widget.isConsegnato,
                    onChanged: (value) {
                      setState(() {
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
                      widget.isPagato = value;
                      print(widget.isPagato);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      CollectionReference orders =
                          FirebaseFirestore.instance.collection('orders');

                      DocumentReference create = await orders.add({
                        'created_at': Timestamp.now(),
                        'creatore':
                            FirebaseAuth.instance.currentUser.displayName,
                        'stato': widget.isConsegnato,
                        'pagato': widget.isPagato,
                        'cliente': clienteController.text,
                        'descrizione': descrizioneController.text,
                        'importo': importoController.text,
                      });

                      //PushNotificationMessage(body: "test_body", title: "test");
                      Navigator.of(context).pop(create);
                    }
                  },
                  child: new Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Crea Ordine",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
