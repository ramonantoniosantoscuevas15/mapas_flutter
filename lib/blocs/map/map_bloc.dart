import 'dart:convert';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/blocs.dart';
import 'package:mapas/models/models.dart';
import 'package:mapas/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;
  StreamSubscription<LocationState>? locationStateSubscription;
  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitialzedEvent>(_onInitMap);
    on<OnStarFollowingUserEvent>(_onStarFollowingUser);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isfollowingUser: false)));
    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);
    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));
    on<DisplayPolylinesEvent>((event, emit) => emit(state.copyWith(polylines: event.polylines)));
    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }
      if (!state.isfollowingUser) return;
      if (locationState.lastKnownLocation == null) return;
      moveCamara(locationState.lastKnownLocation!);
    });
  }
  void _onStarFollowingUser(
      OnStarFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowingUser: true));

    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamara(locationBloc.state.lastKnownLocation!);
  }

  void _onInitMap(OnMapInitialzedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onPolylineNewPoint(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.black,
        width: 5,
        points: destination.points,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap);
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;
    add(DisplayPolylinesEvent(currentPolylines));
  }

  void moveCamara(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
