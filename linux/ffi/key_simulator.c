#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <X11/extensions/XTest.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>   // malloc, free
#include <ctype.h>    // tolower

// Преобразует строку в KeySym
KeySym key_from_string(const char* key) {
    if (!key) return NoSymbol;

    // Преобразуем строку в нижний регистр
    size_t len = strlen(key);
    char buf[64];
    if (len >= sizeof(buf)) len = sizeof(buf) - 1;
    for (size_t i = 0; i < len; ++i)
        buf[i] = (char)tolower((unsigned char)key[i]);
    buf[len] = '\0';

    // Преобразуем специальные клавиши
    if (strcmp(buf, "ctrl") == 0) return XK_Control_L;
    if (strcmp(buf, "alt") == 0) return XK_Alt_L;
    if (strcmp(buf, "shift") == 0) return XK_Shift_L;
    if (strcmp(buf, "super") == 0 || strcmp(buf, "meta") == 0) return XK_Super_L;

    // Преобразуем одиночные символы
    if (strlen(buf) == 1)
        return XStringToKeysym(buf);

    // Попробуем через стандартный Xlib-символ
    return XStringToKeysym(buf);
}

// Эмуляция комбинации клавиш
void simulate_key_combo(const char** keys, int count) {
    if (count <= 0) return;

    Display* display = XOpenDisplay(NULL);
    if (!display) {
        fprintf(stderr, "Cannot open X display\n");
        return;
    }

    KeyCode* keycodes = (KeyCode*)malloc(sizeof(KeyCode) * count);
    if (!keycodes) {
        fprintf(stderr, "Memory allocation failed\n");
        XCloseDisplay(display);
        return;
    }

    // Преобразуем все ключи
    for (int i = 0; i < count; ++i) {
        KeySym sym = key_from_string(keys[i]);
        keycodes[i] = XKeysymToKeycode(display, sym);
    }

    // Нажимаем
    for (int i = 0; i < count; ++i) {
        if (keycodes[i]) XTestFakeKeyEvent(display, keycodes[i], True, 0);
    }

    // Отпускаем (в обратном порядке)
    for (int i = count - 1; i >= 0; --i) {
        if (keycodes[i]) XTestFakeKeyEvent(display, keycodes[i], False, 0);
    }

    XFlush(display);
    free(keycodes);
    XCloseDisplay(display);
}
