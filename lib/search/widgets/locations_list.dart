import 'package:bloc_weather/search/models/location.dart';
import 'package:flutter/material.dart';

class LocationsListBuilder extends StatelessWidget {
  const LocationsListBuilder({super.key, required this.locations});

  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
        );
      },
    );
  }
}
