// Check if mouse is hovering
is_hovered = position_meeting(mouse_x, mouse_y, id);

// Check if button is being pressed
is_pressed = is_hovered && mouse_check_button(mb_left);

// Determine glow intensity and visual state
if (is_selected) {
    image_blend = c_white;
    image_alpha = 1;
    target_glow = 1;
    target_multiplier = 1.0;
} else if (is_pressed) {
    image_blend = c_white;
    image_alpha = 1;
    target_glow = 0.8;
    target_multiplier = 1.15; // 15% bigger when clicked
} else if (is_hovered) {
    image_blend = c_white;
    image_alpha = 1;
    target_glow = 0.6;
    target_multiplier = 1.0;
} else {
    image_blend = c_white;
    image_alpha = 0.85;
    target_glow = 0;
    target_multiplier = 1.0;
}

// Smooth glow animation
glow_intensity = lerp(glow_intensity, target_glow, glow_speed);

// Smooth scale animation
scale_multiplier = lerp(scale_multiplier, target_multiplier, scale_speed);

// Apply multiplier to base scale
image_xscale = base_scale_x * scale_multiplier;
image_yscale = base_scale_y * scale_multiplier;
