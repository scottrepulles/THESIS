// Use the size set in the room editor
button_width = sprite_width * image_xscale;
button_height = sprite_height * image_yscale;

// Hover properties
is_hovered = false;
hover_scale = 1;
target_scale = 1;
scale_speed = 0.15;

// Color properties
normal_color = c_white;
hover_color = c_yellow;
current_color = normal_color;
color_blend_speed = 0.2;

// Glow effect properties
glow_alpha = 0;
target_glow_alpha = 0;
glow_alpha_speed = 0.1;
glow_color = c_aqua;
glow_size = 10;

// Pulse effect
pulse_timer = 0;
pulse_speed = 0.05;
pulse_scale = 0;

// Click effect
click_scale = 1;
is_clicked = false;

// Shadow properties
shadow_offset = 4;
shadow_alpha = 0.5;
