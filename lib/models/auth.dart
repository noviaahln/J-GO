class Auth {
  final int idPengguna;
  final String namaLengkap;
  final String email;
  final String katasandi;

  Auth({
    required this.idPengguna,
    required this.namaLengkap,
    required this.email,
    required this.katasandi,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      idPengguna: json['id_pengguna'],
      namaLengkap: json['nama_lengkap'],
      email: json['email'],
      katasandi: json['kata_sandi'],
    );
  }
}
