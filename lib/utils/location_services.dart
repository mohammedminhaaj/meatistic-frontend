import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/settings.dart' as app_settings;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

Map<String, String> parseGmapResponse(List<dynamic> addressComponents) {
  final List<String> typesToExtract = [
    "route",
    "neighborhood",
    "sub_locality",
    "locality"
  ];
  return addressComponents.fold<Map<String, String>>({}, (result, element) {
    for (final type in typesToExtract) {
      if (element["types"].contains(type)) result[type] = element["short_name"];
    }
    return result;
  });
}

Future<Map<String, dynamic>> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return {
        "serviceEnabled": false,
        "permissionGranted": PermissionStatus.denied,
        "location": null,
      };
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return {
        "serviceEnabled": true,
        "permissionGranted": PermissionStatus.denied,
        "location": null,
      };
    }
  }

  locationData = await location.getLocation();
  return {
    "serviceEnabled": serviceEnabled,
    "permissionGranted": permissionGranted,
    "location": locationData
  };
}

Future<Map<String, String>> getAddress(
  double lt,
  double ln,
) async {
  const api = app_settings.gmapApi;
  final Uri url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lt,$ln&key=$api");
  final response = await http.get(url);
  final data = json.decode(response.body);

  final List<dynamic> addressComponents =
      data["results"][0]["address_components"];
  final Map<String, String> parsedGmapResponse =
      parseGmapResponse(addressComponents);

  return {
    "longAddress": data["results"][0]["formatted_address"],
    "shortAddress": parsedGmapResponse.values.join(", ")
  };
}

UserAddress? getUserAddressWithinRadius(UserAddress currentAddress) {
  final Box<Store> box = Hive.box<Store>("store");
  final Store store = box.get("storeObj", defaultValue: Store())!;
  final List<dynamic> savedAddress = store.savedAddresses;
  if (savedAddress.isEmpty) {
    return null;
  }
  const double radiusKm = 1.0;
  final List<dynamic> addressWithinRange = savedAddress
      .where((address) => currentAddress.distanceTo(address) <= radiusKm)
      .toList();
  try {
    return UserAddress(
      id: addressWithinRange[0]["id"],
      latitude: double.parse(addressWithinRange[0]["latitude"]),
      longitude: double.parse(addressWithinRange[0]["longitude"]),
      shortAddress: addressWithinRange[0]["short_address"],
      longAddress: addressWithinRange[0]["long_address"],
      building: addressWithinRange[0]["building"],
      locality: addressWithinRange[0]["locality"],
      landmark: addressWithinRange[0]["landmark"],
    );
  } on RangeError {
    return null;
  }
}

LatLngBounds getLatLngBounds(List<List<double>> list) {
  double? x0, x1, y0, y1;

  for (final latLng in list) {
    x0 = x0 == null ? latLng[0] : math.min(x0, latLng[0]);
    x1 = x1 == null ? latLng[0] : math.max(x1, latLng[0]);
    y0 = y0 == null ? latLng[1] : math.min(y0, latLng[1]);
    y1 = y1 == null ? latLng[1] : math.max(y1, latLng[1]);
  }

  return LatLngBounds(
    northeast: LatLng(x1!, y1!),
    southwest: LatLng(x0!, y0!),
  );
}
