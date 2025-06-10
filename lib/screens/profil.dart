import 'package:flutter/material.dart';
import '../models/profil_model.dart';
import '../services/profil_service.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Profil();
  }
}

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late Future<Pengguna> _profilFuture;

  @override
  void initState() {
    super.initState();
    _profilFuture = ProfilService.fetchPenggunaById(1); // Panggil pengguna id 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      appBar: AppBar(
        title: const Text('Akun Pengguna'),
        backgroundColor: const Color(0xFF00880D),
        elevation: 0,
      ),
      body: FutureBuilder<Pengguna>(
        future: _profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data pengguna tidak ditemukan.'));
          }

          final pengguna = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/5987/5987424.png",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pengguna.namaLengkap,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pengguna.jenisPengguna,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.contact_support_outlined,
                        title: 'Bantuan',
                        onTap: () {},
                      ),
                      _buildListTile(
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _buildListTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        onTap: () {
                          // Tambahkan logika logout jika perlu
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: TextStyle(color: textColor)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
