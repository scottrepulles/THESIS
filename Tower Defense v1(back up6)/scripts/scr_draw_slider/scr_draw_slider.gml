/// @function draw_slider(xx, yy, ww, hh, handle_radius, value, label, col, is_active)

function draw_slider(xx, yy, ww, hh, handle_radius, value, label, col, is_active) {
    // Label
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text(xx, yy - 20, label);
    
    // Percentage
    draw_set_halign(fa_right);
    draw_set_color(col);
    draw_text_transformed(xx + ww, yy - 20, string(floor(value * 100)) + "%", 1.2, 1.2, 0);
    
    // Track shadow
    draw_set_color(c_black);
    draw_set_alpha(0.4);
    draw_roundrect(xx + 3, yy + 3, xx + ww + 3, yy + hh + 3, false);
    draw_set_alpha(1);
    
    // Track background
    draw_set_color(make_color_rgb(40, 40, 55));
    draw_roundrect(xx, yy, xx + ww, yy + hh, false);
    
    // Filled portion
    var fill_width = ww * value;
    if (fill_width > 4) {
        // Gradient fill
        draw_set_color(col);
        draw_roundrect(xx, yy, xx + fill_width, yy + hh, false);
        
        // Shine effect
        draw_set_alpha(0.4);
        draw_set_color(c_white);
        draw_roundrect(xx, yy, xx + fill_width, yy + hh * 0.5, false);
        draw_set_alpha(1);
    }
    
    // Handle
    var handle_x = xx + fill_width;
    var handle_y = yy + hh/2;
    
    // Handle shadow
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_circle(handle_x + 3, handle_y + 3, handle_radius, false);
    draw_set_alpha(1);
    
    // Handle glow when active
    if (is_active) {
        draw_set_alpha(0.4);
        draw_set_color(col);
        draw_circle(handle_x, handle_y, handle_radius + 6, false);
        draw_set_alpha(1);
    }
    
    // Handle
    draw_set_color(c_white);
    draw_circle(handle_x, handle_y, handle_radius, false);
    
    // Handle border
    draw_set_color(col);
    draw_circle(handle_x, handle_y, handle_radius - 2, true);
    draw_circle(handle_x, handle_y, handle_radius - 3, true);
    
    // Handle highlight
    draw_set_alpha(0.6);
    draw_set_color(c_white);
    draw_circle(handle_x - 3, handle_y - 3, handle_radius/3, false);
    draw_set_alpha(1);
}
