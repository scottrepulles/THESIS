draw_self();

if (tutorial_visible && tutorial_message != "") {
    var box_w = 400;
    var box_h = 100;
    var box_x = x - box_w/2;
    var box_y = y - sprite_get_bbox_top(sprite_index) - box_h - 30;

    // Draw speech bubble background with shadow
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(30, 30, 30));
    draw_roundrect(box_x + 3, box_y + 3, box_x + box_w + 3, box_y + box_h + 3, false);
    
    draw_set_alpha(0.95);
    draw_set_color(c_white);
    draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);

    // Draw border
    draw_set_color(c_black);
    draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

    // Draw message text
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(box_x + box_w/2, box_y + box_h/2 - 10, tutorial_message, 24, box_w - 40);

    // Draw continue prompt
    if (global.tutorial_can_continue) {
        draw_set_alpha(0.7 + 0.3 * sin(current_time/200));
        draw_set_color(c_dkgray);
        draw_text(box_x + box_w/2, box_y + box_h - 20, "Click or press SPACE to continue");
    }

    // Reset draw settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}