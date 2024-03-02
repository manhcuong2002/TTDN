class Weather {
  final int? weatherCode;

  final double? temp;

  final double? maxTemp;
  final double? minTemp;

  final double? windSpeed;
  final double? precipitation;

  final String? day;
  final String? name;
  final int? humidity;
  final String? image;
  final String? time;
  final String? location;

  Weather({
    this.weatherCode,
    this.temp,
    this.maxTemp,
    this.minTemp,
    this.windSpeed,
    this.precipitation,
    this.time,
    this.day,
    this.name,
    this.humidity,
    this.location,
    this.image,
  });
}
