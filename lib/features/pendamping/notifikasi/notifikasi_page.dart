import 'package:flutter/material.dart';

class NotifikasiItem {
  final int id;
  final String judul;
  final String pesan;
  final String waktu;
  bool sudahDibaca;

  NotifikasiItem({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.sudahDibaca = false,
  });
}

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  static const Color navy = Color(0xFF0F2D5B);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color lightBlue = Color(0xFFE6F0FF);

  final List<NotifikasiItem> _notifikasi = [
    NotifikasiItem(
      id: 1,
      judul: 'Pendampingan Baru',
      pesan: 'Kamu mendapatkan tugas pendampingan untuk Carmenita',
      waktu: '08.00',
    ),
    NotifikasiItem(
      id: 2,
      judul: 'Pendampingan Baru',
      pesan: 'Kamu mendapatkan tugas pendampingan untuk Koenho',
      waktu: '08.00',
    ),
    NotifikasiItem(
      id: 3,
      judul: 'Pendampingan Baru',
      pesan: 'Kamu mendapatkan tugas pendampingan untuk Carmen',
      waktu: '07.00',
      sudahDibaca: true,
    ),
    NotifikasiItem(
      id: 4,
      judul: 'Pendampingan Baru',
      pesan: 'Kamu mendapatkan tugas pendampingan untuk Jamelin',
      waktu: '07.00',
      sudahDibaca: true,
    ),
    NotifikasiItem(
      id: 5,
      judul: 'Pendampingan Baru',
      pesan: 'Kamu mendapatkan tugas pendampingan untuk Kak Ia',
      waktu: '07.00',
      sudahDibaca: true,
    ),
  ];

  void _tandaiDibaca(int id) {
    setState(() {
      final index = _notifikasi.indexWhere((item) => item.id == id);

      if (index != -1) {
        _notifikasi[index].sudahDibaca = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final belumDibaca =
        _notifikasi.where((item) => !item.sudahDibaca).toList();

    final telahDibaca =
        _notifikasi.where((item) => item.sudahDibaca).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDF1FF),
        foregroundColor: navy,
        elevation: 1,
        shadowColor: Colors.black26,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25),
          tooltip: 'Kembali',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF17243B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          children: [
            _judulBagian('Belum dibaca'),
            const SizedBox(height: 10),

            if (belumDibaca.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Tidak ada notifikasi yang belum dibaca',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            ...belumDibaca.map(
              (item) => _kartuNotifikasi(item),
            ),

            const SizedBox(height: 16),
            _judulBagian('Telah dibaca'),
            const SizedBox(height: 10),

            if (telahDibaca.isEmpty)
              const Center(
                child: Text('Belum ada notifikasi yang dibaca'),
              ),

            ...telahDibaca.map(
              (item) => _kartuNotifikasi(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _judulBagian(String judul) {
    return Text(
      judul,
      style: const TextStyle(
        color: navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _kartuNotifikasi(NotifikasiItem item) {
    final bool dibaca = item.sudahDibaca;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: dibaca ? Colors.white : lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dibaca
              ? const Color(0xFFE1E1E1)
              : const Color(0xFFD9E6F9),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              14,
              18,
              dibaca ? 14 : 26,
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: dibaca ? orange : blue,
                  child: const Icon(
                    Icons.person,
                    size: 37,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.judul,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2235),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.pesan,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF273247),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          item.waktu,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF929292),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!dibaca)
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                tooltip: 'Tandai sebagai telah dibaca',
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => _tandaiDibaca(item.id),
                icon: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF1565C0),
                  size: 21,
                ),
              ),
            ),
        ],
      ),
    );
  }
}