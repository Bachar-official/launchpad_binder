const _address = 'address';
const _type = 'type';

class MidiPad {
  final int type;
  final int address;

  const MidiPad({required this.address, required this.type});

  factory MidiPad.fromMap(Map<String, dynamic> map) => MidiPad(address: map[_address], type: map[_type]);

  Map<String, dynamic> toMap() => {
    _address: address,
    _type: type,
  };
}