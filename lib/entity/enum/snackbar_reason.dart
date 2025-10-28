import 'package:flutter/material.dart';

enum SnackbarReason {
  error,
  warning,
  success;

  Color toColor() => switch (this) {
    error => Colors.red,
    warning => Colors.orange,
    success => Colors.green,
  };

  SnackBar toSnackbar(String message) =>
      SnackBar(content: Text(message), backgroundColor: toColor());
}
