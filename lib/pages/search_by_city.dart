// ignore_for_file: prefer_const_constructors, prefer_final_fields, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/const/const.dart';
import 'package:weather_app/ob/weather_ob.dart';

TextEditingController _cityTex = TextEditingController();

class SearchByCityPage extends StatefulWidget {
  const SearchByCityPage({Key? key}) : super(key: key);

  @override
  _SearchByCityPageState createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends State<SearchByCityPage> {
  WeatherOb? wob;
  String? error;
  bool isloading = false;
  getWeatherData(String cityName) async {
    setState(() {
      isloading = true;
    });
    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$APPID&units=metric"));

    if (response.statusCode == 200) {
      setState(() {
        wob = WeatherOb.fromJson(json.decode(response.body));
        isloading = false;
        error = null;
      });
    } else {
      setState(() {
        isloading = false;
        error = "Something Wrong !!!!!!!!!!!!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int hour = DateTime.now().hour;
    bool isNight = true;

    if (hour >= 6 && hour <= 18) {
      isNight = false;
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              top: 30,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.keyboard_backspace,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
                left: 10,
                right: 0,
                top: 150,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: _cityTex,
                            decoration: InputDecoration(
                              labelText: "Search By City",
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )),
                          IconButton(
                            onPressed: () {
                              getWeatherData(_cityTex.text);
                            },
                            icon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    isloading
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : error != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Text(
                                  error!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              )
                            : wob == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Text(
                                              wob!.main!.temp!.toString() +
                                                  " C",
                                              style: TextStyle(
                                                fontSize: 50,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 100,
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
                                              ]),
                                          Center(
                                            child: Text(
                                              "Wind Speed : " +
                                                  wob!.wind!.speed.toString() +
                                                  " meter/sec",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Center(
                                            child: Text(
                                              "Max Temp : " +
                                                  wob!.main!.tempMax
                                                      .toString() +
                                                  " C",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Center(
                                            child: Text(
                                              "Min Temp : " +
                                                  wob!.main!.tempMin
                                                      .toString() +
                                                  " C",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Center(
                                            child: Text(
                                              "Pressure : " +
                                                  wob!.main!.pressure!
                                                      .toString() +
                                                  " hPa",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
