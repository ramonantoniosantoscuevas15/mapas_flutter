import 'dart:convert';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas/blocs/blocs.dart';
import 'package:mapas/helpers/helpers.dart';
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
    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));
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
    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;
    int tripDuration = (destination.duration / 60).floorToDouble().toInt();
    // custom marker
    //final startMaker = await getAssetImageMarker();
    //final endMaker = await getNetworkImageMarker();
    final startMaker = await getStartCustomMarker(tripDuration, 'Mi Ubicacion');
    final endMaker = await getEndCustomMarker(kms.toInt(), destination.endPlace.text);
    final starMarker = Marker(
      anchor: const Offset(0.1, 1),
        markerId: const MarkerId('start'),
        position: destination.points.first,
        icon: startMaker,
        //infoWindow: InfoWindow(
            //title: 'Inicio', snippet: 'Kms: $kms, duracion: $tripDuration')
            );
    final endMarker = Marker(
        markerId: const MarkerId('end'),
        position: destination.points.last,
        icon: endMaker,
        
        //infoWindow: InfoWindow(
           // title: destination.endPlace.text,
            //snippet: destination.endPlace.placeName)
            );
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;
    final currentMarkers = Map<String, Marker>.from(state.markers);

    currentMarkers['start'] = starMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylinesEvent(
      currentPolylines,
      currentMarkers,
    ));
    await Future.delayed(const Duration(milliseconds: 300));
    //_mapController?.showMarkerInfoWindow(const MarkerId('start'));
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
