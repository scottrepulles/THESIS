// Initialize if needed
if (!variable_instance_exists(id, "hover")) {
    width = 140;
    height = 50;
    hover = false;
    scale = 1;
    target_scale = 1;
}

// Check hover
var left = x - width / 2;
var top = y - height / 2;
var right = x + width / 2;
var bottom = y + height / 2;

hover = point_in_rectangle(mouse_x, mouse_y, left, top, right, bottom);

// Scale animation
if (hover) {
    target_scale = 1.05;
    
    // Handle click
    if (mouse_check_button_pressed(mb_left)) {
        global.music_enabled = !global.music_enabled;
        
        if (!global.music_enabled) {
            audio_stop_sound(snd_music_bg);
            audio_stop_sound(snd_music_ingame);
            if (variable_global_exists("current_music")) {
                audio_stop_sound(global.current_music);
            }
        } else {
            if (room == rm_menu) {
                scr_play_music(snd_music_bg);
            } else {
                scr_play_music(snd_music_ingame);
            }
        }
        
        scr_save_audio_settings();
        scr_play_sfx(snd_tower_build_01);
    }
} else {
    target_scale = 1;
}

scale = lerp(scale, target_scale, 0.2);
