// Countdown the display timer (frame-based)
if (global.last_change_timer > 0) {
    global.last_change_timer -= 1;
    if (global.last_change_timer <= 0) {
        global.last_change_timer = 0;
        global.last_trophy_change = 0; // clear after time ends
    }
}
