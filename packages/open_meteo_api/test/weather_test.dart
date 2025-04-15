import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group("WeatherCurrent", () {
    group("fromJson", () {
      test("returns the correct WeatherCurrent object", () {
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

  group("WeatherHourly", () {
    group("fromJson", () {
      test("returns the correct WeatherHourly object", () {
        expect(
          WeatherHourly.fromJson(<String, dynamic>{
            "weathercode": [63],
            "is_day": [0],
            "time": ["2025-04-15T15:00"],
            "temperature": [15.3],
          }),
          isA<WeatherHourly>()
              .having(
                (w) => w.isDay,
                "isDay",
                isA<List<int>>().having((w) => w.first, "isDay index", 0),
              )
              .having(
                (w) => w.weatherCode,
                "weatherCode",
                isA<List<int>>()
                    .having((w) => w.first, "weatherCode index", 63),
              )
              .having(
                (w) => w.time,
                "isDay",
                isA<List<String>>()
                    .having((w) => w.first, "time index", "2025-04-15T15:00"),
              )
              .having(
                (w) => w.temperature,
                "temperature",
                isA<List<double>>()
                    .having((w) => w.first, "temperature index", 15.3),
              ),
        );
      });
    });
  });
}
