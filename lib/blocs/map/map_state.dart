part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showMyRoute;
  //polylines
  final Map<String, Polyline> polylines;
  const MapState(
      {this.isMapInitialized = false,
      this.isfollowingUser = true,
      this.showMyRoute = true,
      final Map<String, Polyline>? polylines})
      : polylines = polylines ?? const {};

  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? showMyRoute,
    final Map<String, Polyline>? polylines,
  }) =>
      MapState(
        isMapInitialized: isMapInitialized ?? this.isMapInitialized,
        isfollowingUser: isfollowingUser ?? this.isfollowingUser,
        showMyRoute: showMyRoute ?? this.showMyRoute,
        polylines: polylines ?? this.polylines,
      );

  @override
  List<Object> get props => [isMapInitialized, isfollowingUser,showMyRoute, polylines];
}
