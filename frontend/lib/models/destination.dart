import 'package:flutter/material.dart';
import "package:flutter/material.dart";
import 'package:frontend/l10n/app_localizations.dart';
class Destination  {
  const Destination({required this.label, required this.icon});
  final String label;
  final IconData icon;

}

const destinations = [
  Destination(label: "Home", icon: Icons.home),
  Destination(label: "Account", icon: Icons.person_2),
  Destination(label: "Profile", icon: Icons.person_2),
  Destination(label: "Orders", icon: Icons.person_2),
  Destination(label: "Profile", icon: Icons.person_2)
]
