import 'package:launchpad_binder/entity/entity.dart';

abstract class MidiUtils {
  static bool isNoteOn(List<int> packet) {
    if (packet.length < 3) return false;
    final velocity = packet[2];
    return velocity > 0;
  }

  static Pad? getPressedPad(List<int> packet,  Map<Pad, MidiPad>? mapping) {
    if (mapping == null || !isNoteOn(packet)) {
      return null;
    }
      return mapping.entries.firstWhere((el) => el.value.address == packet[1]).key;
  }
}
