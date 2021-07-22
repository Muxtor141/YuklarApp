import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  String getLocation;
  String sendLocation;

  void updateGetLocation(String newLocation) {
    this.getLocation = newLocation;
    notifyListeners();
  }

  void updateSendLocation(String newLocation) {
    this.getLocation = newLocation;
    notifyListeners();
  }

  String get getlocationItem {
    return getLocation;
  }

  String get sendLocationItem {
    return sendLocation;
  }
    checkNetwork(Function getWeather,BuildContext context) async {
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
}
