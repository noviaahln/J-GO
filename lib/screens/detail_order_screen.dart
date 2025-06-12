import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/order_screen_model.dart';
import '../services/order_screen_service.dart';

class DetailOrderScreen extends StatefulWidget {
  final String to;

  const DetailOrderScreen({super.key, required this.to});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  LatLng? _fromLatLng;
  late LatLng _toLatLng;
  double? _price;
  double? _distance;
  bool _isLoading = false;

  final mapController = MapController();

  LatLng getLatLng(String locationName) {
    // Koordinat dengan jarak yang bervariasi dari pusat Yogyakarta
    switch (locationName) {
      case 'Jl Jawa 4':
        return LatLng(-7.797068, 110.370529); // ~0.5 km dari pusat
      case 'Jl Jawa 5':
        return LatLng(-7.800000, 110.380000); // ~1.5 km dari pusat
      case 'Jl Kalimantan 10':
        return LatLng(-7.810000, 110.375000); // ~2.5 km dari pusat
      case 'Jl Sumatera':
        return LatLng(-7.785000, 110.385000); // ~3 km dari pusat
      default:
        return LatLng(-7.797068, 110.370529);
    }
  }

  String getLocationName(LatLng latLng) {
    // Fungsi untuk mendapatkan nama lokasi berdasarkan koordinat
    // Ini adalah implementasi sederhana, Anda bisa menggunakan reverse geocoding
    return "Lokasi Jemput (${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)})";
  }

  @override
  void initState() {
    super.initState();
    _toLatLng = getLatLng(widget.to);
  }

  double calculateDistance(LatLng from, LatLng to) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }

  void _setFromLocation() {
    setState(() {
      // Set lokasi asal ke koordinat default (sekitar area yang berbeda)
      _fromLatLng = LatLng(-7.790000, 110.365000); // Koordinat yang lebih jauh
      // Hitung jarak dan harga
      _distance = calculateDistance(_fromLatLng!, _toLatLng);
      // Debug print untuk melihat nilai
      print("Distance: $_distance km");
      print("From: ${_fromLatLng!.latitude}, ${_fromLatLng!.longitude}");
      print("To: ${_toLatLng.latitude}, ${_toLatLng.longitude}");
      
      _price = _distance! * 2000;
      print("Price before rounding: $_price");
      
      // Pastikan harga minimal 2000 (tarif dasar)
      if (_price! < 2000) {
        _price = 2000;
      }
      
      print("Final price: $_price");
    });
  }

  Future<void> _createOrder() async {
    if (_fromLatLng == null || _price == null || _distance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan pilih lokasi jemput terlebih dahulu!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Buat objek order
      final order = OrderScreenModel(
        idDriver: null, // Bisa diisi dengan ID driver yang tersedia
        lokasiJemput: getLocationName(_fromLatLng!),
        lokasiTujuan: widget.to,
        jarak: _distance!,
        harga: _price!,
      );

      // Kirim ke backend
      final createdOrder = await OrderScreenService.createOrder(order);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pemesanan berhasil dibuat! ID: ${createdOrder.id}"),
            backgroundColor: Colors.green,
          ),
        );
        
        // Kembali ke halaman sebelumnya setelah berhasil
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membuat pesanan: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PETA
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _toLatLng,
              initialZoom: 16,
              onTap: (_, latlng) {
                setState(() {
                  _fromLatLng = latlng;
                  _distance = calculateDistance(_fromLatLng!, _toLatLng);
                  print("Tap Distance: $_distance km");
                  _price = _distance! * 2000;
                  print("Tap Price: $_price");
                  
                  // Pastikan harga minimal 2000 (tarif dasar)
                  if (_price! < 2000) {
                    _price = 2000;
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _toLatLng,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 35),
                  ),
                  if (_fromLatLng != null)
                    Marker(
                      point: _fromLatLng!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 35),
                    ),
                ],
              ),
            ],
          ),

          // PANEL ATAS
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle, color: Colors.blue, size: 10),
                            const SizedBox(width: 6),
                            Text(
                              _fromLatLng != null ? 'Lokasi saya (terpilih)' : 'Lokasi saya',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _setFromLocation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Tambah", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.circle, color: Colors.red, size: 10),
                            const SizedBox(width: 6),
                            Text(widget.to, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // PANEL PESAN
          if (_fromLatLng != null && _price != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_bike, color: Colors.green),
                        const SizedBox(width: 10),
                        const Text(
                          'J-Ride',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          'Rp ${_price!.round()}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jarak: ${_distance!.toStringAsFixed(2)} km',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _createOrder,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Pesan',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}