import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef _simulate_key_combo_c = Int32 Function(Pointer<Pointer<Utf8>> keys, Int32 count, Int32 holdMs);
typedef _simulate_key_combo_dart = int Function(Pointer<Pointer<Utf8>> keys, int count, int holdMs);

class KeySimulator {
  late final DynamicLibrary _lib;
  late final _simulate_key_combo_dart _simulate;

  KeySimulator._(this._lib, this._simulate);

  /// Инициализация библиотеки.
  /// [libPath] — путь к .so (если null, попытка открыть './linux/libkey_simulator.so').
  static KeySimulator init({String? libPath}) {
    // final path = libPath ?? Platform.isLinux ? './linux/libkey_simulator.so' : throw UnsupportedError('Only Linux supported in this build');
    final path = Platform.isLinux ? './linux/libkey_simulator.so' : throw UnsupportedError('Only Linux supported in this build');
    final lib = DynamicLibrary.open(path);
    final sim = lib.lookupFunction<_simulate_key_combo_c, _simulate_key_combo_dart>('simulate_key_combo');
    return KeySimulator._(lib, sim);
  }

  /// Симулирует нажатие комбинации [keys]. [holdMs] — сколько удерживать комбинацию (ms).
  /// Возвращает 0 при успехе, отрицательное при ошибке.
  int simulateKeyCombo(List<String> keys, {int holdMs = 50}) {
    final allocator = calloc;
    final ptr = allocator<Pointer<Utf8>>(keys.length);
    for (var i = 0; i < keys.length; ++i) {
      ptr[i] = keys[i].toNativeUtf8(allocator: allocator);
    }
    final result = _simulate(ptr, keys.length, holdMs);
    // освобождение
    for (var i = 0; i < keys.length; ++i) {
      allocator.free(ptr[i]);
    }
    allocator.free(ptr);
    return result;
  }
}
