import 'package:flutter/material.dart';
import 'package:meatistic/widgets/add_address_form.dart';

class AddAddressModal extends StatelessWidget {
  const AddAddressModal(
      {super.key,
      this.id,
      required this.lt,
      required this.ln,
      required this.shortAddress,
      required this.longAddress,
      this.building,
      this.landmark,
      this.locality});

  final int? id;
  final double lt;
  final double ln;
  final String longAddress;
  final String shortAddress;
  final String? building;
  final String? locality;
  final String? landmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          top: 15,
          left: 15,
          right: 15),
      child: AddAddressForm(
        id: id,
        lt: lt,
        ln: ln,
        shortAddress: shortAddress,
        longAddress: longAddress,
        building: building,
        locality: locality,
        landmark: landmark,
      ),
    );
  }
}
