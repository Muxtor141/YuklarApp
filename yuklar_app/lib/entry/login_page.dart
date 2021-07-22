import 'dart:ui';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yuklar_app/entry/register_main_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:yuklar_app/main/home.dart';
import 'package:http/http.dart' as http;
import 'package:yuklar_app/providers/provider.dart';

class LoginPage extends StatelessWidget {
  postRequest() async {
    var sardor = await http.post(Uri.parse("http://acode.uz/test.php"), body: {
      'car_img': "base64Truck",
    });
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')});

    final sizeQuery = MediaQuery.of(context).size;
    bool _xatolik = false;
    final xatolikText = TextEditingController();

    var box = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    return Container(
      width: sizeQuery.width,
      height: sizeQuery.height,
      child:
          //OVERALL COLUMN start
          Column(children: [
        //ENTRY LOGO start
        Image.asset(
          'assets/ab_main.png',
          width: sizeQuery.width * 0.6,
          height: sizeQuery.height * 0.4,
        ),
        //ENTRY LOGO end

        //TextField Number start
        Container(
          height: sizeQuery.height * 0.09,
          width: sizeQuery.width * 0.8,
          child: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Bo\'sh bo\'lmasligi kerak';
              }
              return null;
            },
            controller: xatolikText,
            inputFormatters: [maskFormatter],
            decoration: InputDecoration(
              errorText: _xatolik ? 'Bo\'sh bo\'lmasligi kerak' : null,
              prefixText: '+998 ',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
            ),
            maxLength: 13,
          ),
        ),
        //TextField Number end

        SizedBox(
          height: sizeQuery.height * 0.01,
        ),

        //Kirish start
        Container(
          width: sizeQuery.width * 0.8,
          height: sizeQuery.height * 0.07,
          child: FlatButton(
            shape: box,
            color: HexColor("#0142fe"),
            onPressed: () {
              postRequest();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    child: MainUserInterface(),
                    create: (cx)=>MyProvider(),
                  ),
                ),
              );

              print(xatolikText.text);
            },
            child: Text(
              'Kirish',
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
        //Kirish end

        SizedBox(
          height: sizeQuery.height * 0.3,
        ),

        //REGISTRATSIYA start
        Container(
          width: sizeQuery.width * 0.8,
          height: sizeQuery.height * 0.07,
          child: FlatButton(
            shape: box,
            color: HexColor("#0142fe"),
            child: Center(
              child: Text(
                'Registratsiya',
                style: TextStyle(fontSize: 26, color: Colors.grey[300]),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RegPage()));
              print(xatolikText.text);
            },
          ),
        ), //REGISTRATSIYA end
      ]), //OVERALL COLUMN start
    );
  }
}
