enum KeyCode {
  // Letters
  a, b, c, d, e, f, g, h, i, j, k, l, m,
  n, o, p, q, r, s, t, u, v, w, x, y, z,

  // Digits
  digit0, digit1, digit2, digit3, digit4,
  digit5, digit6, digit7, digit8, digit9,

  // Function keys
  f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12,

  // Modifiers
  shiftLeft, shiftRight,
  ctrlLeft, ctrlRight,
  altLeft, altRight,
  superLeft, superRight,

  // Navigation
  arrowUp, arrowDown, arrowLeft, arrowRight,
  home, end, pageUp, pageDown,

  // Special
  space, enter, escape, tab, backspace, delete, insert;

  static List<KeyCode> funcKeys = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12];
}
