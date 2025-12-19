// Draw dark overlay behind panel
draw_set_alpha(fade_alpha * 0.7);
draw_set_color(bg_overlay);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Apply scale animation
draw_set_alpha(fade_alpha);

// Draw panel background (custom drawn, not sprite)
// Shadow
draw_set_color(c_black);
draw_set_alpha(fade_alpha * 0.5);
draw_roundrect(x - 400 * panel_scale + 8, y - 350 * panel_scale + 8, 
               x + 400 * panel_scale + 8, y + 350 * panel_scale + 8, false);
draw_set_alpha(fade_alpha);

// Main panel
draw_set_color(panel_color);
draw_roundrect(x - 400 * panel_scale, y - 350 * panel_scale, 
               x + 400 * panel_scale, y + 350 * panel_scale, false);

// Panel border
draw_set_color(accent_color);
draw_set_alpha(fade_alpha * 0.8);
draw_roundrect(x - 400 * panel_scale, y - 350 * panel_scale, 
               x + 400 * panel_scale, y + 350 * panel_scale, true);
draw_roundrect(x - 395 * panel_scale, y - 345 * panel_scale, 
               x + 395 * panel_scale, y + 345 * panel_scale, true);
draw_set_alpha(fade_alpha);

// Only draw UI elements if fully visible
if (fade_alpha >= 0.9) {
    // === DRAW TITLE ===
    draw_set_font(title_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Title shadow
    draw_set_color(c_black);
    draw_text_transformed(x + 3, y - 280 + 3, title_text, 2.2, 2.2, 0);
    
    // Title
    draw_set_color(accent_color);
    draw_text_transformed(x, y - 280, title_text, 2.2, 2.2, 0);
    
    // === SECTION DIVIDERS ===
    draw_set_color(accent_color);
    draw_set_alpha(0.3);
    draw_line_width(x - 320, y - 200, x + 320, y - 200, 3);
    draw_line_width(x - 320, y, x + 320, y, 3);
    draw_set_alpha(1);
    
    // === MUSIC SECTION LABEL ===
    draw_set_halign(fa_left);
    draw_set_color(accent_color);
    draw_text_transformed(x - 330, y - 150, "MUSIC", 1.5, 1.5, 0);
    
    draw_custom_button(x + music_toggle.rel_x - 120, y + music_toggle.rel_y, music_btn_w, music_btn_h, "ON", (global.music_enabled ? accent_color : make_color_rgb(96,125,139)), music_on_hover);
    draw_custom_button(x + music_toggle.rel_x + 120, y + music_toggle.rel_y, music_btn_w, music_btn_h, "OFF", (!global.music_enabled ? accent_color : make_color_rgb(96,125,139)), music_off_hover);
    
    draw_custom_slider(
        x + music_slider.rel_x,
        y + music_slider.rel_y,
        music_slider.width,
        music_slider.height,
        music_slider.handle_radius,
        global.music_volume,
        "Music Volume",
        accent_color,
        music_slider.dragging || music_slider.hover
    );
    
    // === SFX SECTION LABEL ===
    draw_set_halign(fa_left);
    draw_set_color(accent_color_2);
    draw_text_transformed(x - 330, y + 50, "SOUND EFFECTS", 1.5, 1.5, 0);
    
    draw_custom_button(x + sfx_toggle.rel_x - 120, y + sfx_toggle.rel_y, sfx_btn_w, sfx_btn_h, "ON", (global.sfx_enabled ? accent_color_2 : make_color_rgb(96,125,139)), sfx_on_hover);
    draw_custom_button(x + sfx_toggle.rel_x + 120, y + sfx_toggle.rel_y, sfx_btn_w, sfx_btn_h, "OFF", (!global.sfx_enabled ? accent_color_2 : make_color_rgb(96,125,139)), sfx_off_hover);
    
    draw_custom_slider(
        x + sfx_slider.rel_x,
        y + sfx_slider.rel_y,
        sfx_slider.width,
        sfx_slider.height,
        sfx_slider.handle_radius,
        global.sfx_volume,
        "SFX Volume",
        accent_color_2,
        sfx_slider.dragging || sfx_slider.hover
    );
    
    // === BACK BUTTON ===
    draw_custom_button(
        x + back_button.rel_x,
        y + back_button.rel_y,
        back_button.width * back_button.scale,
        back_button.height * back_button.scale,
        "BACK TO MENU",
        make_color_rgb(96, 125, 139),
        back_button.hover
    );
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
