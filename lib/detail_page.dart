import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:test_4/weather_model.dart';

import 'extra_weather.dart';

class DetailPage extends StatelessWidget {
  final Weather? tomorrowTemp;
  final List<Weather>? sevenDay;

  const DetailPage({
    super.key,
    required this.tomorrowTemp,
    required this.sevenDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030317),
      body: Column(
        children: [
          TomorrowWeather(
            tomorrowTemp: tomorrowTemp,
          ),
          SevenDays(
            sevenDay: sevenDay,
          ),
        ],
      ),
    );
  }
}

class TomorrowWeather extends StatelessWidget {
  final Weather? tomorrowTemp;

  const TomorrowWeather({
    super.key,
    this.tomorrowTemp,
  });

  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      color: const Color(0xff00A1FF),
      glowColor: const Color(0xff00A1FF),
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text(
                      " 7 days",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Icon(Icons.more_vert, color: Colors.white)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          tomorrowTemp?.image ?? "assets/sunny_2d.png"),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Tomorrow",
                      style: TextStyle(fontSize: 30, height: 0.1),
                    ),
                    Container(
                      height: 105,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GlowText(
                            tomorrowTemp?.maxTemp.toString() ?? '',
                            style: const TextStyle(
                                fontSize: 100, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "/${tomorrowTemp?.minTemp ?? ''}\u00B0",
                            style: TextStyle(
                                color: Colors.black54.withOpacity(0.3),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      " ${tomorrowTemp?.name ?? ''}",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20,
              right: 50,
              left: 50,
            ),
            child: Column(
              children: [
                const Divider(color: Colors.white),
                const SizedBox(
                  height: 10,
                ),
                ExtraWeather(
                  temp: tomorrowTemp,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SevenDays extends StatelessWidget {
  final List<Weather>? sevenDay;

  const SevenDays({
    super.key,
    this.sevenDay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: sevenDay?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sevenDay![index].time ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage(sevenDay![index].image ??
                                "assets/sunny_2d.png"),
                            width: 40,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            sevenDay![index].name ?? '',
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "+${sevenDay![index].maxTemp}\u00B0",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "+${sevenDay![index].minTemp}\u00B0",
                          style:
                              const TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ));
          }),
    );
  }
}
