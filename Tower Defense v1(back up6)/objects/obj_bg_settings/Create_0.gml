// Sprite setup
sprite_index = -1; // No sprite collision
depth = -100; // Higher priority

// Center on screen
x = room_width / 2;
y = room_height / 2;

// UI Colors - Enhanced Modern Theme
bg_overlay = make_color_rgb(10, 15, 25);
panel_color = make_color_rgb(30, 35, 50);
accent_color = make_color_rgb(64, 156, 255);
accent_color_2 = make_color_rgb(255, 87, 51);

// Title settings
title_text = "⚙ AUDIO SETTINGS ⚙";
title_font = -1;

// Disable persistence
persistent = false;

// Only allow in settings room
if (room != rm_settings) {
    instance_destroy();
    exit;
}
// Panel dimensions
panel_width = 800;
panel_height = 700;

// Music Toggle Button
music_toggle = {
    rel_x: 200,
    rel_y: -120,
    width: 140,
    height: 50,
    hover: false,
    scale: 1,
    target_scale: 1
};

// Music Slider
music_slider = {
    rel_x: -150,
    rel_y: -50,
    width: 450,
    height: 12,
    handle_radius: 12,
    dragging: false,
    hover: false
};

// SFX Toggle Button
sfx_toggle = {
    rel_x: 200,
    rel_y: 80,
    width: 140,
    height: 50,
    hover: false,
    scale: 1,
    target_scale: 1
};

// SFX Slider
sfx_slider = {
    rel_x: -150,
    rel_y: 150,
    width: 450,
    height: 12,
    handle_radius: 12,
    dragging: false,
    hover: false
};

// Back Button
back_button = {
    rel_x: 0,
    rel_y: 260,
    width: 200,
    height: 55,
    hover: false,
    scale: 1,
    target_scale: 1
};

// Animation variables
fade_alpha = 0;
panel_scale = 0.8;

// CREATE THE TOGGLE BUTTON OBJECTS
instance_create_depth(x + music_toggle.rel_x, y + music_toggle.rel_y, depth - 1, obj_settings_music_toggle);
instance_create_depth(x + sfx_toggle.rel_x, y + sfx_toggle.rel_y, depth - 1, obj_settings_sfx_toggle);