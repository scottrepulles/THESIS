// Adjust shadow properties based on hover
var current_shadow_alpha = is_hovered ? shadow_alpha * 1.5 : shadow_alpha;
var current_shadow_offset = is_hovered ? shadow_offset * 1.2 : shadow_offset;

// Draw neon blue shadow (drawn first, behind the box)
draw_sprite_ext(
    spr_box,
    0,
    x,
    y + current_shadow_offset,
    box_width * hover_scale,
    box_height * hover_scale,
    0,
    shadow_color,
    current_shadow_alpha
);

// Draw the main box with hover effect
draw_sprite_ext(
    spr_box,
    0,
    x,
    y,
    box_width * hover_scale,
    box_height * hover_scale,
    0,
    c_white,
    1
);
