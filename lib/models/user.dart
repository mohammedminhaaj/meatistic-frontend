import 'dart:math';

class UserAddress {
  const UserAddress(
      {this.id,
      this.latitude,
      this.longitude,
      this.shortAddress,
      this.longAddress,
      this.building,
      this.locality,
      this.landmark});
  final int? id;
  final double? latitude;
  final double? longitude;
  final String? shortAddress;
  final String? longAddress;
  final String? building;
  final String? locality;
  final String? landmark;

  UserAddress copyWith(
      {int? id,
      double? lt,
      double? ln,
      String? shortAddress,
      String? longAddress,
      String? building,
      String? locality,
      String? landmark}) {
    return UserAddress(
        id: id ?? id,
        latitude: lt ?? latitude,
        longitude: ln ?? longitude,
        shortAddress: shortAddress ?? this.shortAddress,
        longAddress: longAddress ?? this.longAddress,
        building: building ?? this.building,
        locality: locality ?? this.locality,
        landmark: landmark ?? this.landmark);
  }

  UserAddress clear() {
    return const UserAddress();
  }

  List<String> get _addressComponents {
    return shortAddress != null ? shortAddress!.split(", ") : [];
  }

  String get lastAddressComponent {
    final List<String> addrList = _addressComponents;
    try {
      return addrList[addrList.length - 1];
    } on RangeError {
      return "";
    }
  }

  String get secondLastAddressComponent {
    final List<String> addrList = _addressComponents;
    try {
      return addrList[addrList.length - 2];
    } on RangeError {
      return "";
    }
  }

  String get inputAddress {
    return building == null || locality == null
        ? ""
        : "$building, $locality ${landmark != null && landmark != "" ? ", $landmark" : ""}";
  }

  double distanceTo(Map<dynamic, dynamic> other) {
    //Using Haversine formula to calculate distance
    const double earthRadiusKm = 6371.0;
    double degToRad(double deg) => deg * (pi / 180.0);

    double dLat = degToRad(double.parse(other["latitude"]) - latitude!);
    double dLon = degToRad(double.parse(other["longitude"]) - longitude!);

    double a = pow(sin(dLat / 2), 2) +
        cos(degToRad(latitude!)) *
            cos(degToRad(double.parse(other["latitude"]))) *
            pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }
}

class UserLocation {
  const UserLocation({this.currentLocation, this.selectedLocation});

  final UserAddress? currentLocation;
  final UserAddress? selectedLocation;

  UserLocation copyWith(
      {UserAddress? currentLocation, UserAddress? selectedLocation}) {
    return UserLocation(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}
