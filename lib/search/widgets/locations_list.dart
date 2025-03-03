import 'package:bloc_weather/search/models/location.dart';
import 'package:flutter/material.dart';

class LocationsListBuilder extends StatelessWidget {
  const LocationsListBuilder({super.key, required this.locations});

  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.of(context).pop(locations[index]),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
