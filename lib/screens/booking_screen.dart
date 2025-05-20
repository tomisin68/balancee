import 'package:balancee/models/repair_station.dart';
import 'package:balancee/providers/booking_provider.dart';
import 'package:balancee/widgets/custom_button.dart';
import 'package:balancee/widgets/custom_textfield.dart';
import 'package:balancee/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final RepairStation station;

  const BookingScreen({super.key, required this.station});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVehicleType;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    try {
      await bookingProvider.bookAppointment(
        station: widget.station,
        vehicleType: _selectedVehicleType!,
        date: _selectedDate!,
        time: _selectedTime!,
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Book at ${widget.station.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.station.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.station.distance} km away',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.station.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Car', child: Text('Car')),
                  DropdownMenuItem(value: 'Motorcycle', child: Text('Motorcycle')),
                  DropdownMenuItem(value: 'Truck', child: Text('Truck')),
                  DropdownMenuItem(value: 'SUV', child: Text('SUV')),
                ],
                onChanged: (value) => setState(() => _selectedVehicleType = value),
                validator: (value) =>
                    value == null ? 'Please select vehicle type' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Date',
                      hint: 'Select date',
                      readOnly: true,
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : null,
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) =>
                          _selectedDate == null ? 'Please select date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Time',
                      hint: 'Select time',
                      readOnly: true,
                      prefixIcon: Icon(Icons.access_time_filled_outlined),
                      controller: TextEditingController(
                        text: _selectedTime?.format(context),
                      ),
                      onTap: () => _selectTime(context),
                      validator: (value) =>
                          _selectedTime == null ? 'Please select time' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your repair needs',
                maxLines: 4,
                prefixIcon: Icon(Icons.description_outlined),
              ),
              const SizedBox(height: 32),
              bookingProvider.isLoading
                  ? const LoadingIndicator()
                  : CustomButton(
                      onPressed: _submitBooking,
                      child: const Text('Book Appointment'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}