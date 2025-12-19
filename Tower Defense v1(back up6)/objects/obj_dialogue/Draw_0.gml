// Draw the dialogue box sprite
draw_self();

if (visible) {
    // Get the box dimensions
    var box_w = sprite_get_width(sprite_index);
    var box_h = sprite_get_height(sprite_index);

    // Center position of the box
    var center_x = x + box_w / 12;
    var center_y = y + box_h / 12;

    // Set alignment to center
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Draw text centered in the box
    draw_set_color(c_white);
    draw_text(center_x, center_y, messages[message_index]);


}
