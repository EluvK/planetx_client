import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SectorStatus { confirm, excluded }

extension SectorStatusExtension on SectorStatus {
  (Border, Color, BlendMode) get imageColor {
    switch (this) {
      case SectorStatus.confirm:
        return (Border.all(color: Colors.green), Colors.transparent, BlendMode.srcOver);
      case SectorStatus.excluded:
        return (Border.all(color: Colors.transparent), Colors.black.withAlpha(10), BlendMode.srcIn);
    }
  }

  Text get label {
    switch (this) {
      case SectorStatus.confirm:
        return Text('starmap_button_confirm'.tr, style: TextStyle(color: Colors.green));
      case SectorStatus.excluded:
        return Text('starmap_button_deny'.tr, style: TextStyle(color: Colors.red));
    }
  }

  Widget get icon {
    switch (this) {
      case SectorStatus.confirm:
        return Icon(Icons.check, color: Colors.green);
      case SectorStatus.excluded:
        return Icon(Icons.close, color: Colors.red);
    }
  }
}

typedef OneSectorStatus = List<SectorStatus>;
typedef AllSectorStatuses = List<OneSectorStatus>;

extension AllSectorStatusesExtension on AllSectorStatuses {
  AllSectorStatuses clone() {
    return map((e) => e.map((e) => e).toList()).toList();
  }
}

class SectorStatusController extends GetxController {
  final _history = <AllSectorStatuses>[].obs;
  int _currentIndex = -1.obs;
  final sectorStatus = <OneSectorStatus>[].obs;

  @override
  Future<void> onInit() async {
    _beginInit = true;

    newGame();

    super.onInit();
    _initialized = true;
  }

  bool _beginInit = false;
  bool _initialized = false;
  Future<void> ensureInitialization() async {
    if (!_beginInit) {
      await onInit();
    }
    while (!_initialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    return;
  }

  void newGame() {
    _history.clear();
    sectorStatus.value = List.generate(18, (index) => List.generate(6, (index) => SectorStatus.confirm));
    _history.add(sectorStatus.clone());
    _currentIndex = 0;
  }

  void updateStatus() {
    // print("call updateStatus: $_currentIndex, all: ${_history.length}");
    // 清除当前索引之后的历史
    if (_currentIndex < _history.length - 1) {
      // print("removeRange: ${_currentIndex + 1} - ${_history.length}");
      _history.removeRange(_currentIndex + 1, _history.length);
      // print("removeRange finish current: $_currentIndex  all: ${_history.length}");
    }

    _history.add(sectorStatus.clone());
    _currentIndex = _history.length - 1;
    print("updateStatus: $_currentIndex, all: ${_history.length}");
  }

  void undo() {
    if (_currentIndex <= 0) return;
    _currentIndex--;
    print("undo: $_currentIndex");
    sectorStatus.value = _history[_currentIndex].clone();
  }

  void redo() {
    if (_currentIndex >= _history.length - 1) return;
    _currentIndex++;
    print("redo: $_currentIndex");
    sectorStatus.value = _history[_currentIndex].clone();
  }

  bool get canUndo => _currentIndex > 0;
  bool get canRedo => _currentIndex < _history.length - 1;
}
