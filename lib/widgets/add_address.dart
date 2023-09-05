import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meatistic/models/user.dart';
import 'package:meatistic/providers/user_location_provider.dart';
import 'package:meatistic/utils/location_services.dart';
import 'package:meatistic/widgets/add_address_modal.dart';
import 'package:meatistic/widgets/map_search_bar.dart';

class AddAddress extends ConsumerStatefulWidget {
  const AddAddress(
      {super.key,
      this.id,
      this.lt,
      this.ln,
      this.building,
      this.landmark,
      this.locality});

  final int? id;
  final double? lt;
  final double? ln;
  final String? building;
  final String? locality;
  final String? landmark;

  @override
  ConsumerState<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends ConsumerState<AddAddress> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double? _lt;
  double? _ln;
  String? _longAddress;
  String? _shortAddress;

  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  void addHomeIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/home-marker.bmp")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  void _onClickAdd() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AddAddressModal(
            id: widget.id,
            lt: _lt!,
            ln: _ln!,
            longAddress: _longAddress!,
            shortAddress: _shortAddress!,
            building: widget.building,
            locality: widget.locality,
            landmark: widget.landmark,
          );
        });
  }

  void loadMap() {
    setState(() {
      _lt = null;
      _ln = null;
      _longAddress = null;
      _shortAddress = null;
    });
  }

  void setLtLn(double lt, double ln, String longAddress, String shortAddress) {
    setState(() {
      _lt = lt;
      _ln = ln;
      _longAddress = longAddress;
      _shortAddress = shortAddress;
    });
  }

  @override
  void initState() {
    addHomeIcon();
    super.initState();
    if (widget.lt != null && widget.ln != null) {
      setState(() {
        _lt = widget.lt;
        _ln = widget.ln;
        getAddress(_lt!, _ln!).then((value) {
          setState(() {
            _longAddress = value["longAddress"];
            _shortAddress = value["shortAddress"];
          });
        });
      });
    } else {
      getCurrentLocation().then((value) {
        setState(() {
          if (value["serviceEnabled"] &&
              value["permissionGranted"] == PermissionStatus.granted) {
            _lt = value["location"].latitude;
            _ln = value["location"].longitude;
          } else {
            final UserAddress? currentLocation = ref.read(
                userLocationProvider.select((value) => value.currentLocation));
            _lt = currentLocation != null && currentLocation.latitude != null
                ? currentLocation.latitude
                : 12.9716;
            _ln = currentLocation != null && currentLocation.longitude != null
                ? currentLocation.longitude
                : 77.5946;
          }
          getAddress(_lt!, _ln!).then((value) {
            setState(() {
              _longAddress = value["longAddress"];
              _shortAddress = value["shortAddress"];
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Add Address"),
      ),
      body: SafeArea(
        child: _lt != null && _ln != null
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                        controller.showMarkerInfoWindow(
                            const MarkerId('currentPosition'));
                      },
                      onTap: (location) {
                        setState(() {
                          _lt = location.latitude;
                          _ln = location.longitude;
                          _longAddress = null;
                          _shortAddress = null;
                          getAddress(_lt!, _ln!).then((value) {
                            setState(() {
                              _longAddress = value["longAddress"];
                              _shortAddress = value["shortAddress"];
                            });
                          });
                        });
                      },
                      markers: {
                        Marker(
                            draggable: true,
                            infoWindow: const InfoWindow(
                                title: "Your order will be delivered here."),
                            markerId: const MarkerId('currentPosition'),
                            icon: markerIcon,
                            position: LatLng(_lt!, _ln!))
                      },
                      mapToolbarEnabled: false,
                      rotateGesturesEnabled: false,
                      myLocationEnabled: true,
                      buildingsEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(_lt!, _ln!), zoom: 16)),
                  Container(
                    margin: const EdgeInsets.all(25),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _longAddress != null
                            ? Text(
                                "$_longAddress",
                                textAlign: TextAlign.center,
                              )
                            : const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    shape: const ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white),
                                onPressed:
                                    _longAddress != null ? _onClickAdd : null,
                                label: const Text("Enter Address"),
                                icon: const Icon(Icons.add_location_rounded),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 10,
                      child: MapSearchBar(
                        loadMap: loadMap,
                        setLtLn: setLtLn,
                      )),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
