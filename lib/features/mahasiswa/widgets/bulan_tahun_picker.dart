
import 'package:flutter/material.dart';

import '../core/mhs_colors.dart';

Future<DateTime?> showBulanTahunPicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  const bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final tahunAwal = firstDate.year;
  final tahunAkhir = lastDate.year;

  final bulanController = FixedExtentScrollController(
    initialItem: initialDate.month - 1,
  );

  final tahunController = FixedExtentScrollController(
    initialItem: initialDate.year - tahunAwal,
  );

  int bulanTerpilih = initialDate.month;
  int tahunTerpilih = initialDate.year;

  DateTime? hasil;

  try {
    hasil = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: MhsColors.white,
              title: const Text(
                'Pilih Bulan & Tahun',
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: 320,
                height: 190,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'BULAN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: MhsColors.hint,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: bulanController,
                              itemExtent: 42,
                              physics:
                                  const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  bulanTerpilih = index + 1;
                                });
                              },
                              childDelegate:
                                  ListWheelChildBuilderDelegate(
                                childCount: 12,
                                builder: (context, index) {
                                  final aktif =
                                      bulanTerpilih == index + 1;

                                  return Center(
                                    child: Text(
                                      bulan[index],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: aktif
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: aktif
                                            ? MhsColors.blue
                                            : MhsColors.hint,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'TAHUN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: MhsColors.hint,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: tahunController,
                              itemExtent: 42,
                              physics:
                                  const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setDialogState(() {
                                  tahunTerpilih = tahunAwal + index;
                                });
                              },
                              childDelegate:
                                  ListWheelChildBuilderDelegate(
                                childCount:
                                    tahunAkhir - tahunAwal + 1,
                                builder: (context, index) {
                                  final tahun = tahunAwal + index;
                                  final aktif =
                                      tahunTerpilih == tahun;

                                  return Center(
                                    child: Text(
                                      '$tahun',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: aktif
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: aktif
                                            ? MhsColors.blue
                                            : MhsColors.hint,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    final tanggal = DateTime(
                      tahunTerpilih,
                      bulanTerpilih,
                      1,
                    );

                    if (tanggal.isBefore(
                          DateTime(firstDate.year, firstDate.month),
                        ) ||
                        tanggal.isAfter(
                          DateTime(lastDate.year, lastDate.month),
                        )) {
                      return;
                    }

                    Navigator.pop(dialogContext, tanggal);
                  },
                  child: const Text('Pilih'),
                ),
              ],
            );
          },
        );
      },
    );
  } finally {
    bulanController.dispose();
    tahunController.dispose();
  }

  return hasil;
}
