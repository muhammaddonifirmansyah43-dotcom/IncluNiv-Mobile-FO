import 'package:flutter/material.dart';
import '../../data/jadwal_dummy.dart';
import '../jadwal_style.dart';

class JadwalCard extends StatelessWidget {
  final JadwalItem item;
  final VoidCallback? onAjukanPerizinan;
  final VoidCallback? onSetujui;
  final VoidCallback? onKonfirmasi;

  const JadwalCard({
    super.key,
    required this.item,
    this.onAjukanPerizinan,
    this.onSetujui,
    this.onKonfirmasi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: JadwalColors.lightBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [jadwalShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 12),
          _scheduleBox(),
          const SizedBox(height: 14),
          _studentBox(),
          if (item.status != JadwalStatus.selesai) ...[
            const SizedBox(height: 14),
            _actions(),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: JadwalColors.blue.withAlpha(46),
          ),
          child: const Icon(Icons.devices,
              size: 20, color: JadwalColors.blue),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.mataKuliah, style: JadwalText.courseTitle),
              Text('${item.kelas} • ${item.sks} SKS',
                  style: JadwalText.courseSub),
            ],
          ),
        ),
      ],
    );
  }

  Widget _whiteBox({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: JadwalColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      );

  Widget _iconRow(IconData icon, Widget text, {double size = 18}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: size, color: JadwalColors.blue),
          const SizedBox(width: 10),
          Expanded(child: text),
        ],
      );

  Widget _scheduleBox() {
    return _whiteBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconRow(
            Icons.calendar_today_outlined,
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: item.tanggal, style: JadwalText.dateBold),
                  TextSpan(
                    text: '  •  ',
                    style: JadwalText.dateLight.copyWith(
                        color: JadwalColors.slate.withAlpha(120)),
                  ),
                  TextSpan(text: item.jam, style: JadwalText.dateLight),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _iconRow(Icons.location_on_outlined,
              Text(item.lokasi, style: JadwalText.infoRow)),
          const SizedBox(height: 10),
          _iconRow(Icons.badge_outlined,
              Text('Mahasiswa: ${item.mahasiswa}',
                  style: JadwalText.infoRow)),
        ],
      ),
    );
  }

  Widget _photo() {
    final url = item.fotoUrl;
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [jadwalShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: url == null
            ? _photoPlaceholder()
            : Image.network(url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _photoPlaceholder(),),
      ),
    );
  }

  Widget _photoPlaceholder() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B8DEF), JadwalColors.navy],
          ),
        ),
        child: const Icon(Icons.person,
            size: 52, color: JadwalColors.white),
      );

  Widget _sideRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: JadwalColors.blue),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: JadwalText.sideInfo)),
          ],
        ),
      );

  Widget _studentBox() {
    return _whiteBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _photo(),
              const SizedBox(height: 8),
              Text(item.jenisDisabilitas, style: JadwalText.disability),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sideRow(Icons.accessible, item.kebutuhan),
                _sideRow(Icons.apartment, item.fakultas),
                _sideRow(Icons.phone, item.telepon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillButton(String label, Color color, VoidCallback? onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
          child: Text(label, style: JadwalText.button),
        ),
      ),
    );
  }

  Widget _actions() {
    if (item.status == JadwalStatus.akanDatang) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pillButton('Ajukan Perizinan', JadwalColors.navy, onAjukanPerizinan),
          _pillButton('Setujui', JadwalColors.navy, onSetujui),
        ],
      );
    }
    // berlangsung
    return Center(
      child: _pillButton(
          'Konfirmasi Kehadiran', JadwalColors.orange, onKonfirmasi),
    );
  }
}