import 'package:flutter/material.dart';
import '../../data/jadwal_dummy.dart';
import '../jadwal_style.dart';

/// Pop up "Ajukan Perizinan".
/// Mengembalikan teks alasan jika "Ajukan" ditekan, atau null jika "Batal".
class AjukanPerizinanDialog extends StatefulWidget {
  final JadwalItem item;

  const AjukanPerizinanDialog({super.key, required this.item});

  static Future<String?> show(BuildContext context, JadwalItem item) {
    return showDialog<String>(
      context: context,
      builder: (_) => AjukanPerizinanDialog(item: item),
    );
  }

  @override
  State<AjukanPerizinanDialog> createState() => _AjukanPerizinanDialogState();
}

class _AjukanPerizinanDialogState extends State<AjukanPerizinanDialog> {
  final _reasonController = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final alasan = _reasonController.text.trim();
    if (alasan.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context).pop(alasan);
  }

  Widget _infoRow(IconData icon, Widget text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: JadwalColors.blue),
          const SizedBox(width: 10),
          Expanded(child: text),
        ],
      );

  Widget _scheduleBox() {
    final item = widget.item;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: JadwalColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
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
          _infoRow(Icons.location_on_outlined,
              Text(item.lokasi, style: JadwalText.infoRow)),
          const SizedBox(height: 10),
          _infoRow(Icons.badge_outlined,
              Text('Mahasiswa: ${item.mahasiswa}',
                  style: JadwalText.infoRow)),
        ],
      ),
    );
  }

  Widget _reasonField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: JadwalColors.white,
        borderRadius: BorderRadius.circular(12),
        border: _showError
            ? Border.all(color: const Color(0xFFDC2626), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tulis Alasan',
            style: JadwalText.disability
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _reasonController,
            minLines: 3,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: JadwalColors.navy,
            style: JadwalText.infoRow,
            onChanged: (_) {
              if (_showError) setState(() => _showError = false);
            },
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillButton(String label, VoidCallback onTap) {
    return Material(
      color: JadwalColors.orange,
      elevation: 2,
      shadowColor: JadwalColors.orange.withAlpha(120),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 9),
          child: Text(label,
              style: JadwalText.button.copyWith(fontSize: 14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: JadwalColors.lightBlue,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: JadwalColors.tabActive, width: 2),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ajukan Perizinan',
              textAlign: TextAlign.center,
              style: JadwalText.title.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 14),
            _scheduleBox(),
            const SizedBox(height: 14),
            _reasonField(),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  'Alasan wajib diisi',
                  style: JadwalText.disability
                      .copyWith(color: const Color(0xFFDC2626)),
                ),
              ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Batal di kiri
                  _pillButton('Batal', () => Navigator.of(context).pop()),
                  // Ajukan di kanan
                  _pillButton('Ajukan', _submit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}