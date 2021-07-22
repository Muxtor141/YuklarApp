import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:yuklar_app/main/yuklar_card.dart';
import 'package:yuklar_app/main/yuklar_card_spinner.dart';
import 'package:yuklar_app/providers/provider.dart';

class MainUserInterface extends StatefulWidget {
  @override
  _MainUserInterfaceState createState() => _MainUserInterfaceState();
}

class _MainUserInterfaceState extends State<MainUserInterface> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<YuklarCardState> _myWidgetState =
      GlobalKey<YuklarCardState>();

  //ADDING DATA FROM API  TEST end
  String getLocation1;
  String sendLocation1;

  setGetLocation(String getLocation) {
    setState(() {
      getLocation1 = getLocation;
    });

    print(getLocation1);
  }

  setSendLocation(String sendLocation) {
    setState(() {
      sendLocation1 = sendLocation;
    });

    print(sendLocation1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);
    final sizeQuery = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Operator bilan bog\'lanish')));
          },
          icon: Icon(
            Icons.phone,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.greenAccent,
        onPressed: () {},
      ),
      body: Provider(
        create: (cx) => MainUserInterface(),
        child: YuklarCard(
          provider.getLocation,
          provider.sendLocation,
          key: _myWidgetState,
        ),
      ),
      appBar: AppBar(
        title: Container(
            width: sizeQuery.width * 0.8,
            child: Text(
              'Yuklar',
              textAlign: TextAlign.center,
            )),
        backgroundColor: HexColor('003F5C'),
        actions: [
          Center(
            child: GestureDetector(
              child: FaIcon(FontAwesomeIcons.mapMarkedAlt),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: HexColor('003F5C'),
                    title: Text(
                      'Joyni Tanlang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle2.color),
                    ),
                    content: Row(
                      children: [
                        ChangeNotifierProvider(
                          create: (cx) => MyProvider(),
                          child: Spinner( ),
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red[300]),
                            child: Text(
                              'Qaytish',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .color),
                            ),
                            onPressed: () {
                              if (provider.getLocation != null ||
                                  provider.sendLocation != null) {
                                _myWidgetState.currentState.getYuklarCardInfo(
                                    provider.getlocationItem,
                                    provider.sendLocationItem);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent),
                              onPressed: () {
                                Navigator.pop(context);
                                if (provider.getLocation != null ||
                                    provider.sendLocation != null) {
                                  _myWidgetState.currentState.getYuklarCardInfo(
                                      provider.getLocation,
                                      provider.sendLocation);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Tanlash',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .color),
                              ))
                        ],
                      ),
                      SizedBox(
                        width: sizeQuery.width * 0.07,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: sizeQuery.width * 0.05,
          )
        ],
      ),
      key: scaffoldKey,
      // Drawers Staaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaart

      drawer: Drawer(
        //START DRAWER start

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('SALOM'),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage('assets/ab_splash.jpg'),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              title: Text('Operator bilan bog\'lanish'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Dastur haqida'),
              onTap: () {},
            ),
          ],
        ),
      ), //START DRAWER end

//Drawers eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeend
    );
  }

//Widget to use for endDrawer as a model

}
