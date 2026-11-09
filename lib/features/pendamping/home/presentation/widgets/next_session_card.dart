import 'package:flutter/material.dart';
import '../../data/pendampingan_dummy.dart';
import '../home_style.dart';

class NextSessionCard extends StatelessWidget {
  final PendampinganItem item;
  final VoidCallback? onDetailTap;

  const NextSessionCard({super.key, required this.item, this.onDetailTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      decoration: BoxDecoration(
        color: HomeColors.lightBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [homeCardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.namaMahasiswa, style: HomeText.studentNameXL),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: HomeColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [homeCardShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.access_time,
                      size: 16, color: HomeColors.blue),
                  const SizedBox(width: 10),
                  Text(item.jam, style: HomeText.info),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.apartment,
                      size: 16, color: HomeColors.blue),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.lokasi, style: HomeText.info)),
                ]),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onDetailTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Lihat Detail', style: HomeText.detail),
              ),
            ),
          ),
        ],
      ),
    );
  }
}