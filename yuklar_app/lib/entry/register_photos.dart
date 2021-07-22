import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuklar_app/entry/register_main_page.dart';
import 'package:yuklar_app/main/home.dart';

class RegPhoto extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String carType;
  final Function checkField;
  RegPhoto(this.carType, this.name, this.phoneNumber, this.checkField);
  @override
  _RegPhotoState createState() => _RegPhotoState();
}

class _RegPhotoState extends State<RegPhoto> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> phoneNumber;
  final GlobalKey<RegPageState> _myMainLogin = GlobalKey<RegPageState>();

  int rasmId;

  bool _imageCardSuccess = false;
  bool _imageTruckSuccess = false;
  final uri = Uri.parse("http://yuklar.acode.uz/web/app/register.php?type=generate_sms_code");
  bool _nameSuccess = false;
  bool _phoneSuccess = false;

  File _imageTruck;
  File _imageCard;
  bool tanlanganTruck = false;
  bool tanlanganCard = false;
  String _code;
  final codeController = TextEditingController();
  final picker = ImagePicker();

  Future<void> getCode() async {
    final SharedPreferences prefs = await _prefs;
    _code = prefs.getString("code");
    print(_code);
  }

  //rasmniOlish() to handle picking image from CAMERA start
  Future rasmnGallery(int id) async {
    PickedFile pickedFile =
        await picker.getImage(imageQuality: 100, source: ImageSource.gallery);
    setState(() {
      print(id.toString);
      if (pickedFile != null) {
        if (id == 2) {
          _imageCard = File(pickedFile.path);
          tanlanganCard = true;
        } else {}
        if (id == 1) {
          _imageTruck = File(pickedFile.path);
          tanlanganTruck = true;
        } else {}
      } else {}
    });
  }

  //rasmniOlish() end
  Future<void> _sharedPref(String data) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString("phone", data);

    print('Shared Preferences saved ');
  }

