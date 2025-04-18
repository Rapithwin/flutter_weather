import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

void main() {
  group('Location', () {
    group('fromJson', () {
      test('returns correct Location object', () {
        expect(
          Location.fromJson(
            <String, dynamic>{
              'id': 4887398,
              'name': 'Chicago',
              'latitude': 41.85003,
              'longitude': -87.65005,
              'country': "United States"
            },
          ),
          // isA<Location>() ensures the returned object is of type Location.
          isA<Location>()
              // The .having() method is used to check individual properties.
              .having((w) => w.id, 'id', 4887398)
              .having((w) => w.name, 'name', 'Chicago')
              .having((w) => w.latitude, 'latitude', 41.85003)
              .having((w) => w.longitude, 'longitude', -87.65005)
              .having((w) => w.country, 'country', 'United States'),
        );
      });
    });
  });
}
