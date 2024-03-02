import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'weather_model.dart';

class ExtraWeather extends StatelessWidget {
  final Weather? temp;

  const ExtraWeather({
    super.key,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Icon(
              CupertinoIcons.wind,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${temp?.windSpeed ?? 0.0} Km/h",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Wind",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            const Icon(
              CupertinoIcons.drop,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${temp?.humidity ?? ''} %",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Humidity",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            const Icon(
              CupertinoIcons.cloud_rain,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$temp %",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Rain",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        )
      ],
    );
  }
}
