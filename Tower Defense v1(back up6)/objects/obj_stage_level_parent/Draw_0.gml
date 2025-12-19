// Stage Level Parent - Draw Event

// Safety check - ensure object is properly initialized
if (!variable_instance_exists(id, "stage_number") || stage_number <= 0) {
    draw_set_color(c_red);
    draw_text(x, y, "ERROR\nStage not\ninitialized");
    return;
}

// Get current button state
var button_state = get_button_state();
var star_count = get_star_count();
var unlocked = is_level_unlocked();

// Draw the sprite with the room-defined size and current animation scale
draw_sprite_ext(sprite_index, button_state, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Draw level number on top of the button
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Choose text color based on state
if (!unlocked) {
    draw_set_color(c_dkgray);
} else if (star_count == 0) {
    draw_set_color(c_white);
} else {
    draw_set_color(c_yellow);
}

// Draw level number with larger font
var text_scale = 5.0; // Adjust this value to make it larger or smaller (2.0 = double size)
draw_text_transformed(x, y - 10, string(stage_number), text_scale, text_scale, 0);

// Draw stars if completed
if (unlocked && star_count > 0) {
    var star_text = "";
    repeat(star_count) star_text += "*";
    draw_set_color(c_yellow);
    draw_text(x, y + 10, star_text);
}

// Draw lock icon if locked
if (!unlocked) {
    draw_set_color(c_red);
    draw_text(x, y + 10, "LOCKED");
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// Debug info (optional - remove in final version)
if (keyboard_check(vk_f1)) {
    draw_set_color(c_lime);
    draw_text(x - 40, y + 40, "Size: " + string(button_width) + "x" + string(button_height));
    draw_text(x - 40, y + 55, "Scale: " + string(image_xscale) + "x" + string(image_yscale));
    draw_text(x - 40, y + 70, "Original: " + string(original_xscale) + "x" + string(original_yscale));
    
    // Draw collision bounds
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    var left = x - (button_width / 2);
    var right = x + (button_width / 2);
    var top = y - (button_height / 2);
    var bottom = y + (button_height / 2);
    draw_rectangle(left, top, right, bottom, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
