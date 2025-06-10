class Pengguna {
  final int idPengguna;
  final String namaLengkap;
  final String jenisPengguna;

  Pengguna({
    required this.idPengguna,
    required this.namaLengkap,
    required this.jenisPengguna,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      idPengguna: json['id_pengguna'],
      namaLengkap: json['nama_lengkap'],
      jenisPengguna: json['jenis_pengguna'],
    );
  }
}
