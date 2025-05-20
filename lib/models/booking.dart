import 'package:balancee/models/repair_station.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Booking {
  final String id;
  final RepairStation station;
  final String vehicleType;
  final DateTime date;
  final TimeOfDay time;
  final String description;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.station,
    required this.vehicleType,
    required this.date,
    required this.time,
    required this.description,
    required this.createdAt,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);
  String get formattedTime => "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  String get formattedDateTime => "$formattedDate at $formattedTime";
}