import 'package:bloc_weather/search/models/location.dart';
import 'package:flutter/material.dart';

class LocationsListBuilder extends StatelessWidget {
  const LocationsListBuilder({super.key, required this.locations});

  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Flexible(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 1,
        ),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.of(context).pop(locations[index]),
            child: Container(
              padding: EdgeInsets.only(left: 12),
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${locations[index].city}, ${locations[index].country}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
