class Vendor {
  const Vendor(
      {required this.displayName,
      required this.owner,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.status,
      required this.contact,
      required this.email,
      required this.rating});

  final String displayName;
  final String owner;
  final double latitude;
  final double longitude;
  final String address;
  final String status;
  final String contact;
  final String? email;
  final String? rating;

  factory Vendor.fromJson(Map<dynamic, dynamic> json) {
    return Vendor(
        displayName: json["display_name"],
        owner: json["owner"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        address: json["address"],
        contact: json["contact"],
        email: json["email"],
        rating: json["rating"]?.toString(),
        status: json["vendor_status"]);
  }

  factory Vendor.empty() {
    return const Vendor(
        displayName: "",
        owner: "",
        latitude: 0.0,
        longitude: 0.0,
        address: "",
        contact: "",
        email: null,
        rating: null,
        status: "");
  }

  factory Vendor.withName(String displayName) {
    return Vendor(
        displayName: displayName,
        owner: "",
        latitude: 0.0,
        longitude: 0.0,
        address: "",
        status: "",
        contact: "",
        email: null,
        rating: null);
  }
}
