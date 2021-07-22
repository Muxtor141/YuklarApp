import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:yuklar_app/entry/register_photos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  @override
  RegPageState createState() => RegPageState();
  RegPage({Key regKey}) : super(key: regKey);
}

class RegPageState extends State<RegPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//FUNCTION to Mask input numbers of TELEFON TEXT Widget
  var maskFormatter = new MaskTextInputFormatter(
      mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')});

//MASK end

  var textControllerName = TextEditingController();
  var textControllerNumber = TextEditingController();
  var textControllerCar = TextEditingController();

  Future<void> saveToSharedPref(String text, String textType) async {
    final SharedPreferences prefs = await _prefs;
    if (text == null && textType == null) {
      print('$text and $textType are NULL');
    } else {
      prefs.setString(textType, text);
      print('name and phone numbers Submitted');
      print(
        prefs.getString(textType),
      );
    }
  }

  final _formKey1Name = GlobalKey<FormState>();
  final _formKey2Num = GlobalKey<FormState>();
  final _formKey3Type = GlobalKey<FormState>();

  checkFields() {
    if (_formKey1Name.currentState.validate()) {
     
    } else {}

    if (_formKey2Num.currentState.validate()) {
     
    } else {}
    if (_formKey3Type.currentState.validate()) {
  
    } else {}

   

  }

  @override
  Widget build(BuildContext context) {
    final sizeQuery = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey[200],
        height: sizeQuery.height,
        width: sizeQuery.width,
        child: Column(
          //OVERALL REGISTER PAGE COLUMN start
          children: [
            SizedBox(
              height: sizeQuery.height * 0.1,
            ),
            Container(
              //FIO TEXT start
              width: sizeQuery.width * 0.8,
              child: Form(
                key: _formKey1Name,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ism va familiya kiriting';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (_formKey1Name.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  controller: textControllerName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'F.I.O',
                  ),
                ),
              ),
            ), //FIO TEXT end

            Container(
              //TELEFON TEXT start
              width: sizeQuery.width * 0.8,
              child: Form(
                key: _formKey2Num,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Telefon raqam kiriting ';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    print(textControllerNumber.text);
                  },
                  onFieldSubmitted: (_) {
                    if (_formKey2Num.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                    print(textControllerNumber.text);
                    setState(() {});
                  },
                  controller: textControllerNumber,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                    labelText: 'Telefon raqami ',
                    prefixText: '+998 ',
                  ),
                ),
              ),
            ),
            Container(
                width: sizeQuery.width * 0.8,
                child: Form(
                  key: _formKey3Type,
                  child: TextFormField(controller: textControllerCar,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Avtomashina turini kiriting';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (_formKey3Type.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    maxLength: 5,
                    decoration: InputDecoration(labelText: 'Avtomashina turi'),
                  ),
                )),

            //TELEFON TEXT end

            SizedBox(
              height: sizeQuery.height * 0.01,
            ),

            RegPhoto(
                textControllerCar.text,
                textControllerName.text,
                textControllerNumber.text,
                checkFields), //Truck and Id sections Widgets
          ],
        ), //OVERALL REGISTER PAGE COLUMN end
      ),
    );
  }
}
