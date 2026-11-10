import 'package:flutter/material.dart';
import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';

class OngoingSessionCard extends StatelessWidget {
  final PendampinganItem item;
  final VoidCallback? onDetailTap;

  const OngoingSessionCard({super.key, required this.item, this.onDetailTap});

  Widget _photo() {
    final url = item.fotoUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 118,
        height: 146,
        child: url == null
            ? _placeholder()
            : Image.network(url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder()),
      ),
    );
  }

  Widget _placeholder() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B8DEF), HomeColors.navy],
          ),
        ),
        child: const Icon(Icons.person, size: 72, color: HomeColors.white),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [homeCardShadow],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _photo(),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
                  decoration: BoxDecoration(
                    color: HomeColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [homeCardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profil Singkat', style: HomeText.profileLabel),
                      Text(item.namaMahasiswa,
                          style: HomeText.studentNameLarge),
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.access_time,
                            size: 16, color: HomeColors.blue),
                        const SizedBox(width: 8),
                        Text(item.jam, style: HomeText.info),
                      ]),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.apartment,
                              size: 16, color: HomeColors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(item.lokasi, style: HomeText.info)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onDetailTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 4),
                child: Text('Lihat Detail', style: HomeText.detail),
              ),
            ),
          ),
        ],
      ),
    );
  }
}