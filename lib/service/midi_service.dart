import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class MidiService {
  final MidiCommand _midi = MidiCommand();

  Stream<MidiPacket>? _midiStream;
  StreamSubscription<MidiPacket>? _subscription;

  MidiDevice? _activeDevice;
  MidiDevice? get activeDevice => _activeDevice;

  Stream<MidiPacket>? get onMidiData => _midiStream;

  Future<List<MidiDevice>?> get devices async => await _midi.devices;

  void sendMidi({required int type, required int address, required int velocity}) {
    _midi.sendData(Uint8List.fromList([type, address, velocity]), deviceId: _activeDevice?.id);
  }

  void clearMidi() {
    for (int i = 0; i < 200; i++) {
      sendMidi(type: 144, address: i, velocity: 0);
    }
  }

  Future<void> connectToDevice(MidiDevice? device) async {
    if (_activeDevice?.id == device?.id) return;

    await disconnect();

    if (device == null) {
      _activeDevice = null;
      _midiStream = null;
      return;
    }

    await _midi.connectToDevice(device);
    _activeDevice = device;
    _midiStream = _midi.onMidiDataReceived;
  }

  Future<void> disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    if (_activeDevice != null) {
      _midi.disconnectDevice(_activeDevice!);
    }
    _activeDevice = null;
    _midiStream = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _midi.dispose();
  }
}