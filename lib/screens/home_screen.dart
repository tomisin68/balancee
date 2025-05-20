import 'package:balancee/models/repair_station.dart';
import 'package:balancee/providers/auth_provider.dart';
import 'package:balancee/providers/booking_provider.dart';
import 'package:balancee/screens/booking_screen.dart';
import 'package:balancee/widgets/error_widget.dart';
import 'package:balancee/widgets/loading_indicator.dart';
import 'package:balancee/widgets/station_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Stations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => bookingProvider.refreshData(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => bookingProvider.refreshData(),
        child: FutureBuilder<List<RepairStation>>(
          future: bookingProvider.fetchStations(),
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }

            // Handle error state
            if (snapshot.hasError) {
              return CustomErrorWidget(
                errorMessage: 'Failed to load stations: ${snapshot.error}',
                onRetry: () => bookingProvider.refreshData(),
              );
            }

            // Get stations or empty list if null
            final stations = snapshot.data ?? [];

            // Handle empty state
            if (stations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.garage_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No repair stations available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // Success state
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StationCard(
                    station: station,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(station: station),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}