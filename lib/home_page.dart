import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:test_4/api_service.dart';
import 'package:test_4/city_model.dart';
import 'package:test_4/detail_page.dart';
import 'package:test_4/extra_weather.dart';
import 'package:test_4/weather_model.dart';

Weather? currentTemp;
Weather? tomorrowTemp;
List<Weather>? hourlyWeather;
List<Weather>? dailyWeather;
String lat = "53.9006";
String lon = "27.5590";
String city = "Minisk";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getData() async {
    await ApiService.fetchData(
      lat,
      lon,
      city,
    ).then((value) {
      currentTemp = value[0];
      hourlyWeather = value[1];
      dailyWeather = value[2];

      tomorrowTemp = dailyWeather![1];
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030317),
      body: currentTemp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: false,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CurrentWeather(getData);
                } else if (index == 1) {
                  return const TodayWeather();
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;

  const CurrentWeather(this.updateData, {super.key});

  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (searchBar) {
          setState(() {
            searchBar = false;
          });
        }
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 230,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
        glowColor: const Color(0xff00A1FF).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
        color: const Color(0xff00A1FF),
        spreadRadius: 5,
        child: Column(
          children: [
            Container(
              child: searchBar
                  ? TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: const Color(0xff030317),
                        filled: true,
                        hintText: "Enter a city Name",
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        CityModel? temp = await ApiService.fetchCity(value);
                        if (temp == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xff030317),
                                  title: const Text("City not found"),
                                  content:
                                      const Text("Please check the city name"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"),
                                    )
                                  ],
                                );
                              });
                          searchBar = false;
                          return;
                        }
                        city = temp.name!;
                        lat = temp.lat!;
                        lon = temp.lon!;
                        updating = true;
                        setState(() {});
                        widget.updateData();
                        searchBar = false;
                        updating = false;
                        setState(() {});
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          CupertinoIcons.square_grid_2x2,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.map_fill,
                              color: Colors.white,
                            ),
                            GestureDetector(
                              onTap: () {
                                searchBar = true;
                                setState(() {});
                                focusNode.requestFocus();
                              },
                              child: Text(
                                " $city",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.more_vert, color: Colors.white)
                      ],
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.white),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                updating ? "Updating" : "Updated",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage(
                      currentTemp?.image ?? "assets/images/cloudy.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Column(
                        children: [
                          GlowText(
                            currentTemp?.temp?.toString() ?? "",
                            style: const TextStyle(
                              height: 0.1,
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentTemp?.name ?? "",
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            currentTemp?.day ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            ExtraWeather(
              temp: currentTemp,
            )
          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatelessWidget {
  const TodayWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              tomorrowTemp == null
                  ? const SizedBox.shrink()
                  : dailyWeather == null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return DetailPage(
                                  tomorrowTemp: dailyWeather![1],
                                  sevenDay: dailyWeather,
                                );
                              }),
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                "7 days ",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.grey,
                                size: 15,
                              )
                            ],
                          ),
                        )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          hourlyWeather == null
              ? const SizedBox.shrink()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  margin: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: hourlyWeather!
                          .map((e) => WeatherWidget(
                                weather: e,
                              ))
                          .toList(),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather? weather;

  const WeatherWidget({
    super.key,
    this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.white),
          borderRadius: BorderRadius.circular(35)),
      child: Column(
        children: [
          Text(
            "${weather?.temp}\u00B0",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather?.image ?? "assets/images/cloudy.png"),
            width: 50,
            height: 50,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            weather?.time ?? "",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
