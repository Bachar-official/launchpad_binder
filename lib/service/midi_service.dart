import 'dart:async';

import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:logger/logger.dart';

class MidiService {
  final Logger logger;
  final MidiCommand _midi = MidiCommand();

  MidiService({required this.logger});

  Stream<MidiPacket>? _midiStream;
  StreamSubscription<MidiPacket>? _subscription;

  MidiDevice? _activeDevice;
  MidiDevice? get activeDevice => _activeDevice;

  Stream<MidiPacket>? get onMidiData => _midiStream;

  Future<List<MidiDevice>?> get devices async => await _midi.devices;

  Future<void> connectToDevice(MidiDevice? device) async {
    if (_activeDevice?.id == device?.id) return;

    await _disconnect();

    if (device == null) {
      _activeDevice = null;
      _midiStream = null;
      return;
    }

    await _midi.connectToDevice(device);
    _activeDevice = device;
    _midiStream = _midi.onMidiDataReceived;
  }

  Future<void> _disconnect() async {
    _subscription?.cancel();
    _subscription = null;
    if (_activeDevice != null) {
      _midi.disconnectDevice(_activeDevice!);
    }
    _activeDevice = null;
    _midiStream = null;
  }

  Future<void> dispose() async {
    await _disconnect();
    await _midi.dispose();
  }
}