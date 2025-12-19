/// @function scr_play_music(sound)
/// @param sound The music to play

function scr_play_music(sound) {
    // Stop current music
    if (audio_is_playing(global.current_music)) {
        audio_stop_sound(global.current_music);
    }
    
    // Play new music if enabled
    if (global.music_enabled) {
        global.current_music = audio_play_sound(sound, 1, true);
        audio_sound_gain(global.current_music, global.music_volume, 0);
    }
}
