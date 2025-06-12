import 'package:flutter/material.dart';

class RiwayatScreen extends StatefulWidget {
  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  // Controller untuk search
  TextEditingController searchController = TextEditingController();
  
  // Filter yang aktif
  String activeFilter = 'Semua';
  
  // Data hasil pencarian dan filter
  List<Map<String, dynamic>> filteredData = [];

  // Sample data untuk riwayat perjalanan
  List<Map<String, dynamic>> riwayatData = [
    {
      'service': 'J-Ride',
      'from': 'Jl Gajah Mada',
      'to': 'Alun-alun Jember',
      'date': '12 Jun 2025',
      'time': '14:30',
      'distance': 3.5,
      'price': 'Rp 7.000',
      'status': 'Selesai',
      'icon': Icons.motorcycle,
    },
    {
      'service': 'J-Car',
      'from': 'Jl Sudarman',
      'to': 'Universitas Jember',
      'date': '11 Jun 2025',
      'time': '09:15',
      'distance': 8.2,
      'price': 'Rp 16.400',
      'status': 'Selesai',
      'icon': Icons.directions_car,
    },
    {
      'service': 'J-Ride',
      'from': 'Jl Panglima Sudirman',
      'to': 'Lippo Plaza Jember',
      'date': '10 Jun 2025',
      'time': '16:45',
      'distance': 2.8,
      'price': 'Rp 5.600',
      'status': 'Selesai',
      'icon': Icons.motorcycle,
    },
    {
      'service': 'J-Car',
      'from': 'Jl Kalimantan',
      'to': 'Stasiun Jember',
      'date': '09 Jun 2025',
      'time': '11:20',
      'distance': 4.5,
      'price': 'Rp 9.000',
      'status': 'Dibatalkan',
      'icon': Icons.directions_car,
    },
    {
      'service': 'J-Ride',
      'from': 'Jl Jawa',
      'to': 'Jember Fashion Carnival',
      'date': '08 Jun 2025',
      'time': '13:10',
      'distance': 1.8,
      'price': 'Rp 3.600',
      'status': 'Selesai',
      'icon': Icons.motorcycle,
    },
    {
      'service': 'J-Car',
      'from': 'Jl Letjen Suprapto',
      'to': 'Jember Park',
      'date': '07 Jun 2025',
      'time': '10:30',
      'distance': 6.3,
      'price': 'Rp 12.600',
      'status': 'Selesai',
      'icon': Icons.directions_car,
    },
    {
      'service': 'J-Ride',
      'from': 'Jl Hayam Wuruk',
      'to': 'Pasar Tanjung Jember',
      'date': '06 Jun 2025',
      'time': '15:20',
      'distance': 2.1,
      'price': 'Rp 4.200',
      'status': 'Selesai',
      'icon': Icons.motorcycle,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi data yang difilter
    filteredData = List.from(riwayatData);
    
    // Listener untuk search
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani perubahan pencarian
  void _onSearchChanged() {
    _filterData();
  }

  // Fungsi untuk filter data berdasarkan pencarian dan filter aktif
  void _filterData() {
    setState(() {
      filteredData = riwayatData.where((item) {
        // Filter berdasarkan pencarian
        String searchQuery = searchController.text.toLowerCase();
        bool matchesSearch = searchQuery.isEmpty ||
            item['from'].toLowerCase().contains(searchQuery) ||
            item['to'].toLowerCase().contains(searchQuery) ||
            item['date'].toLowerCase().contains(searchQuery) ||
            item['service'].toLowerCase().contains(searchQuery);

        // Filter berdasarkan service type
        bool matchesFilter = activeFilter == 'Semua' || 
            item['service'] == activeFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  // Fungsi untuk menangani klik filter
  void _onFilterTap(String filter) {
    setState(() {
      activeFilter = filter;
    });
    _filterData();
  }

  // Fungsi untuk clear search
  void _clearSearch() {
    searchController.clear();
    _filterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF00AA13),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header dengan search dan filter
          Container(
            color: Color(0xFF00AA13),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lihat semua aktivitasmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari riwayat perjalanan...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[500]),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter tabs
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                SizedBox(width: 8),
                _buildFilterChip('J-Ride'),
                SizedBox(width: 8),
                _buildFilterChip('J-Car'),
              ],
            ),
          ),
          
          // Hasil pencarian info
          if (searchController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Ditemukan ${filteredData.length} hasil untuk "${searchController.text}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          
          // List riwayat
          Expanded(
            child: filteredData.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return _buildRiwayatItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget untuk empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada riwayat perjalanan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            searchController.text.isNotEmpty
                ? 'Coba kata kunci yang berbeda'
                : 'Yang cocok dengan filter ini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = activeFilter == label;
    
    return GestureDetector(
      onTap: () => _onFilterTap(label),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF00AA13) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Color(0xFF00AA13) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatItem(Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan service dan status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF00AA13).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      item['icon'],
                      color: Color(0xFF00AA13),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    item['service'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item['status'] == 'Selesai' 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    color: item['status'] == 'Selesai' 
                        ? Colors.green[700]
                        : Colors.red[700],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Route information
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF00AA13),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.grey[300],
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['from'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      item['to'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          // Date, time, distance, and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item['date']} • ${item['time']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${item['distance']} km',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              Text(
                item['price'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00AA13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}