//to check whether code is saved to sharedPreferences
  Future<void> _printShared() async {
    final SharedPreferences prefs = await _prefs;
    String gotNumber = prefs.getString("phone");
    print(gotNumber);
  }

  Future<void> sendImages() async {
    String uploadImageurl =
        "http://yuklar.acode.uz/web/app/register.php?type=save_values";
    print(_imageCard);
    print(_imageTruck);
    print(widget.name);
    print(widget.carType);
    print(
      widget.phoneNumber.replaceAll(' ', ''),
    );
    if (_imageCard != null &&
        _imageTruck != null &&
        widget.carType != null &&
        widget.name != null) {
      List<int> byteImageCard = _imageCard.readAsBytesSync();
      List<int> byteImageTruck = _imageTruck.readAsBytesSync();
      String base64Card = base64Encode(byteImageCard);
      String base64Truck = base64Encode(byteImageTruck);
      
      var sardor = await http.post(
        uri,
        body: {
          'car_img': base64Truck,
          'doc_img': base64Card,
          'phone_num': widget.phoneNumber.replaceAll(' ', ''),
          'car_type': widget.carType,
          'name': widget.name
        },
      );

      if (sardor.statusCode == 200) {
        var jsondata = json.decode(sardor.body);

        print(jsondata);
        print('${jsondata['success']}:is Image Status');
      }
    } else {
      print("rasmlar yuklanmadi");
    }
  }

  Future<void> registrate(Size sizeQuery) async {
    //show your own loading or progressing code here
    String uploadurl =
        "http://yuklar.acode.uz/web/app/register.php?type=generate_sms_code";
        

    var Abbos = await http.post(uri, body: {
      'phone_num': phoneNumber.toString().replaceAll(' ', ''),
    });

    if (field.length == 1) {
      sendImages();
      print('sendImages() called ');
    } else {
      //dont use http://localhost , because emulator don't get that address
      //insted use your local IP address or use live URL
      //hit "ipconfig" in windows or "ip a" in linux to get you local IP
      print('sms sending called');
      try {
        //convert file image to Base64 encoding
        List<int> byteImageCard = _imageCard.readAsBytesSync();
        List<int> byteImageTruck = _imageTruck.readAsBytesSync();

        String base64Card = base64Encode(byteImageCard);
        String base64Truck = base64Encode(byteImageTruck);

        if (Abbos.statusCode == 200) {
          var jsondata = json.decode(Abbos.body);
          print(jsondata);
          _sharedPref(jsondata['code'].toString());
          getCode();

          field.add(
            Container(
              width: sizeQuery.width * 0.5,
              child: Form(
                key: _codeKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Kodni kiriting';
                    }
                    if (value != codeController.text) {
                      return 'Kod xato kiritildi';
                    }
                    return null;
                  },
                  controller: codeController,
                  decoration: InputDecoration(labelText: 'Kodni kiriting '),
                ),
              ),
            ),
          );
        } else {
          print("Error during connection to server");
          //there is error during connecting to server,
          //status code might be 404 = url not found
        }
      } catch (e) {
        print("Error during converting to Base64");
        //there is error during converting file image to base64 encoding.
      }
    }
  }

  Future rasmniOlish(int id) async {
    PickedFile pickedFile =
        await picker.getImage(imageQuality: 100, source: ImageSource.camera);
    setState(() {
      print(id.toString);
      if (pickedFile != null) {
        if (id == 2) {
          _imageCard = File(pickedFile.path);
          tanlanganCard = true;
        } else {}
        if (id == 1) {
          _imageTruck = File(pickedFile.path);
          tanlanganTruck = true;
        } else {}
      } else {
        print('Rasm yo\'q');
      }
    });
  }

  void _showPicker(context, int id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        rasmnGallery(id);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      rasmniOlish(id);

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<Widget> field = [];
  final _codeKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var box = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    final sizeQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          //Truck and Id sections Started
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              //TRUCK start
              children: [
                Container(
                  height: sizeQuery.height * 0.2,
                  width: sizeQuery.width * 0.4,
                  child: tanlanganTruck == false
                      ? Image.asset(
                          'assets/frontal_truck.png',
                        )
                      : Image.file(_imageTruck),
                ),
                SizedBox(
                  height: sizeQuery.height * 0.03,
                ),
                Container(
                    height: sizeQuery.height * 0.05,
                    width: sizeQuery.width * 0.4,
                    child: FlatButton(
                      shape: box,
                      color: HexColor('#0142fe'),
                      onPressed: () {
                        _showPicker(context, 1);
                      },
                      child: Text(
                        'Yuklash',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ))
              ],
            ), //TRUCK end

            Column(
              //ID CARD start
              children: [
                Container(
                  height: sizeQuery.height * 0.2,
                  width: sizeQuery.width * 0.4,
                  child: tanlanganCard == false
                      ? Image.asset('assets/id_card.png')
                      : Image.file(_imageCard),
                ),
                SizedBox(
                  height: sizeQuery.height * 0.03,
                ),
                Container(
                  height: sizeQuery.height * 0.05,
                  width: sizeQuery.width * 0.4,
                  child: RaisedButton(
                    shape: box,
                    color: HexColor('#0142fe'),
                    onPressed: () {
                      _showPicker(context, 2);
                    },
                    child: Text(
                      'Yuklash',
                      style: TextStyle(color: Colors.grey[300]),
                    ),
                  ),
                ),
              ],
            ) //ID CARD end
          ],
        ),
        SizedBox(
          height: sizeQuery.height * 0.05,
        ),
        ...field,
        SizedBox(height: sizeQuery.height * 0.05),
        Container(
          width: sizeQuery.width * 0.5,
          height: sizeQuery.height * 0.05,
          child: RaisedButton(
            color: HexColor('#0142fe'),
            onPressed: () {
              if (_code == codeController.text) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainUserInterface()),
                );
              }
              widget.checkField();
              if (widget.carType != null ||
                  widget.name != null ||
                  widget.phoneNumber != null) {
                registrate(sizeQuery);
                print('registrate called ');
                setState(() {});
              } else {
                print('one of fields are null');
              }
            },
            child: Text(
              'Registratsiya',
              style:
                  TextStyle(color: Theme.of(context).textTheme.subtitle2.color),
            ),
          ),
        ),
      ],
    );
  }
}
