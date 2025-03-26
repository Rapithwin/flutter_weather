import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group("Weather", () {
    group("fromJson", () {
      test("returns the correct Weather object", () {
        expect(
          WeatherCurrent.fromJson(<String, dynamic>{
            "temperature": 15.3,
            "weathercode": 63,
            "is_day": 0,
            "windspeed": 4.5,
            "wind_direction_10m": 196,
            "apparent_temperature": 12.9,
            "relative_humidity_2m": 89,
            "visibility": 13000,
          }),
          isA<WeatherCurrent>()
              .having((w) => w.temperature, "temperature", 15.3)
              .having((w) => w.weatherCode, "weatherCode", 63)
              .having((w) => w.isDay, "isDay", 0)
              .having((w) => w.windSpeed, "windSpeed", 4.5)
              .having((w) => w.feelsLike, "apparent temperature", 12.9)
              .having((w) => w.humidity, "relative humidity", 89)
              .having((w) => w.windDirection, "wind direction", 196)
              .having((w) => w.visibility, "visibility", 13000),
        );
      });
    });
  });
}
