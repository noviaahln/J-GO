import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/lacakDriver_service.dart';
import '../models/lacakDriver_model.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final LatLng _customerPosition = LatLng(-7.797068, 110.370529);

  LatLng? _driverPosition;

  Timer? _timer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initDriverPosition();

    // Update posisi driver setiap 10 detik, gerakkan mendekati customer
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _moveDriverCloser();
    });
  }

  Future<void> _initDriverPosition() async {
    try {
      final locations = await LocationService.fetchLocation();
      final driver = locations.firstWhere(
        (loc) => loc.idDriver == 1,
        orElse: () => throw Exception('Driver not found'),
      );

      setState(() {
        _driverPosition = LatLng(driver.latitude, driver.longitude);
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _moveDriverCloser() {
    if (_driverPosition == null) return;

    // Hitung delta lat dan lng menuju customer
    final double latDiff = _customerPosition.latitude - _driverPosition!.latitude;
    final double lngDiff = _customerPosition.longitude - _driverPosition!.longitude;

    // Tentukan step perpindahan driver tiap update (misal 10% jarak ke customer)
    const double stepFraction = 0.1;

    // Hitung posisi driver baru
    double newLat = _driverPosition!.latitude + latDiff * stepFraction;
    double newLng = _driverPosition!.longitude + lngDiff * stepFraction;

    setState(() {
      _driverPosition = LatLng(newLat, newLng);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Driver'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : FlutterMap(
                  options: MapOptions(
                    initialCenter: _customerPosition,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _customerPosition,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                        if (_driverPosition != null)
                          Marker(
                            point: _driverPosition!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.directions_bike,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
