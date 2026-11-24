
import 'package:flutter/foundation.dart';

import '../../../../shared/models/demo_auth_store.dart';
import '../../../../services/assignment_service.dart';
import '../data/jadwal_dummy.dart';

/// Penyimpanan data jadwal pendampingan.
///
/// Data demo, akun baru, dan akun backend
/// disimpan secara terpisah.
class JadwalDataStore extends ChangeNotifier {
  JadwalDataStore._();

  static final JadwalDataStore instance =
      JadwalDataStore._();

  final List<JadwalItem> _demoItems =
      List<JadwalItem>.of(JadwalDummy.items);

  final List<JadwalItem> _newAccountItems = [];

  final List<JadwalItem> _backendItems = [];

  bool _backendLoaded = false;

  bool get backendLoaded => _backendLoaded;

  /// Mengambil penugasan pendamping dari backend.
  Future<void> loadBackendAssignments() async {
    final response =
        await AssignmentService.getMyAssignments();

    final assignments = response
        .where((item) =>
            item['status']?.toString() != 'CANCELLED')
        .map(JadwalItem.fromJson)
        .toList();

    _backendItems
      ..clear()
      ..addAll(assignments);

    _backendLoaded = true;

    notifyListeners();
  }

  List<JadwalItem> itemsFor({
    required bool isNewAccount,
    bool isBackendAccount = false,
  }) {
    final List<JadwalItem> source;

    if (isBackendAccount) {
      source = _backendItems;
    } else if (isNewAccount) {
      source = _newAccountItems;
    } else {
      source = _demoItems;
    }

    return List<JadwalItem>.unmodifiable(source);
  }

  int count(
    JadwalStatus status, {
    required bool isNewAccount,
    bool isBackendAccount = false,
  }) {
    return itemsFor(
      isNewAccount: isNewAccount,
      isBackendAccount: isBackendAccount,
    ).where((item) => item.status == status).length;
  }


  void konfirmasiKehadiran(
    String id, {
    required bool isNewAccount,
  }) {
    _move(
      id,
      JadwalStatus.selesai,
      isNewAccount: isNewAccount,
    );
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
        _isBackendAccount =
            DemoAuthStore.instance.isBackendPendampingLogin,
        _tab = initialTab {
    if (_localItems == null) {
      JadwalDataStore.instance.addListener(
        _onStoreChanged,
      );

      if (_isBackendAccount) {
        loadBackendAssignments();
      }
    }
  }

  final List<JadwalItem>? _localItems;
  final bool _isNewAccount;
  final bool _isBackendAccount;

  JadwalStatus _tab;

  bool _isLoading = false;
  String? _loadError;

  JadwalStatus get tab => _tab;

  bool get isLoading => _isLoading;

  String? get loadError => _loadError;

  List<JadwalItem> get _items {
    if (_localItems != null) {
      return _localItems;
    }

    return JadwalDataStore.instance.itemsFor(
      isNewAccount: _isNewAccount,
      isBackendAccount: _isBackendAccount,
    );
  }

  List<JadwalItem> get visibleItems =>
      _items.where((item) => item.status == _tab).toList();

  int count(JadwalStatus status) =>
      _items.where((item) => item.status == status).length;

  /// Memuat daftar penugasan dari backend.
  Future<void> loadBackendAssignments() async {
    if (!_isBackendAccount) return;

    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      await JadwalDataStore.instance.loadBackendAssignments();
    } catch (e) {
      _loadError = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTab(JadwalStatus status) {
    if (status == _tab) return;

    _tab = status;
    notifyListeners();
  }

  /// Aksi lokal untuk sementara.
  /// Integrasi konfirmasi API dilakukan pada tahap berikutnya.
  void konfirmasiKehadiran(String id) {
    if (_localItems != null) {
      _moveLocal(id, JadwalStatus.selesai);
      return;
    }

    if (_isBackendAccount) return;

    JadwalDataStore.instance.konfirmasiKehadiran(
      id,
      isNewAccount: _isNewAccount,
    );

    _tab = JadwalStatus.selesai;
    notifyListeners();
  }

  void ajukanPerizinan(String id) {
    if (_localItems != null) {
      _localItems.removeWhere(
        (item) => item.id == id,
      );
      notifyListeners();
      return;
    }

    if (_isBackendAccount) return;

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


