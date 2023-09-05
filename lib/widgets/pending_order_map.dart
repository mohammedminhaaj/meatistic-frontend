import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meatistic/utils/location_services.dart';

class PendingOrderMap extends StatefulWidget {
  const PendingOrderMap(
      {super.key,
      required this.orderLatitude,
      required this.orderLongitude,
      required this.vendorLtLn});

  final String orderLatitude;
  final String orderLongitude;
  final List<List<double>> vendorLtLn;

  @override
  State<PendingOrderMap> createState() => _PendingOrderMapState();
}

class _PendingOrderMapState extends State<PendingOrderMap> {
  late final double lt;
  late final double ln;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late final List<List<double>> allCoordinates;
  final Set<Marker> markers = {};

  BitmapDescriptor homeMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  BitmapDescriptor vendorMarkerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);

  void addHomeIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/home-marker.bmp")
        .then(
      (icon) {
        setState(() {
          homeMarkerIcon = icon;
        });
      },
    );
  }

  void addVendorIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/vendor-marker.bmp")
        .then(
      (icon) {
        setState(() {
          vendorMarkerIcon = icon;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    lt = double.parse(widget.orderLatitude);
    ln = double.parse(widget.orderLongitude);
    addHomeIcon();
    addVendorIcon();
    allCoordinates = [
      ...widget.vendorLtLn,
      [lt, ln]
    ];
  }

  @override
  Widget build(BuildContext context) {
    for (final ltln in widget.vendorLtLn) {
      markers.add(Marker(
          markerId: MarkerId('$ltln'),
          icon: vendorMarkerIcon,
          position: LatLng(ltln[0], ltln[1])));
    }
    markers.add(Marker(
        infoWindow:
            const InfoWindow(title: "Your order will be delivered here."),
        markerId: const MarkerId('orderPosition'),
        icon: homeMarkerIcon,
        position: LatLng(lt, ln)));

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * .60,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(lt, ln), zoom: 16),
        onMapCreated: (controller) {
          _controller.complete(controller);
          controller.showMarkerInfoWindow(const MarkerId('orderPosition'));
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Future.delayed(const Duration(milliseconds: 2000), () {
              controller.animateCamera(CameraUpdate.newLatLngBounds(
                  getLatLngBounds(allCoordinates), 40.0));
              controller.hideMarkerInfoWindow(const MarkerId('orderPosition'));
            });
          });
        },
        markers: markers,
        mapToolbarEnabled: false,
        rotateGesturesEnabled: false,
        myLocationButtonEnabled: false,
        buildingsEnabled: false,
        minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
