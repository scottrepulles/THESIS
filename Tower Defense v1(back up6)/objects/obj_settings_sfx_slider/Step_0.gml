// Check for mouse press on slider
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mouse_x, mouse_y, x - slider_width, y - slider_width, x + width + slider_width, y + height + slider_width)) {
        dragging = true;
    }
}

// Release mouse
if (mouse_check_button_released(mb_left)) {
    if (dragging) {
        dragging = false;
        scr_save_audio_settings();
        
        // Play test sound
        if (global.sfx_enabled) {
            var sfx = audio_play_sound(snd_impact_arc_01, 10, false);
            audio_sound_gain(sfx, global.sfx_volume, 0);
        }
    }
}

// Drag slider
if (dragging) {
    // Calculate volume based on mouse position
    var relative_x = clamp(mouse_x - x, 0, width);
    global.sfx_volume = relative_x / width;
}
