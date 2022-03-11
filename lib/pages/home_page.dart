// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables, unused_field, avoid_print, sized_box_for_whitespace

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/const/const.dart';
import 'package:weather_app/ob/weather_ob.dart';
import 'package:weather_app/pages/daily_forecast_page.dart';
import 'package:weather_app/pages/search_by_city.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  Location location = new Location();
  WeatherOb? wob;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  double? lat;
  double? lon;

  getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);

    lat = _locationData.latitude!;
    lon = _locationData.longitude!;

    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$APPID&units=metric"));
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        wob = WeatherOb.fromJson(map);
        isloading = false;
      });
    } else {
      print("Error");
      isloading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    int hour = DateTime.now().hour;
    bool isNight = true;

    if (hour >= 6 && hour <= 18) {
      isNight = false;
    }
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      child: isNight
                          ? Image.asset(
                              "images/Night.png",
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "images/Day.png",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          wob!.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat(
                            "EEEE dd , MMMM",
                          ).format(DateTime.now()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat().add_jm().format(DateTime.now()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return DailyForeCastPage(lat!, lon!);
                              }),
                            );
                          },
                          child: Text(
                            "7 days forecast ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wob!.main!.temp!.toString() + " C",
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                  "http://openweathermap.org/img/wn/${wob!.weather![0].icon!}.png"),
                            ),
                            Text(
                              wob!.weather![0].main!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return SearchByCityPage();
                          },
                        ));
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
