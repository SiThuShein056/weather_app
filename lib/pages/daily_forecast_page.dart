// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, avoid_print, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/const/const.dart';
import 'package:weather_app/ob/daily_weather_ob.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widgets/daily_widget.dart';

class DailyForeCastPage extends StatefulWidget {
  //const DailyForeCastPage({Key? key}) : super(key: key);

  double lon;
  double lat;
  DailyForeCastPage(this.lat, this.lon);

  @override
  _DailyForeCastPageState createState() => _DailyForeCastPageState();
}

class _DailyForeCastPageState extends State<DailyForeCastPage> {
  bool isloading = true;
  DailyWeatherOb? dwob;
  getDailyWeatherData() async {
    print(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${widget.lat}&lon=${widget.lon}&exclude=daily&appid=$APPID&units=metric");
    var response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${widget.lat}&lon=${widget.lon}&exclude=hourly,minutely,monthly&appid=$APPID&units=metric"));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        dwob = DailyWeatherOb.fromJson(json.decode(response.body));
        isloading = false;
      });
    } else {
      print("Error");
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDailyWeatherData();
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
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.keyboard_backspace,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "7 days forecast",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: isloading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dwob!.daily!.length,
                          itemBuilder: (context, index) {
                            return DailyWidget(dwob!.daily![index]);
                          }))
            ],
          )),
    );
  }
}
