import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:yuklar_app/main/home.dart';
import 'package:yuklar_app/models/yuklar_modal.dart';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:yuklar_app/providers/provider.dart';

//This widget created to fill information about Yuklar as list

class YuklarCard extends StatefulWidget {
  final String getLocation;
  final String sendLocation;
  YuklarCard(this.getLocation, this.sendLocation, {Key key}) : super(key: key);

  @override
  YuklarCardState createState() => YuklarCardState();
}

class YuklarCardState extends State<YuklarCard> {
  List<Yuklar> yuklarList = [
    Yuklar(
      cost: '100 000 so\'m',
      packing: 'Sement olish ',
      getDate: '22.05.2021',
      getLocation: 'Andijon',
      sendLocation: 'Toshkent',
    ),
    Yuklar(
      cost: '100 000 so\'m',
      packing: 'Sement olish ',
      getDate: '22.05.2021',
      getLocation: 'Andijon',
      sendLocation: 'Toshkent',
    ),
    Yuklar(
      cost: '100 000 so\'m',
      packing: 'Sement olish ',
      getDate: '22.05.2021',
      getLocation: 'Farg\'ona',
      sendLocation: 'Toshkent',
    ),
    Yuklar(
      cost: '100 000 so\'m',
      packing: 'Sement olish ',
      getDate: '22.05.2021',
      getLocation: 'Andijon',
      sendLocation: 'Toshkent',
    ),
  ];

  List<Yuklar> filteredList = [];

  @override
  void initState() {
    
    network(MyProvider());
    super.initState();
  }

  network(MyProvider provider) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      getYuklarCardInfo(provider.getLocation, provider.getLocation);
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);

      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Интернет билан алoка йук'),
                content: Text(
                    '-Internet aloqasini tekshiring \n-Internet aloqani qayta yoqing '),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      network(provider);
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

