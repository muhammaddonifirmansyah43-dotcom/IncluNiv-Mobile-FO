import 'package:flutter/foundation.dart';
import '../data/jadwal_dummy.dart';

/// State halaman jadwal: tab aktif + perpindahan status kartu.
/// Tanpa package tambahan (hanya ChangeNotifier bawaan Flutter).
class JadwalController extends ChangeNotifier {
  JadwalController({
    List<JadwalItem>? initialItems,
    JadwalStatus initialTab = JadwalStatus.akanDatang,
  })  : _items = List<JadwalItem>.of(initialItems ?? JadwalDummy.items),
        _tab = initialTab;

  final List<JadwalItem> _items;
  JadwalStatus _tab;

  JadwalStatus get tab => _tab;

  List<JadwalItem> get visibleItems =>
      _items.where((e) => e.status == _tab).toList();

  int count(JadwalStatus status) =>
      _items.where((e) => e.status == status).length;

  void selectTab(JadwalStatus status) {
    if (status == _tab) return;
    _tab = status;
    notifyListeners();
  }

  /// Akan Datang -> Berlangsung (tab ikut berpindah).
  void setujui(String id) => _move(id, JadwalStatus.berlangsung);

  /// Berlangsung -> Selesai (tab ikut berpindah).
  void konfirmasiKehadiran(String id) => _move(id, JadwalStatus.selesai);

  /// Perizinan diajukan: data dihapus dari halaman ini.
  /// Tab tidak berpindah, jadi jika kosong tampil empty state.
  void ajukanPerizinan(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void _move(String id, JadwalStatus target) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _items[i] = _items[i].copyWith(status: target);
    _tab = target;
    notifyListeners();
  }
}