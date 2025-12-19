// Calculate final scale (room scale * hover effects)
var final_xscale = image_xscale * (hover_scale + pulse_scale) * click_scale;
var final_yscale = image_yscale * (hover_scale + pulse_scale) * click_scale;

// Draw outer glow effect (when hovered)
if (glow_alpha > 0.01) {
    for (var i = 0; i < 3; i++) {
        var glow_offset = (glow_size * (i + 1)) / 3;
        var glow_a = glow_alpha * (1 - (i / 3));
        
        draw_set_alpha(glow_a);
        draw_set_color(glow_color);
        draw_sprite_ext(sprite_index, image_index, x, y,
                       final_xscale + (glow_offset * 0.01),
                       final_yscale + (glow_offset * 0.01),
                       0, glow_color, glow_a);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Draw shadow
draw_set_alpha(shadow_alpha);
draw_set_color(c_black);
draw_sprite_ext(sprite_index, image_index, 
                x + shadow_offset, y + shadow_offset,
                final_xscale, final_yscale,
                0, c_black, shadow_alpha);
draw_set_alpha(1);

// Draw the button sprite with effects
draw_sprite_ext(sprite_index, image_index, x, y,
                final_xscale, final_yscale,
                0, current_color, 1);

// Draw "BUY" text in the center
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Calculate text scale based on button size
var text_scale = min(final_xscale, final_yscale);

// Text shadow
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_text_transformed(x + 2, y + 2, "BUY", 
                     text_scale, text_scale, 0);

// Main text
draw_set_alpha(1);
draw_set_color(is_hovered ? c_yellow : c_white);
draw_text_transformed(x, y, "BUY", 
                     text_scale, text_scale, 0);

// Draw border glow on hover
if (is_hovered) {
    draw_set_alpha(0.5 + (sin(pulse_timer * 2) * 0.3));
    draw_set_color(glow_color);
    draw_sprite_ext(sprite_index, image_index, x, y,
                   final_xscale, final_yscale,
                   0, glow_color, 0.3);
}

// Reset draw settings
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
