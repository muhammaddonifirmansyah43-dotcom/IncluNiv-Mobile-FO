import 'package:flutter/material.dart';
import '../jadwal_style.dart';

/// Notifikasi sukses hijau di kanan atas (tampil lewat Overlay,
/// jadi tidak mengubah layout halaman).
class SuccessToast {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastView(
        title: title,
        message: message,
        duration: duration,
        onDismissed: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }
}

class _ToastView extends StatefulWidget {
  final String title;
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;

  const _ToastView({
    required this.title,
    required this.message,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(widget.duration, () {
      if (!mounted) return;
      setState(() => _visible = false);
      Future.delayed(const Duration(milliseconds: 250), widget.onDismissed);
    });
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16A34A);
    const darkGreen = Color(0xFF166534);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 12,
      child: Material(
        color: Colors.transparent,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          offset: _visible ? Offset.zero : const Offset(0, -0.6),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _visible ? 1 : 0,
            child: Container(
              width: 262,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: const Color(0xFFBBF7C5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: green, width: 1),
                boxShadow: [jadwalShadow],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: green, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: JadwalText.dateBold.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: darkGreen),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.message,
                          style: JadwalText.disability.copyWith(
                              fontSize: 10.5,
                              height: 1.3,
                              color: darkGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}