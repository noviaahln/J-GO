class OrderScreenModel {
  final int? id;
  final int? idDriver;
  final String lokasiJemput;
  final String lokasiTujuan;
  final double jarak;
  final double harga;
  final DateTime? waktuPemesanan;

  OrderScreenModel({
    this.id,
    this.idDriver,
    required this.lokasiJemput,
    required this.lokasiTujuan,
    required this.jarak,
    required this.harga,
    this.waktuPemesanan,
  });

  // ✅ Convert JSON ke objek Dart dengan error handling
  factory OrderScreenModel.fromJson(Map<String, dynamic> json) {
    return OrderScreenModel(
      id: json['id'] as int?,
      idDriver: json['idDriver'] as int?,
      lokasiJemput: json['lokasiJemput'] as String,
      lokasiTujuan: json['lokasiTujuan'] as String,
      jarak: (json['jarak'] as num).toDouble(),
      harga: (json['harga'] as num).toDouble(),
      waktuPemesanan: json['waktuPemesanan'] != null
          ? DateTime.parse(json['waktuPemesanan'])
          : null,
    );
  }

  // ✅ Convert objek Dart ke JSON (dengan ID)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDriver': idDriver,
      'lokasiJemput': lokasiJemput,
      'lokasiTujuan': lokasiTujuan,
      'jarak': jarak,
      'harga': harga,
      'waktuPemesanan': waktuPemesanan?.toIso8601String(),
    };
  }

  // ✅ Untuk POST - tanpa ID dan dengan waktuPemesanan otomatis
  Map<String, dynamic> toJsonWithoutId() {
    return {
      'idDriver': idDriver,
      'lokasiJemput': lokasiJemput,
      'lokasiTujuan': lokasiTujuan,
      'jarak': jarak,
      'harga': harga,
      'waktuPemesanan': DateTime.now().toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'OrderScreenModel(id: $id, lokasiJemput: $lokasiJemput, lokasiTujuan: $lokasiTujuan, jarak: $jarak, harga: $harga)';
  }
}