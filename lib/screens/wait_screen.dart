import 'package:flutter/material.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF004489),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(height: 10),
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text(
                'Cargando...',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                )
              )
            ]
          ),
        )
      )
    );
  }
}