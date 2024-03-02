import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_4/city_model.dart';
import 'package:test_4/weather_model.dart';

class ApiService {
  ApiService._();

  static String appId = "9f3c524a7b5c7ae5930ad1eba70ebe97";

  static Future<List> fetchData(String lat, String lon, String city) async {
    var url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m&current=relative_humidity_2m&current=apparent_temperature&current=is_day&current=precipitation&current=rain&current=weather_code&current=surface_pressure&current=wind_speed_10m&current=wind_direction_10m&hourly=temperature_2m&hourly=relative_humidity_2m&hourly=apparent_temperature&hourly=precipitation&hourly=rain&hourly=snowfall&hourly=snow_depth&hourly=weather_code&hourly=visibility&hourly=wind_speed_10m&hourly=wind_direction_10m&daily=weather_code&daily=temperature_2m_max&daily=temperature_2m_min&daily=apparent_temperature_max&daily=apparent_temperature_min&daily=sunrise&daily=sunset&timezone=auto";
    var response = await http.get(Uri.parse(url));

    print("response.statusCode: ${response.statusCode}");

    DateFormat dateFormat = DateFormat("yyyy dd MM");
    DateFormat dateFormat1 = DateFormat("yyyy-MM-dd'T'HH:mm");
    DateFormat dateFormat2 = DateFormat("yyyy-MM-dd");

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      Weather currentTemp = Weather(
        weatherCode: res["current"]["current"] as int? ?? 0,
        temp: res["current"]["temperature_2m"] as double? ?? 0.0,
        maxTemp: res["daily"]["temperature_2m_max"][0] as double? ?? 0.0,
        minTemp: res["daily"]["temperature_2m_min"][0] as double? ?? 0.0,
        day: dateFormat.format(
          dateFormat1.parse(res["current"]["time"]),
        ),
        windSpeed: res["current"]["wind_speed_10m"] as double? ?? 0.0,
        humidity: res["current"]["relative_humidity_2m"] as int? ?? 0,
        precipitation: res["current"]["precipitation"] as double? ?? 0.0,
        location: city,
        name: findName(
          res["current"]["weather_code"] as int? ?? 0,
        ),
        image: findIcon(
          res["current"]["weather_code"] as int? ?? 0,
        ),
      );

      //today weather
      List<Weather> hourlyWeather = [];
      for (var i = 0; i < 24; i++) {
        var hourly = Weather(
          weatherCode: res["hourly"]["weather_code"][i] as int? ?? 0,
          temp: res["hourly"]["temperature_2m"][i] as double? ?? 0.0,
          maxTemp: res["daily"]["temperature_2m_max"][0] as double? ?? 0.0,
          minTemp: res["daily"]["temperature_2m_min"][0] as double? ?? 0.0,
          day: dateFormat.format(
            dateFormat1.parse(res["hourly"]["time"][i]),
          ),
          windSpeed: res["hourly"]["wind_speed_10m"][i] as double? ?? 0.0,
          humidity: res["hourly"]["relative_humidity_2m"][i] as int? ?? 0,
          precipitation: res["hourly"]["precipitation"][i] as double? ?? 0.0,
          location: city,
          name: findName(
            res["hourly"]["weather_code"][i] as int? ?? 0,
          ),
          image: findIcon(
            res["hourly"]["weather_code"][i] as int? ?? 0,
          ),
        );

        hourlyWeather.add(hourly);
      }

      //Seven Day Weather
      List<Weather> dailyWeather = [];
      for (var i = 0; i < 7; i++) {
        var daily = Weather(
          weatherCode: res["daily"]["weather_code"][i] as int? ?? 0,
          maxTemp: res["daily"]["temperature_2m_max"][0] as double? ?? 0.0,
          minTemp: res["daily"]["temperature_2m_min"][0] as double? ?? 0.0,
          day: dateFormat.format(
            dateFormat2.parse(res["daily"]["time"][i]),
          ),
          location: city,
          name: findName(
            res["daily"]["weather_code"][i] as int? ?? 0,
          ),
          image: findIcon(
            res["hourly"]["weather_code"][i] as int? ?? 0,
          ),
        );

        dailyWeather.add(daily);
      }
      return [currentTemp, hourlyWeather, dailyWeather];
    }

    return [null, null, null];
  }

  static String findIcon(int name) {
    switch (name) {
      case 1:
      case 2:
      case 3:
        return "assets/sunny_2d.png";
      case 45:
      case 48:
        return "assets/rainy_2d.png";
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return "assets/rainy_2d.png";

      case 85:
      case 86:
      case 95:
      case 96:
      case 99:
        return "assets/thunder_2d.png";
      case 71:
      case 73:
      case 75:
      case 77:
        return "assets/snow_2d.png";
      default:
        return "assets/sunny_2d.png";
    }
  }

  static String findName(int name) {
    switch (name) {
      case 1:
      case 2:
      case 3:
        return "Sunny";
      case 45:
      case 48:
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return "Rain";

      case 85:
      case 86:
      case 95:
      case 96:
      case 99:
        return "Thunder";
      case 71:
      case 73:
      case 75:
      case 77:
        return "Snow";
      default:
        return "Sunny";
    }
  }

  static var cityJSON;

  static Future<CityModel?> fetchCity(String cityName) async {
    if (cityJSON == null) {
      String link =
          "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
      var response = await http.get(Uri.parse(link));
      if (response.statusCode == 200) {
        cityJSON = json.decode(response.body);
      }
    }

    for (var i = 0; i < cityJSON.length; i++) {
      if (cityJSON[i]["name"].toString().toLowerCase() ==
          cityName.toLowerCase()) {
        return CityModel(
          name: cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString(),
        );
      }
    }
    return null;
  }
}
