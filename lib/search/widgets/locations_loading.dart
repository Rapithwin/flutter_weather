import 'package:flutter/material.dart';

class LocationsLoading extends StatelessWidget {
  const LocationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
