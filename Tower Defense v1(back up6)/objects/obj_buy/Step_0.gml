// Update button size (in case image_xscale/yscale changes)
button_width = sprite_width * image_xscale;
button_height = sprite_height * image_yscale;

// Check if mouse is hovering over the button
is_hovered = point_in_rectangle(mouse_x, mouse_y, 
                                 x - (button_width / 2) * hover_scale, 
                                 y - (button_height / 2) * hover_scale,
                                 x + (button_width / 2) * hover_scale, 
                                 y + (button_height / 2) * hover_scale);

// Hover scale animation
if (is_hovered) {
    target_scale = 1.1;
    target_glow_alpha = 0.6;
    current_color = merge_color(current_color, hover_color, color_blend_speed);
} else {
    target_scale = 1;
    target_glow_alpha = 0;
    current_color = merge_color(current_color, normal_color, color_blend_speed);
}

// Smooth scale transition
hover_scale = lerp(hover_scale, target_scale, scale_speed);
glow_alpha = lerp(glow_alpha, target_glow_alpha, glow_alpha_speed);

// Pulse effect
pulse_timer += pulse_speed;
pulse_scale = sin(pulse_timer) * 0.05;

// Click detection
if (is_hovered && mouse_check_button_pressed(mb_left)) {
    is_clicked = true;
    click_scale = 0.9; // Shrink on click
    
    // Add your purchase logic here
    show_debug_message("Buy button clicked!");
    
    // Example purchase logic:
    // if (global.coins >= item_price) {
    //     global.coins -= item_price;
    //     show_message("Purchase successful!");
    // } else {
    //     show_message("Not enough coins!");
    // }
}

// Reset click animation
if (is_clicked) {
    click_scale = lerp(click_scale, 1, 0.2);
    if (abs(click_scale - 1) < 0.01) {
        is_clicked = false;
        click_scale = 1;
    }
}

// Reset on mouse release
if (mouse_check_button_released(mb_left)) {
    is_clicked = false;
}
