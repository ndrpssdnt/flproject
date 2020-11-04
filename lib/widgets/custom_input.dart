import 'package:flutter/material.dart';

class FCustomInput extends StatelessWidget {
  final nome;
  final TextEditingController tcontroller;
  FCustomInput({this.nome, this.tcontroller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0),
      child: TextFormField(
        controller: tcontroller,
        decoration: InputDecoration(
          labelText: nome,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: new BorderSide(
              color: Color.fromARGB(255, 200, 200, 200),
            ),
          ),
        ),
      ),
    );
  }
}
