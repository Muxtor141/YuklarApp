import 'dart:ui';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:yuklar_app/providers/provider.dart';

class Spinner extends StatefulWidget {
 

  Spinner( {Key key})
      : super(key: key);
  @override
  SpinnerState createState() => SpinnerState();
}

class SpinnerState extends State<Spinner> {
  String regionsBody;

//List of regions on endDrawer start
  List regionList = ["Andijan", 'Farg\'ona'];
  //List of regions on endDrawer end

  @override
  void initState() {
    // TODO: implement initState
    getWeather();
    super.initState();
  }

  checkNetwork() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      getWeather();
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Интернет билан алoка йук'),
                content: Text(
                    '-Internet aloqasini tekshiring \n-Internet aloqani qayta yoqing '),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      getWeather();
                      Navigator.pop(context);
                    },
                    child: Text('Кайта уриниш'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text('Йопиш')),
                  ),
                ],
              ));
    }
  }

//ADDING DATA FROM API  TEST start
  void getWeather() async {
    print('getWeather() called');
    http.Response response =
        await http.get(Uri.parse('http://yuklar.acode.uz/web/app/region.php'));

    if (response.statusCode == 200) {
      regionsBody = response.body;
      List regionList1 = json.decode(regionsBody);

      for (var element in regionList1) {
        regionList.add(element['title']);
      }
    } else {}
    if (mounted) {
      setState(() {});
    }
  }

  String choosenGetLocation;
  String choosenSendLocation;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);
    final sizeQuery = MediaQuery.of(context).size;
    return Container(
      height: sizeQuery.height * 0.2,
      child: Column(
        children: [
          //DropDown 1 Row start
          Row(
            children: [
              DropdownButton(
                focusColor: Colors.red,
                value: choosenGetLocation,
                dropdownColor: HexColor('003F5C'),
                onChanged: (newValue) {
                  setState(() {
                    choosenGetLocation = newValue;
                    provider.updateGetLocation(choosenGetLocation);
                  });
                },
                items: regionList.length != 0
                    ? regionList.map((it) {
                        return DropdownMenuItem(
                          value: it,
                          child: Container(
                              width: sizeQuery.width * 0.4,
                              child: Text(
                                it,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              )),
                        );
                      }).toList()
                    : [
                        DropdownMenuItem(
                          value: '',
                          child: Container(
                              width: sizeQuery.width * 0.4,
                              child: Text(
                                '',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              )),
                        ),
                      ],
              ),
              Text(
                'дан',
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color),
              ),
            ],
          ),
          //DropDown 1 Row end

          //DropDown 2 Row start
          Row(
            children: [
              DropdownButton(
                value: choosenSendLocation,
                onChanged: (newValue) {
                  setState(() {
                    choosenSendLocation = newValue;
                    // widget.setSendLocation(choosenSendLocation);
                    provider.updateSendLocation(choosenGetLocation);
                  });
                },
                items: regionList.length != 0
                    ? regionList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Container(
                              width: sizeQuery.width * 0.45,
                              child: Text(
                                item,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              )),
                        );
                      }).toList()
                    : [
                        DropdownMenuItem(
                          value: '',
                          child: Container(
                              width: sizeQuery.width * 0.4,
                              child: Text(
                                '',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              )),
                        ),
                      ],
              ),
              Container(
                  width: sizeQuery.width * 0.07,
                  child: Text(
                    'га',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle2.color),
                  ))
            ],
          ),
          //DropDown 2 Row end
        ],
      ),
    );
  }
}
