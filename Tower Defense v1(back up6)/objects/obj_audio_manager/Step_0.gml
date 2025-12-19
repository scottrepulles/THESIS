// Update music volume in real-time
if (global.music_enabled && audio_is_playing(global.current_music)) {
    audio_sound_gain(global.current_music, global.music_volume, 0);
} else if (!global.music_enabled && audio_is_playing(global.current_music)) {
    audio_stop_sound(global.current_music);
}
