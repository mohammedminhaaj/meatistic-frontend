import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meatistic/models/store.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/home_screen_builder_provider.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meatistic/utils/input_decoration.dart';
import 'package:meatistic/widgets/authentication/form_error.dart';
import 'package:meatistic/widgets/modal_header.dart';

class AddAddressForm extends ConsumerStatefulWidget {
  const AddAddressForm(
      {super.key,
      this.id,
      required this.lt,
      required this.ln,
      required this.shortAddress,
      required this.longAddress,
      this.building,
      this.locality,
      this.landmark});

  final int? id;
  final double lt;
  final double ln;
  final String longAddress;
  final String shortAddress;
  final String? building;
  final String? locality;
  final String? landmark;

  @override
  ConsumerState<AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends ConsumerState<AddAddressForm> {
  String _building = "";
  String _locality = "";
  String? _landmark;
  Map<String, dynamic> _errorDict = {};
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final Box<Store> box = Hive.box<Store>("store");

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formKey.currentState!.reset();
      setState(() {
        _errorDict = {};
        isLoading = true;
      });
      final url = getUri(widget.id != null
          ? "/api/user/edit-user-location/${widget.id}/"
          : "/api/user/add-user-location/");
      final Store store = box.get("storeObj", defaultValue: Store())!;
      final String authToken = store.authToken;
      http
          .post(url,
              headers: getAuthorizationHeaders(authToken),
              body: json.encode({
                "latitude": widget.lt,
                "longitude": widget.ln,
                "short_address": widget.shortAddress,
                "long_address": widget.longAddress,
                "building": _building,
                "locality": _locality,
                "landmark": _landmark,
              }))
          .then((response) {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey("details")) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data["details"]),
            elevation: 20,
          ));
        }
        if (response.statusCode >= 400) {
          if (data.containsKey("errors")) {
            setState(() {
              _errorDict = data["errors"];
            });
          }
        } else {
          final Map<String, dynamic> addrMap = {
            "id": data["user_location"]["id"],
            "latitude": data["user_location"]["latitude"],
            "longitude": data["user_location"]["longitude"],
            "short_address": data["user_location"]["short_address"],
            "long_address": data["user_location"]["long_address"],
            "building": data["user_location"]["building"],
            "locality": data["user_location"]["locality"],
            "landmark": data["user_location"]["landmark"],
          };
          if (widget.id == null) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            store.savedAddresses.add(addrMap);
            box.put("storeObj", store);
            final UserAddress? currentLocation = ref.read(
                userLocationProvider.select((value) => value.currentLocation));
            if (currentLocation == null) {
              ref.read(userLocationProvider.notifier).setBothLocations(
                    id: addrMap["id"],
                    lt: double.parse(addrMap["latitude"]),
                    ln: double.parse(addrMap["longitude"]),
                    shortAddress: addrMap["short_address"],
                    longAddress: addrMap["long_address"],
                    building: addrMap["building"],
                    locality: addrMap["locality"],
                    landmark: addrMap["landmark"],
                  );
            } else {
              ref.read(userLocationProvider.notifier).addUserSelectedLocation(
                    id: addrMap["id"],
                    lt: double.parse(addrMap["latitude"]),
                    ln: double.parse(addrMap["longitude"]),
                    shortAddress: addrMap["short_address"],
                    longAddress: addrMap["long_address"],
                    building: addrMap["building"],
                    locality: addrMap["locality"],
                    landmark: addrMap["landmark"],
                  );
            }

            ref
                .read(homeScreenBuilderProvider.notifier)
                .setHomeScreenUpdated(false);
          } else {
            Navigator.of(context)
              ..pop()
              ..pop();
            final int addrIndex = store.savedAddresses
                .indexWhere((element) => element["id"] == addrMap["id"]);
            final UserLocation userLocation = ref.read(userLocationProvider);
            if (userLocation.currentLocation?.id == addrMap["id"]) {
              ref.read(userLocationProvider.notifier).addUserCurrentLocation(
                    id: addrMap["id"],
                    lt: double.parse(addrMap["latitude"]),
                    ln: double.parse(addrMap["longitude"]),
                    shortAddress: addrMap["short_address"],
                    longAddress: addrMap["long_address"],
                    building: addrMap["building"],
                    locality: addrMap["locality"],
                    landmark: addrMap["landmark"],
                  );
            }
            if (userLocation.selectedLocation?.id == addrMap["id"]) {
              ref.read(userLocationProvider.notifier).addUserSelectedLocation(
                    id: addrMap["id"],
                    lt: double.parse(addrMap["latitude"]),
                    ln: double.parse(addrMap["longitude"]),
                    shortAddress: addrMap["short_address"],
                    longAddress: addrMap["long_address"],
                    building: addrMap["building"],
                    locality: addrMap["locality"],
                    landmark: addrMap["landmark"],
                  );
            }
            store.savedAddresses[addrIndex] = addrMap;
            box.put("storeObj", store);
          }
        }
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong!")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ModalHeader(headerText: "Add Address"),
        const SizedBox(
          height: 10,
        ),
        Form(
            key: _formKey,
            child: Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: widget.building,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 50) {
                        return "Please enter a valid value";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _building = value!;
                    },
                    decoration: setInputDecoration(
                        context: context,
                        label: const Text("Flat / House no / Floor / Building"),
                        prefixIcon: const Icon(Icons.house_rounded),
                        hasError: _errorDict.containsKey("building")),
                  ),
                  if (_errorDict.containsKey("building"))
                    FormError(errors: _errorDict["building"]),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: widget.locality,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length > 50) {
                        return "Please enter a valid value";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _locality = value!;
                    },
                    decoration: setInputDecoration(
                        context: context,
                        label: const Text("Area / Sector / Locality"),
                        prefixIcon: const Icon(Icons.landscape_rounded),
                        hasError: _errorDict.containsKey("locality")),
                  ),
                  if (_errorDict.containsKey("locality"))
                    FormError(errors: _errorDict["locality"]),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: widget.landmark,
                    validator: (value) {
                      if (value != null && value.trim().length > 50) {
                        return "Please enter a valid value";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _landmark = value!;
                    },
                    decoration: setInputDecoration(
                        context: context,
                        label: const Text("Landmark (Optional)"),
                        prefixIcon: const Icon(Icons.push_pin_rounded),
                        hasError: _errorDict.containsKey("landmark")),
                  ),
                  if (_errorDict.containsKey("landmark"))
                    FormError(errors: _errorDict["landmark"]),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isLoading
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(400, 60)),
                      onPressed: isLoading ? null : _submitForm,
                      icon: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_rounded),
                      label: const Text('Save Address')),
                ],
              ),
            ))
      ],
    );
  }
}
