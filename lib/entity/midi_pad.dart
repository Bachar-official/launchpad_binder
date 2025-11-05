class MidiPad {
  final int type;
  final int address;

  const MidiPad({required this.address, required this.type});

  factory MidiPad.fromMap(Map<String, dynamic> map) => MidiPad(address: map['address'], type: map['type']);

  Map<String, dynamic> toMap() => {
    'address': address,
    'type': type,
  };
}