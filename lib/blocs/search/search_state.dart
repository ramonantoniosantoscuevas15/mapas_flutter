part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool displayManualMarket;
  final List<Feature> places;
  const SearchState({
    this.displayManualMarket = false,
    this.places = const []
    });

  SearchState copyWith({
    bool? displayManualMarket,
    List<Feature>? places
  }) =>
      SearchState(
          displayManualMarket: displayManualMarket ?? this.displayManualMarket,
          places: places ?? this.places
          );

  @override
  List<Object> get props => [displayManualMarket,places];
}
