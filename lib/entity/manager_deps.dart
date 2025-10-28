import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

typedef ManagerDeps = ({ Logger logger, GlobalKey<ScaffoldMessengerState> scaffoldKey, MidiCommand midi });