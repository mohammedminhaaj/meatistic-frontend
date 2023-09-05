import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meatistic/models/user.dart';

class UserLocationNotifier extends StateNotifier<UserLocation> {
  UserLocationNotifier() : super(const UserLocation());

  void addUserCurrentLocation(
      {int? id,
      double? lt,
      double? ln,
      String? shortAddress,
      String? longAddress,
      String? building,
      String? locality,
      String? landmark}) {
    state = state.copyWith(
        currentLocation: UserAddress(
            id: id,
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress,
            building: building,
            locality: locality,
            landmark: landmark));
  }

  void addUserSelectedLocation(
      {int? id,
      double? lt,
      double? ln,
      String? shortAddress,
      String? longAddress,
      String? building,
      String? locality,
      String? landmark}) {
    state = state.copyWith(
        selectedLocation: UserAddress(
            id: id,
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress,
            building: building,
            locality: locality,
            landmark: landmark));
  }

  void setBothLocations(
      {int? id,
      double? lt,
      double? ln,
      String? shortAddress,
      String? longAddress,
      String? building,
      String? locality,
      String? landmark}) {
    state = state.copyWith(
        selectedLocation: UserAddress(
            id: id,
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress,
            building: building,
            locality: locality,
            landmark: landmark),
        currentLocation: UserAddress(
            id: id,
            latitude: lt,
            longitude: ln,
            shortAddress: shortAddress,
            longAddress: longAddress,
            building: building,
            locality: locality,
            landmark: landmark));
  }

  void clearSelectedLocation() {
    state = UserLocation(
        currentLocation: state.currentLocation, selectedLocation: null);
  }

  void setSelectedLocation(UserAddress? selectedLocation) {
    state = state.copyWith(selectedLocation: selectedLocation);
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, UserLocation>(
        (ref) => UserLocationNotifier());
