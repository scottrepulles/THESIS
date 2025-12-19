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
    global.music_volume = relative_x / width;
    
    // Apply volume to current music
    if (variable_global_exists("current_music")) {
        if (audio_is_playing(global.current_music)) {
            audio_sound_gain(global.current_music, global.music_volume, 0);
        }
    }
    
    // Also apply to background music directly
    if (audio_is_playing(snd_music_bg)) {
        audio_sound_gain(snd_music_bg, global.music_volume, 0);
    }
    if (audio_is_playing(snd_music_ingame)) {
        audio_sound_gain(snd_music_ingame, global.music_volume, 0);
    }
}
