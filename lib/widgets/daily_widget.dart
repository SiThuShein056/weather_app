// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/ob/daily_weather_ob.dart';

class DailyWidget extends StatelessWidget {
  //const DailyWidget({ Key? key }) : super(key: key);
  Daily? daily; // daily ko bae ur mr mot
  DailyWidget(this.daily);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    DateFormat("EEEE dd , MMMM").format(
                      DateTime.fromMillisecondsSinceEpoch(daily!.dt! * 1000),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.blue.withOpacity(0.75),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                          "http://openweathermap.org/img/wn/${daily!.weather![0].icon!}@2x.png"),
                      Text(
                        daily!.weather![0].main!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Max Temperature : " +
                            daily!.temp!.max.toString() +
                            " C",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Min Temperature : " +
                            daily!.temp!.min.toString() +
                            " C",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Day Temperature : " +
                            daily!.temp!.day.toString() +
                            " C",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Night Temperature : " +
                            daily!.temp!.night.toString() +
                            " C",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Wind Speed : " +
                            daily!.windSpeed.toString() +
                            " meter/sec",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                    "http://openweathermap.org/img/wn/${daily!.weather![0].icon!}@2x.png"),
                Text(
                  daily!.weather![0].main!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat("EEEE dd , MMMM").format(
                DateTime.fromMillisecondsSinceEpoch(daily!.dt! * 1000),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
