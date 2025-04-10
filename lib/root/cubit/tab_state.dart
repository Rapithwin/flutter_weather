part of 'tab_cubit.dart';

enum Tabs { current, forecast, saved }

class TabState extends Equatable {
  const TabState({this.tab = Tabs.current});

  final Tabs tab;

  @override
  List<Object> get props => [tab];
}
