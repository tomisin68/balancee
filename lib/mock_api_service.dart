import 'package:balancee/models/repair_station.dart';
import 'package:balancee/models/user.dart';
import 'package:balancee/models/booking.dart';
import 'package:flutter/material.dart';

class MockApiService {
  // Authentication constants
  static const _validEmail = 'intern@balancee.com';
  static const _validPassword = 'Intern123#';

  // Mock database
  static final List<RepairStation> _mockStations = [
    RepairStation(
      id: 'station_1',
      name: 'City Auto Repair',
      distance: 2.5,
      rating: 4.7,
      type: 'Mechanic',
    ),
    RepairStation(
      id: 'station_2',
      name: 'Green Fuel Station',
      distance: 1.2,
      rating: 4.3,
      type: 'Fuel Station',
    ),
    RepairStation(
      id: 'station_3',
      name: 'Express Lube',
      distance: 3.8,
      rating: 4.9,
      type: 'Mechanic',
    ),
    RepairStation(
      id: 'station_4',
      name: 'Tire Masters',
      distance: 5.1,
      rating: 4.5,
      type: 'Tire Shop',
    ),
  ];

  static final List<Booking> _mockBookings = [];

  // Authentication
  static Future<User> login(String email, String password) async {
    await _simulateNetworkDelay();

    if (email != _validEmail || password != _validPassword) {
      throw Exception('Invalid email or password');
    }

    return User(
      id: 'user_123',
      email: email,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  // Repair Stations
  static Future<List<RepairStation>> getRepairStations() async {
    await _simulateNetworkDelay();
    return _mockStations;
  }

  // Bookings
  static Future<Booking> bookAppointment({
    required String stationId,
    required String vehicleType,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) async {
    await _simulateNetworkDelay(seconds: 2);

    final station = _mockStations.firstWhere(
      (s) => s.id == stationId,
      orElse: () => throw Exception('Station not found'),
    );

    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      station: station,
      vehicleType: vehicleType,
      date: date,
      time: time,
      description: description,
      createdAt: DateTime.now(),
    );

    _mockBookings.add(booking);
    return booking;
  }

  static Future<void> cancelBooking(String bookingId) async {
    await _simulateNetworkDelay();
    
    final bookingIndex = _mockBookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex == -1) {
      throw Exception('Booking not found');
    }
    
    _mockBookings.removeAt(bookingIndex);
  }

  // Helper method to simulate network delay
  static Future<void> _simulateNetworkDelay({int seconds = 1}) async {
    await Future.delayed(Duration(seconds: seconds));
  }
}