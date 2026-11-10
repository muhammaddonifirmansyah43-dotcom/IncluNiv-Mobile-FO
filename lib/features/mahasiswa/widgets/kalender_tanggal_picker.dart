
import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';
import 'bulan_tahun_picker.dart';

Future<DateTime?> showKalenderTanggal({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  int? weekday,
}) async {
  DateTime bulanAktif = DateTime(initialDate.year, initialDate.month, 1);

  bool tanggalValid(DateTime tanggal) {
    final hari = DateTime(tanggal.year, tanggal.month, tanggal.day);
    final awal = DateTime(firstDate.year, firstDate.month, firstDate.day);
    final akhir = DateTime(lastDate.year, lastDate.month, lastDate.day);

    return !hari.isBefore(awal) &&
        !hari.isAfter(akhir) &&
        (weekday == null || hari.weekday == weekday);
  }

  DateTime? cariTanggal(DateTime bulan) {
    final jumlahHari = DateTime(bulan.year, bulan.month + 1, 0).day;

    for (int i = 1; i <= jumlahHari; i++) {
      final tanggal = DateTime(bulan.year, bulan.month, i);
      if (tanggalValid(tanggal)) return tanggal;
    }

    return null;
  }

  DateTime? tanggalTerpilih =
      tanggalValid(initialDate) ? initialDate : cariTanggal(bulanAktif);

  const namaBulan = [
    'Januari', 'Februari', 'Maret', 'April',
    'Mei', 'Juni', 'Juli', 'Agustus',
    'September', 'Oktober', 'November', 'Desember',
  ];

  const namaHari = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  return showDialog<DateTime>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final jumlahHari =
              DateTime(bulanAktif.year, bulanAktif.month + 1, 0).day;

          final offset =
              DateTime(bulanAktif.year, bulanAktif.month, 1).weekday % 7;

          return AlertDialog(
            backgroundColor: MhsColors.white,
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            title: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final pilihan = await showBulanTahunPicker(
                  context: dialogContext,
                  initialDate: bulanAktif,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if (pilihan == null) return;

                setDialogState(() {
                  bulanAktif = DateTime(pilihan.year, pilihan.month, 1);

                  if (tanggalTerpilih == null ||
                      tanggalTerpilih!.month != bulanAktif.month ||
                      tanggalTerpilih!.year != bulanAktif.year ||
                      !tanggalValid(tanggalTerpilih!)) {
                    tanggalTerpilih = cariTanggal(bulanAktif);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${namaBulan[bulanAktif.month - 1]} ${bulanAktif.year}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: MhsColors.navy,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: MhsColors.blue,
                    ),
                  ],
                ),
              ),
            ),
            content: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      for (final hari in namaHari)
                        Expanded(
                          child: Center(
                            child: Text(
                              hari,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: MhsColors.hint,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: offset + jumlahHari,
                    itemBuilder: (context, index) {
                      if (index < offset) {
                        return const SizedBox();
                      }

                      final nomor = index - offset + 1;
                      final tanggal = DateTime(
                        bulanAktif.year,
                        bulanAktif.month,
                        nomor,
                      );

                      final aktif = tanggalValid(tanggal);
                      final dipilih = tanggalTerpilih != null &&
                          tanggal.year == tanggalTerpilih!.year &&
                          tanggal.month == tanggalTerpilih!.month &&
                          tanggal.day == tanggalTerpilih!.day;

                      return InkWell(
                        customBorder: const CircleBorder(),
                        onTap: aktif
                            ? () {
                                setDialogState(() {
                                  tanggalTerpilih = tanggal;
                                });
                              }
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: dipilih
                                ? MhsColors.blue
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$nomor',
                            style: TextStyle(
                              fontSize: 12,
                              color: !aktif
                                  ? MhsColors.hint.withValues(alpha: 0.35)
                                  : dipilih
                                      ? MhsColors.white
                                      : MhsColors.navy,
                              fontWeight: dipilih
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: tanggalTerpilih == null
                    ? null
                    : () => Navigator.pop(
                          dialogContext,
                          tanggalTerpilih,
                        ),
                child: const Text('Pilih'),
              ),
            ],
          );
        },
      );
    },
  );
}
