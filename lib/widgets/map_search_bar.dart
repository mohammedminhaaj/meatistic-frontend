import 'package:flutter/material.dart';
import 'package:meatistic/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:meatistic/utils/location_services.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key, required this.loadMap, required this.setLtLn});

  final Function() loadMap;
  final Function(
    double,
    double,
    String,
    String,
  ) setLtLn;

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  String searchText = "";
  String fallbackText = "Nothing to show here.";
  List<dynamic> addressList = [];
  Timer? _debounceTimer;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final Uri url = Uri.parse(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&key=$gmapApi");
        http.get(url).then((response) {
          final Map<dynamic, dynamic> data = json.decode(response.body);
          setState(() {
            isLoading = false;
            fallbackText = "Nothing to show here.";
            if (response.statusCode == 200) {
              addressList = data["predictions"]
                  .map((element) => {
                        "description": element["description"],
                        "placeId": element["place_id"]
                      })
                  .toList();
            } else {
              fallbackText = "Error while fetching data";
            }
          });

          _debounceTimer!.cancel();
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(
                content:
                    Text("Something went wrong while searching location")));
          _debounceTimer!.cancel();
        });
      });
    }
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.70,
            height: 40,
            child: TextField(
              controller: _controller,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  if (value.length >= 3) {
                    isLoading = true;
                  } else {
                    if (isLoading) {
                      isLoading = false;
                    }
                  }
                });
              },
              decoration: InputDecoration(
                  suffixIcon: searchText.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {
                              searchText = "";
                              if (isLoading) {
                                isLoading = false;
                              }
                            });
                          },
                          child: const Icon(Icons.close_rounded))
                      : null,
                  filled: true,
                  contentPadding: const EdgeInsets.only(top: 10),
                  isDense: true,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  hintText: "Search for places...",
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search_rounded)),
            )),
        const SizedBox(
          height: 10,
        ),
        AnimatedContainer(
          height: searchText.length >= 3 ? null : 0,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.40),
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          duration: const Duration(milliseconds: 300),
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    )
                  : searchText.length < 3 || addressList.isEmpty
                      ? Text(
                          fallbackText,
                          textAlign: TextAlign.center,
                        )
                      : Column(
                          children: List.generate(
                              addressList.length,
                              (index) => ListTile(
                                    leading: Icon(
                                      Icons.location_on,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    dense: true,
                                    onTap: () {
                                      setState(() {
                                        searchText = "";
                                      });
                                      widget.loadMap();
                                      final String placeId =
                                          addressList[index]['placeId'];
                                      final Uri url = Uri.parse(
                                          "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$gmapApi");
                                      http.get(url).then((response) {
                                        if (response.statusCode == 200) {
                                          final Map<dynamic, dynamic> data =
                                              json.decode(response.body);
                                          final double lt = data['result']
                                              ['geometry']['location']['lat'];
                                          final double ln = data['result']
                                              ['geometry']['location']['lng'];
                                          final String longAddress =
                                              data['result']
                                                  ['formatted_address'];
                                          final Map<String, String>
                                              shortAddress = parseGmapResponse(
                                                  data['result']
                                                      ['address_components']);
                                          widget.setLtLn(lt, ln, longAddress,
                                              shortAddress.values.join(", "));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Could not parse map information")));
                                        }
                                      });
                                    },
                                    title:
                                        Text(addressList[index]["description"]),
                                  )),
                        )),
        )
      ],
    );
  }
}
