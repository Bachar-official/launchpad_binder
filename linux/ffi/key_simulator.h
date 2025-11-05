#ifndef KEY_SIMULATOR_H
#define KEY_SIMULATOR_H

#ifdef __cplusplus
extern "C" {
#endif

/// Simulates key pressing.
/// keys - array C-strings (UTF-8), count - array length.
/// hold_ms - how much time in ms holds keys (0 = without hold).
/// Returns 0 if success, otherwise negative integer.
int simulate_key_combo(const char** keys, int count, int hold_ms);

#ifdef __cplusplus
}
#endif

#endif // KEY_SIMULATOR_H
