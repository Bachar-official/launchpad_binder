import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiService {
  final MidiCommand _midi = MidiCommand();

  final _deviceNotifier = ValueNotifier<MidiDevice?>(null);
  Stream<MidiPacket>? _midiStream;
  StreamSubscription<MidiPacket>? _subscription;

  MidiDevice? get activeDevice => _deviceNotifier.value;

  Stream<MidiPacket>? get onMidiData => _midiStream;

  Future<List<MidiDevice>?> get devices async => await _midi.devices;

  void sendMidi({required int type, required int address, required int velocity}) {
    _midi.sendData(Uint8List.fromList([type, address, velocity]), deviceId: activeDevice?.id);
  }

  void clearMidi() {
    for (int i = 0; i < 200; i++) {
      sendMidi(type: 144, address: i, velocity: 0);
    }
  }

  Future<void> connectToDevice(MidiDevice? device) async {
    if (activeDevice?.id == device?.id) return;

    await disconnect();

    if (device == null) {
      _deviceNotifier.value = null;
      _midiStream = null;
      return;
    }

    await _midi.connectToDevice(device);
    _deviceNotifier.value = device;
    _midiStream = _midi.onMidiDataReceived;
  }

  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    if (activeDevice != null) {
      _midi.disconnectDevice(activeDevice!);
    }
    _deviceNotifier.value = null;
    _midiStream = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _midi.dispose();
  }
}