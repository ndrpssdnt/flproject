import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ordini/widgets/custom_input.dart';

class AddProduct extends StatefulWidget {
  AddProduct();

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Future getProducts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot qn = await db.collection("products").get();
    return qn.docs;
  }

  void createRecord(
      {categoria = "",
      nome = "",
      ean = "",
      sku = "",
      prezzoacquisto = 0,
      prezzovendita = 0,
      quantita = 0}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference ref = await db.collection("products").add({
      'category': categoria,
      'name': nome,
      'ean13': ean,
      'sku': sku,
      'purchase_price': prezzoacquisto,
      'regular_price': prezzovendita,
      'stock_quantity': quantita,
    });

    print(ref.id);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController eanController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  TextEditingController prezzoacquistoController = TextEditingController();
  TextEditingController prezzovenditaController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Nuovo Prodotto"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                FCustomInput(
                    nome: "Categoria", tcontroller: categoriaController),
                Divider(),
                FCustomInput(nome: "Nome", tcontroller: nomeController),
                FCustomInput(nome: "Ean", tcontroller: eanController),
                FCustomInput(nome: "SKU", tcontroller: skuController),
                Divider(),
                FCustomInput(
                    nome: "Prezzo Acquisto",
                    tcontroller: prezzoacquistoController),
                FCustomInput(
                    nome: "Prezzo Vendita",
                    tcontroller: prezzovenditaController),
                Divider(),
                FCustomInput(nome: "Quantità", tcontroller: quantitaController)
              ],
            )),
      ),
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              createRecord(
                  categoria: categoriaController.text,
                  nome: nomeController.text,
                  ean: eanController.text,
                  sku: skuController.text,
                  prezzoacquisto: prezzoacquistoController.text,
                  prezzovendita: prezzovenditaController.text,
                  quantita: quantitaController.text);

              Navigator.pop(context, "Done");
            }
          }),
    );
  }
}