//a function to get Yuklar's info from http and updates Ui
  void getYuklarCardInfo(String getLocation, String sendLocation) async {
    print('getyuklarCardInfo() called');
    print("${widget.getLocation}: GET LOCATION DATA");

    var url = 'http://yuklar.acode.uz/web/app/get-order.php';
    if (getLocation != null && sendLocation == null) {
      url = 'http://yuklar.acode.uz/web/app/get-order.php?from=${getLocation}';

      print('fromLocation CALLED');
    } else if (getLocation != null || sendLocation != null) {
      url =
          'http://yuklar.acode.uz/web/app/get-order.php?from=${getLocation}&to=${sendLocation}';
      print('fromLocation and toLocation CALLED');
    } else if (sendLocation != null && getLocation == null) {
      url = 'http://yuklar.acode.uz/web/app/get-order.php?to=${sendLocation}';
      print('toLocation Called');
    }

    http.Response yuklarResponse = await http.get(Uri.parse(url));

    if (yuklarResponse.statusCode == 200) {
      List l = json.decode(yuklarResponse.body);
      for (var element in l) {
        //looping through given list of JSON objects start
        var list = Yuklar.fromJson(element);

        //get filtered Yuklar's Info  option

        Yuklar newlist1 = new Yuklar(
          cost: list.cost,
          getDate: list.getDate,
          getLocation: list.getLocation,
          packing: list.packing,
          sendLocation: list.sendLocation,
          phoneNumber: list.phoneNumber,
        );
        yuklarList.add(newlist1);

        print('only Location called');
      }
      //looping through given list of JSON objects end

      if (mounted) {
        setState(() {});
      } else {
        print('not mounted');
      }
    } else {
      print('XATOLIK : ${yuklarResponse.statusCode}');
    }
  }

  Widget yuklarCard(
      {Size sizeQuery,
      String regionFrom,
      String regionTo,
      String price,
      String date,
      String phoneNumber,
      String productText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: HexColor('003F5C'),
      child: Container(
        height: sizeQuery.height * 0.23,
        child: Column(
          //Overall Card Column start
          children: [
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                shadowColor: Colors.white,
                color: Colors.grey[300],
                child:
                    //Regions and Icons ROW start
                    Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: HexColor('#000000'),
                          spreadRadius: -12,
                          blurRadius: 12),
                      BoxShadow(color: Colors.white)
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: sizeQuery.width * 0.01,
                      ),

                      //ICONS COLUMN end

                      SizedBox(
                        width: sizeQuery.height * 0.01,
                      ),
                      //Regions Name from API start
                      Row(
                        children: [
                          Container(
                              width: sizeQuery.width * 0.25,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  regionFrom,
                                ),
                              )),
                          IconButton(
                            icon: Image.asset(
                              'assets/icons/truck_icon.png',
                            ),
                            iconSize: 10,
                            onPressed: () {},
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/icons/arron.png',
                            ),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/icons/boxes2.png',
                            ),
                            iconSize: 16,
                            onPressed: () {},
                          ),
                          Container(
                              width: sizeQuery.width * 0.25,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(regionTo))),
                        ],
                      ), //Regions Name from API start
                    ],
                  ),
                ),
                //Regions and Icons ROW end
              ),
            ),

            SizedBox(
              height: sizeQuery.height * 0.003,
            ),
            //EXTRA INFO Column start
            Column(
              children: [
                //Icons Column start
                Row(
                  children: [
                    SizedBox(
                      width: sizeQuery.width * 0.01,
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/dollar.png',
                      ),
                      iconSize: 10,
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: sizeQuery.width * 0.006,
                    ),
                    Container(
                      width: sizeQuery.width * 0.4,
                      child: Text(
                        'To\'lov: $price',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color),
                      ),
                    ),
                    SizedBox(
                      width: sizeQuery.width * 0.006,
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/calendar.png',
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: sizeQuery.width * 0.006,
                    ),
                    Container(
                      width: sizeQuery.width * 0.3,
                      child: Text(
                        'Sana: $date',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color),
                      ),
                    ),
                  ],
                ),
                //Icons Column end

                //Extra Text start

                Row(
                  children: [
                    SizedBox(
                      width: sizeQuery.width * 0.01,
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/notes.png',
                      ),
                      iconSize: 16,
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: sizeQuery.width * 0.006,
                    ),
                    Container(
                      width: sizeQuery.width * 0.5,
                      child: Text(
                        'Text: $productText',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.subtitle2.color),
                      ),
                    ),
                  ],
                ),
                //Extra text end
              ],
            ),
            //EXTRA INFO Column end
          ],
        ),
      ),
      //Overall Card Ccolumn end
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);

    final sizeQuery = MediaQuery.of(context).size;

    return Container(
      height: sizeQuery.height,
      width: sizeQuery.width,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          await network(provider);
          setState(() {});
        },
        child: ListView.builder(
          itemCount: yuklarList.length,
          itemBuilder: (_, index) {
            return yuklarCard(
                sizeQuery: sizeQuery,
                date: yuklarList[index].getDate,
                regionFrom: yuklarList[index].getLocation,
                regionTo: yuklarList[index].sendLocation,
                price: yuklarList[index].cost,
                phoneNumber: yuklarList[index].phoneNumber,
                productText: yuklarList[index].productText);
          },
        ),
      ),
    );

    // Container(
    //   height: sizeQuery.height,
    //   width: sizeQuery.width,
    //   child: AnimatedList(
    //     initialItemCount: yuklarList.length,
    //     itemBuilder: (context, index, animation) {
    //       return SlideTransition(position: Tween<Offset>(
    //   begin: const Offset(-1, 0),
    //   end: Offset(0, 0),
    // ).animate(animation),
    //         child: yuklarCard(
    //             sizeQuery: sizeQuery,
    //             date: yuklarList[index].getDate,
    //             regionFrom: yuklarList[index].getLocation,
    //             regionTo: yuklarList[index].sendLocation,
    //             price: yuklarList[index].cost,
    //             phoneNumber: yuklarList[index].phoneNumber,
    //             productText: yuklarList[index].productText),
    //       );
    //     },
    //   ),
    // );
  }
}
