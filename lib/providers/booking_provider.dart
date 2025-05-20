import 'package:balancee/mock_api_service.dart';
import 'package:balancee/models/booking.dart';
import 'package:balancee/models/repair_station.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  // State variables
  List<RepairStation> _stations = [];
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<RepairStation> get stations => _stations;
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Fetch all repair stations - now returns Future<List<RepairStation>>
  Future<List<RepairStation>> fetchStations() async {
    _setLoading(true);
    _error = null;

    try {
      _stations = await MockApiService.getRepairStations();
      return _stations; // Explicit return
    } catch (e) {
      _error = e.toString();
      _stations = [];
      return []; // Return empty list on error
    } finally {
      _setLoading(false);
    }
  }

  // Book a new appointment - returns Future<Booking>
  Future<Booking> bookAppointment({
    required RepairStation station,
    required String vehicleType,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final booking = await MockApiService.bookAppointment(
        stationId: station.id,
        vehicleType: vehicleType,
        date: date,
        time: time,
        description: description,
      );

      _bookings = [..._bookings, booking];
      return booking; // Return the created booking
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel an existing booking
  Future<void> cancelBooking(String bookingId) async {
    _setLoading(true);
    _error = null;

    try {
      await MockApiService.cancelBooking(bookingId);
      _bookings = _bookings.where((b) => b.id != bookingId).toList();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private method to handle loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Helper method to refresh data
  Future<void> refreshData() async {
    await fetchStations();
    // Could add other refresh logic here if needed
  }
}