import 'package:bloc_weather/search/cubit/location_cubit.dart';
import 'package:bloc_weather/search/models/location.dart';
import 'package:bloc_weather/search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Allows users to enter the name of their desired city and provides
/// the search result to the previous route via `Navigator.of(context).pop`
class SearchPage extends StatefulWidget {
  const SearchPage._();

  static Route<Location> route() {
    return MaterialPageRoute(
      builder: (_) => const SearchPage._(),
    );
  }

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String get _text => _textEditingController.text;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City Search"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: "city",
                      hintText: "Chicago",
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<LocationCubit>().fetchLocation(_text);
                },
                icon: const Icon(
                  Icons.search,
                  semanticLabel: "Submit",
                ),
                key: const Key("searchPage_search_iconButton"),
              )
            ],
          ),
          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, state) {
              return switch (state.status) {
                LocationStatus.initial => const LocationsInitial(),
                LocationStatus.loading => const LocationsLoading(),
                LocationStatus.failure => const LocationsError(),
                LocationStatus.success => LocationsListBuilder(
                    locations: state.location,
                  )
              };
            },
          )
        ],
      ),
    );
  }
}
