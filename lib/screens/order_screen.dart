import 'package:flutter/material.dart';
import 'detail_order_screen.dart'; // Use relative import instead

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<String> _locations = [
    'Jl Jawa 4',
    'Jl Jawa 5',
    'Jl Kalimantan 10',
    'Jl Sumatera',
  ];

  void _goToDetail(String destination) {
    // Kirim lokasi tujuan saja
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailOrderScreen(to: destination),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Hijau
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'J-Ride',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black45)
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Kemana pun kamu pergi,\nayo kita kesana!',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Search bar (nonaktif, hanya gaya)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Mau kemana hari ini?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.location_on, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List lokasi tujuan
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _locations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final loc = _locations[index];
                return ListTile(
                  onTap: () => _goToDetail(loc),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEFEFEF),
                    child: Icon(Icons.location_on, color: Colors.green),
                  ),
                  title: Text(
                    loc,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}