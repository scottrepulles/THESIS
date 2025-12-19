/// @function scr_save_audio_settings()

function scr_save_audio_settings() {
    ini_open("game_settings.ini");
    ini_write_real("Audio", "music_enabled", global.music_enabled);
    ini_write_real("Audio", "sfx_enabled", global.sfx_enabled);
    ini_write_real("Audio", "music_volume", global.music_volume);
    ini_write_real("Audio", "sfx_volume", global.sfx_volume);
    ini_close();
}
