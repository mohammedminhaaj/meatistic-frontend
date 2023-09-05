import 'package:flutter/material.dart';

final Map<String, Color?> statusColor = {
  "Accepted": Colors.blue[400],
  "Delivered": Colors.green[400],
  "On it's way": Colors.blue[400],
  "Placed": Colors.blue[400],
  "Rejected": Colors.red[400],
  "Undelivered": Colors.red[400],
};

final Map<int, List<Color>> vendorCardColor = {
  0: [Colors.red[100]!, Colors.red[200]!],
  1: [Colors.blue[100]!, Colors.blue[200]!],
  2: [Colors.deepPurple[100]!, Colors.deepPurple[200]!],
  3: [Colors.green[100]!, Colors.green[200]!],
  4: [Colors.indigo[100]!, Colors.indigo[200]!],
  5: [Colors.pink[100]!, Colors.pink[200]!],
  6: [Colors.teal[100]!, Colors.teal[200]!],
  7: [Colors.blueGrey[100]!, Colors.blueGrey[200]!],
};
