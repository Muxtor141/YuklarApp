import 'package:flutter/material.dart';

class Message extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final sizeQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: sizeQuery.height * 0.1,
          ),
         ElevatedButton(
            onPressed: () { },
            child: Text(
              'Кириш',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
