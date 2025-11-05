import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:launchpad_binder/entity/entity.dart';

abstract class MidiUtils {
  static bool isNoteOn(MidiPacket packet) {
    if (packet.data.length < 3) return false;
    final velocity = packet.data[2];
    return velocity > 0;
  }

  static Pad? getPressedPad(MidiPacket packet,  Map<Pad, MidiPad>? mapping) {
    if (mapping == null || !isNoteOn(packet)) {
      return null;
    }
      return mapping.entries.firstWhere((el) => el.value.address == packet.data[1]).key;
  }
}
