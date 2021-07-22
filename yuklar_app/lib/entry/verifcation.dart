import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:yuklar_app/main/home.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _code;

  Timer timer;

  int startTime = 60;

  final codeController = TextEditingController();

  Future<void> _printShared() async {
    final SharedPreferences prefs = await _prefs;
    String gotNumber = prefs.getString("phone");
    print(gotNumber);
  }

  Future<void> getCode() async {
    final SharedPreferences prefs = await _prefs;
    _code = prefs.getString("phone");
    print(_code);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizeQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: sizeQuery.height * 0.3,
              ),
              Container(
                width: sizeQuery.width * 0.6,
                child: Form(key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    
                    controller: codeController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                height: sizeQuery.height * 0.03,
              ),
              RaisedButton(
                onPressed: () {
                  
                  getCode();
          if (_formKey.currentState.validate()) {
      Scaffold
          .of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
                  if (_code == codeController.text) {
         

                    
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => MainUserInterface()),
                    // );
                  }
                },
                child: Text('Tasdiqlash'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
