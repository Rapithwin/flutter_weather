import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group("Weather", () {
    group("fromJson", () {
      test("returns the correct Weather object", () {
        expect(
          Weather.fromJson(<String, dynamic>{
            "temperature": 15.3,
            "weathercode": 63,
            "is_day": 0,
            "windspeed": 4.5,
          }),
          isA<Weather>()
              .having((w) => w.temperature, "temperature", 15.3)
              .having((w) => w.weatherCode, "weatherCode", 63)
              .having((w) => w.isDay, "isDay", 0)
              .having((w) => w.windSpeed, "windSpeed", 4.5),
        );
      });
    });
  });
}
