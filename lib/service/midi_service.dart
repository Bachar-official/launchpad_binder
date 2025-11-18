import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rtmidi_dart/rtmidi_dart.dart';

class MidiService {
  final RtMidi _midi = RtMidi();

  final ValueNotifier<MidiDevice?> _deviceNotifier = ValueNotifier(null);
  StreamSubscription<List<int>>? _subscription;

  /// The currently connected device
  MidiDevice? get connectedDevice => _deviceNotifier.value;

  /// Used by UI to listen for device changes
  ValueListenable<MidiDevice?> get deviceListenable => _deviceNotifier;

  /// Get list of devices
  Future<List<MidiDevice>> getDevices() => _midi.devices;

  /// Main unified stream for incoming MIDI messages
  final StreamController<List<int>> _messagesController =
      StreamController<List<int>>.broadcast();

  Stream<List<int>> get messages => _messagesController.stream;

  /// Connect to a device and start forwarding its messages into [messages]
  void connect(MidiDevice device) {
    // Disconnect previous device if exists
    disconnect();

    device.open();
    _deviceNotifier.value = device;

    // Listen to new device messages
    _subscription = device.messages.listen((msg) {
      _messagesController.add(msg);
    });
  }

  /// Disconnect current device
  void disconnect() {
    _subscription?.cancel();
    _subscription = null;

    _deviceNotifier.value?.close();
    _deviceNotifier.value = null;
  }

  /// Send message to active device
  void send(List<int> data) {
    _deviceNotifier.value?.send(data);
  }

  void clearMidi() {
    for (int i = 0; i < 200; i++) {
      send([144, i, 0]);
    }
  }

  /// Gracefully dispose service
  void dispose() {
    disconnect();
    _messagesController.close();
  }
}
