// Smooth entrance animation
if (fade_alpha < 1) {
    fade_alpha += 0.05;
}
if (panel_scale < 1) {
    panel_scale = lerp(panel_scale, 1, 0.1);
}

// Ensure ON/OFF button sizes exist
if (!variable_instance_exists(id, "music_btn_w")) { music_btn_w = 80; music_btn_h = 40; }
if (!variable_instance_exists(id, "sfx_btn_w")) { sfx_btn_w = 80; sfx_btn_h = 40; }

// === MUSIC SLIDER ===
var slider_x = x + music_slider.rel_x;
var slider_y = y + music_slider.rel_y;

music_slider.hover = point_in_rectangle(mouse_x, mouse_y,
    slider_x - 10, slider_y - 15,
    slider_x + music_slider.width + 10, slider_y + music_slider.height + 15);

if (mouse_check_button_pressed(mb_left) && music_slider.hover) {
    music_slider.dragging = true;
}

if (mouse_check_button_released(mb_left)) {
    if (music_slider.dragging) {
        scr_save_audio_settings();
        scr_play_sfx(snd_impact_arc_01);
    }
    music_slider.dragging = false;
}

if (music_slider.dragging) {
    var relative_x = clamp(mouse_x - slider_x, 0, music_slider.width);
    global.music_volume = relative_x / music_slider.width;
    
    if (variable_global_exists("current_music") && audio_is_playing(global.current_music)) {
        audio_sound_gain(global.current_music, global.music_volume, 0);
    }
    if (audio_is_playing(snd_music_bg)) {
        audio_sound_gain(snd_music_bg, global.music_volume, 0);
    }
    if (audio_is_playing(snd_music_ingame)) {
        audio_sound_gain(snd_music_ingame, global.music_volume, 0);
    }
}

// === SFX SLIDER ===
var sfx_slider_x = x + sfx_slider.rel_x;
var sfx_slider_y = y + sfx_slider.rel_y;

sfx_slider.hover = point_in_rectangle(mouse_x, mouse_y,
    sfx_slider_x - 10, sfx_slider_y - 15,
    sfx_slider_x + sfx_slider.width + 10, sfx_slider_y + sfx_slider.height + 15);

if (mouse_check_button_pressed(mb_left) && sfx_slider.hover) {
    sfx_slider.dragging = true;
}

if (mouse_check_button_released(mb_left)) {
    if (sfx_slider.dragging) {
        scr_save_audio_settings();
        scr_play_sfx(snd_impact_arc_01);
    }
    sfx_slider.dragging = false;
}

if (sfx_slider.dragging) {
    var relative_x = clamp(mouse_x - sfx_slider_x, 0, sfx_slider.width);
    global.sfx_volume = relative_x / sfx_slider.width;
}

var mus_on_x = x + music_toggle.rel_x - 120;
var mus_on_y = y + music_toggle.rel_y;
var mus_off_x = x + music_toggle.rel_x + 120;
var mus_off_y = y + music_toggle.rel_y;
var mus_on_l = mus_on_x - music_btn_w/2;
var mus_on_t = mus_on_y - music_btn_h/2;
var mus_on_r = mus_on_x + music_btn_w/2;
var mus_on_b = mus_on_y + music_btn_h/2;
var mus_off_l = mus_off_x - music_btn_w/2;
var mus_off_t = mus_off_y - music_btn_h/2;
var mus_off_r = mus_off_x + music_btn_w/2;
var mus_off_b = mus_off_y + music_btn_h/2;

music_on_hover = point_in_rectangle(mouse_x, mouse_y, mus_on_l, mus_on_t, mus_on_r, mus_on_b);
music_off_hover = point_in_rectangle(mouse_x, mouse_y, mus_off_l, mus_off_t, mus_off_r, mus_off_b);

if (mouse_check_button_pressed(mb_left)) {
    if (music_on_hover && !global.music_enabled) {
        global.music_enabled = true;
        if (room == rm_menu) scr_play_music(snd_music_bg); else scr_play_music(snd_music_ingame);
        scr_save_audio_settings();
        scr_play_sfx(snd_tower_build_01);
    }
    if (music_off_hover && global.music_enabled) {
        global.music_enabled = false;
        if (audio_is_playing(snd_music_bg)) audio_stop_sound(snd_music_bg);
        if (audio_is_playing(snd_music_ingame)) audio_stop_sound(snd_music_ingame);
        if (variable_global_exists("current_music") && audio_is_playing(global.current_music)) audio_stop_sound(global.current_music);
        scr_save_audio_settings();
        scr_play_sfx(snd_tower_build_01);
    }
}

var sfx_on_x = x + sfx_toggle.rel_x - 120;
var sfx_on_y = y + sfx_toggle.rel_y;
var sfx_off_x = x + sfx_toggle.rel_x + 120;
var sfx_off_y = y + sfx_toggle.rel_y;
var sfx_on_l = sfx_on_x - sfx_btn_w/2;
var sfx_on_t = sfx_on_y - sfx_btn_h/2;
var sfx_on_r = sfx_on_x + sfx_btn_w/2;
var sfx_on_b = sfx_on_y + sfx_btn_h/2;
var sfx_off_l = sfx_off_x - sfx_btn_w/2;
var sfx_off_t = sfx_off_y - sfx_btn_h/2;
var sfx_off_r = sfx_off_x + sfx_btn_w/2;
var sfx_off_b = sfx_off_y + sfx_btn_h/2;

sfx_on_hover = point_in_rectangle(mouse_x, mouse_y, sfx_on_l, sfx_on_t, sfx_on_r, sfx_on_b);
sfx_off_hover = point_in_rectangle(mouse_x, mouse_y, sfx_off_l, sfx_off_t, sfx_off_r, sfx_off_b);

if (mouse_check_button_pressed(mb_left)) {
    if (sfx_on_hover && !global.sfx_enabled) {
        global.sfx_enabled = true;
        scr_save_audio_settings();
        scr_play_sfx(snd_tower_build_01);
    }
    if (sfx_off_hover && global.sfx_enabled) {
        global.sfx_enabled = false;
        scr_save_audio_settings();
    }
}

var back_btn_x = x + back_button.rel_x;
var back_btn_y = y + back_button.rel_y;
var back_btn_left = back_btn_x - back_button.width / 2;
var back_btn_top = back_btn_y - back_button.height / 2;
var back_btn_right = back_btn_x + back_button.width / 2;
var back_btn_bottom = back_btn_y + back_button.height / 2;

back_button.hover = point_in_rectangle(mouse_x, mouse_y, back_btn_left, back_btn_top, back_btn_right, back_btn_bottom);

if (back_button.hover) {
    back_button.target_scale = 1.05;
    if (mouse_check_button_pressed(mb_left)) {
        scr_play_sfx(snd_tower_build_02);
        room_goto(rm_menu);
    }
} else {
    back_button.target_scale = 1;
}
back_button.scale = lerp(back_button.scale, back_button.target_scale, 0.2);
