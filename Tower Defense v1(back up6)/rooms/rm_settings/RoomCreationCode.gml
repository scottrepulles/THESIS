// Debug: Show mouse coordinates

show_debug_message("Settings room loaded");
show_debug_message("Music toggle at: " + string(obj_settings_music_toggle.x) + ", " + string(obj_settings_music_toggle.y));

// Play music on loop
audio_play_sound(snd_music_bg, 1, true);

// Create a temporary object to stop music on room end
var _stopper = instance_create_depth(0, 0, 0, obj_music_stopper);

instance_create_depth(0, 0, 0, obj_bg_settings);