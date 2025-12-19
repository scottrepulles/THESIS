/// @function scr_play_sfx(sound)
/// @param sound The sound effect to play

function scr_play_sfx(sound) {
    if (global.sfx_enabled) {
        var sfx = audio_play_sound(sound, 10, false);
        audio_sound_gain(sfx, global.sfx_volume, 0);
        return sfx;
    }
    return noone;
}
