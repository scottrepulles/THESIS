// Check if mouse is hovering over the object
var sprite_w = sprite_get_width(spr_box) * box_width;
var sprite_h = sprite_get_height(spr_box) * box_height;

is_hovered = point_in_rectangle(
    mouse_x, 
    mouse_y,
    x - sprite_w / 2,
    y - sprite_h / 2,
    x + sprite_w / 2,
    y + sprite_h / 2
);

// Check if mouse is clicking
is_clicked = is_hovered && mouse_check_button(mb_left);

// Set target scale based on hover/click state
if (is_clicked) {
    target_scale = 0.95; // Slightly smaller when clicked
} else if (is_hovered) {
    target_scale = 1.1; // Slightly larger when hovered
} else {
    target_scale = 1; // Normal size
}

// Smooth scale transition
hover_scale = lerp(hover_scale, target_scale, scale_speed);

// Example: Do something when clicked
if (is_hovered && mouse_check_button_pressed(mb_left)) {
    // Add your click action here
    show_debug_message("Box clicked!");
    // Example: play_sound(snd_click);
}
