
import 'package:flutter/foundation.dart';

import '../../../../shared/models/demo_auth_store.dart';
import '../data/jadwal_dummy.dart';

/// Penyimpanan data jadwal sementara.
///
/// Akun demo dan akun baru memiliki daftar berbeda.
/// Beranda dan Jadwal Pendampingan membaca sumber data ini.
class JadwalDataStore extends ChangeNotifier {
  JadwalDataStore._();

  static final JadwalDataStore instance =
      JadwalDataStore._();

  final List<JadwalItem> _demoItems =
      List<JadwalItem>.of(JadwalDummy.items);

  final List<JadwalItem> _newAccountItems = [];

  List<JadwalItem> itemsFor({
    required bool isNewAccount,
  }) {
    final source =
        isNewAccount ? _newAccountItems : _demoItems;

    return List<JadwalItem>.unmodifiable(source);
  }

  int count(
    JadwalStatus status, {
    required bool isNewAccount,
  }) {
    return itemsFor(isNewAccount: isNewAccount)
        .where((item) => item.status == status)
        .length;
  }

  void setujui(
    String id, {
    required bool isNewAccount,
  }) {
    _move(id, JadwalStatus.berlangsung,
        isNewAccount: isNewAccount);
  }

  void konfirmasiKehadiran(
    String id, {
    required bool isNewAccount,
  }) {
    _move(id, JadwalStatus.selesai,
        isNewAccount: isNewAccount);
  }

  void ajukanPerizinan(
    String id, {
    required bool isNewAccount,
  }) {
    final source =
        isNewAccount ? _newAccountItems : _demoItems;

    final oldLength = source.length;

    source.removeWhere((item) => item.id == id);

    if (source.length != oldLength) {
      notifyListeners();
    }
  }

  void _move(
    String id,
    JadwalStatus target, {
    required bool isNewAccount,
  }) {
    final source =
        isNewAccount ? _newAccountItems : _demoItems;

    final index =
        source.indexWhere((item) => item.id == id);

    if (index < 0) return;

    source[index] =
        source[index].copyWith(status: target);

    notifyListeners();
  }
}

/// Controller untuk tab dan aksi Jadwal Pendampingan.
///
/// Tetap mendukung initialItems untuk preview mandiri.
/// Dalam aplikasi utama data berasal dari JadwalDataStore.
class JadwalController extends ChangeNotifier {
  JadwalController({
    List<JadwalItem>? initialItems,
    JadwalStatus initialTab = JadwalStatus.akanDatang,
    bool? isNewAccount,
  })  : _localItems = initialItems == null
            ? null
            : List<JadwalItem>.of(initialItems),
        _isNewAccount = isNewAccount ??
            DemoAuthStore.instance.isNewPendampingLogin,
        _tab = initialTab {
    if (_localItems == null) {
      JadwalDataStore.instance.addListener(
        _onStoreChanged,
      );
    }
  }

  final List<JadwalItem>? _localItems;
  final bool _isNewAccount;

  JadwalStatus _tab;

  JadwalStatus get tab => _tab;

  List<JadwalItem> get _items {
    if (_localItems != null) {
      return _localItems; 
    }

    return JadwalDataStore.instance.itemsFor(
      isNewAccount: _isNewAccount,
    );
  }

  List<JadwalItem> get visibleItems =>
      _items.where((item) => item.status == _tab).toList();

  int count(JadwalStatus status) =>
      _items.where((item) => item.status == status).length;

  void selectTab(JadwalStatus status) {
    if (status == _tab) return;

    _tab = status;
    notifyListeners();
  }

  /// Akan Datang -> Berlangsung.
  void setujui(String id) {
    if (_localItems != null) {
      _moveLocal(id, JadwalStatus.berlangsung);
      return;
    }

    JadwalDataStore.instance.setujui(
      id,
      isNewAccount: _isNewAccount,
    );

    _tab = JadwalStatus.berlangsung;
    notifyListeners();
  }

  /// Berlangsung -> Selesai.
  void konfirmasiKehadiran(String id) {
    if (_localItems != null) {
      _moveLocal(id, JadwalStatus.selesai);
      return;
    }

    JadwalDataStore.instance.konfirmasiKehadiran(
      id,
      isNewAccount: _isNewAccount,
    );

    _tab = JadwalStatus.selesai;
    notifyListeners();
  }

  /// Perizinan: hapus jadwal dari daftar aktif.
  void ajukanPerizinan(String id) {
    if (_localItems != null) {
      _localItems.removeWhere(
        (item) => item.id == id,
      );
      notifyListeners();
      return;
    }

    JadwalDataStore.instance.ajukanPerizinan(
      id,
      isNewAccount: _isNewAccount,
    );
  }

  void _moveLocal(
    String id,
    JadwalStatus target,
  ) {
    final items = _localItems!;

    final index =
        items.indexWhere((item) => item.id == id);

    if (index < 0) return;

    items[index] =
        items[index].copyWith(status: target);

    _tab = target;
    notifyListeners();
  }

  void _onStoreChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    if (_localItems == null) {
      JadwalDataStore.instance.removeListener(
        _onStoreChanged,
      );
    }

    super.dispose();
  }
}
