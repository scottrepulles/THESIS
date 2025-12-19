/// @function draw_button(xx, yy, ww, hh, text, col, is_hover)

function draw_button(xx, yy, ww, hh, text, col, is_hover) {
    // Shadow
    draw_set_color(c_black);
    draw_set_alpha(0.4);
    draw_roundrect(xx - ww/2 + 4, yy - hh/2 + 4, xx + ww/2 + 4, yy + hh/2 + 4, false);
    draw_set_alpha(1);
    
    // Button background
    draw_set_color(col);
    draw_roundrect(xx - ww/2, yy - hh/2, xx + ww/2, yy + hh/2, false);
    
    // Gradient overlay
    draw_set_alpha(0.2);
    draw_set_color(c_white);
    draw_roundrect(xx - ww/2, yy - hh/2, xx + ww/2, yy - hh/2 + hh * 0.5, false);
    draw_set_alpha(1);
    
    // Hover glow
    if (is_hover) {
        draw_set_alpha(0.3);
        draw_set_color(c_white);
        draw_roundrect(xx - ww/2 - 3, yy - hh/2 - 3, xx + ww/2 + 3, yy + hh/2 + 3, true);
        draw_roundrect(xx - ww/2 - 4, yy - hh/2 - 4, xx + ww/2 + 4, yy + hh/2 + 4, true);
        draw_set_alpha(1);
    }
    
    // Border
    draw_set_color(c_white);
    draw_set_alpha(0.6);
    draw_roundrect(xx - ww/2, yy - hh/2, xx + ww/2, yy + hh/2, true);
    draw_set_alpha(1);
    
    // Text shadow
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_text(xx + 2, yy + 2, text);
    draw_set_alpha(1);
    
    // Text
    draw_set_color(c_white);
    draw_text(xx, yy, text);
}
