// Calculate current scale for drawing
var current_scale_x = base_scale_x * scale_multiplier;
var current_scale_y = base_scale_y * scale_multiplier;

// Draw neon shadow layers (multiple layers for glow effect)
if (glow_intensity > 0) {
    gpu_set_blendmode(bm_add);
    
    // Outer glow layers
    for (var i = 3; i >= 1; i--) {
        var glow_offset = i * 3;
        var glow_alpha = (glow_intensity * 0.3) / i;
        
        // Bottom-right glow
        draw_sprite_ext(sprite_index, image_index, 
                        x + glow_offset, y + glow_offset, 
                        current_scale_x, current_scale_y, 0, c_aqua, glow_alpha);
        
        // Top-left glow
        draw_sprite_ext(sprite_index, image_index, 
                        x - glow_offset, y - glow_offset, 
                        current_scale_x, current_scale_y, 0, c_fuchsia, glow_alpha);
    }
    
    gpu_set_blendmode(bm_normal);
}

// Draw the main button sprite with scale
draw_sprite_ext(sprite_index, image_index, x, y, 
                current_scale_x, current_scale_y, 0, image_blend, image_alpha);

// Text rendering with neon effect
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Calculate text scale (use average of x and y scale)
var text_scale = (current_scale_x + current_scale_y) / 2;

// Neon text glow
if (glow_intensity > 0) {
    gpu_set_blendmode(bm_add);
    
    // Text glow layers
    draw_set_color(c_aqua);
    draw_set_alpha(glow_intensity * 0.5);
    draw_text_transformed(x + 2, y + 2, button_label, 
                          0.85 * text_scale, 0.85 * text_scale, 0);
    
    draw_set_color(c_fuchsia);
    draw_set_alpha(glow_intensity * 0.5);
    draw_text_transformed(x - 2, y - 2, button_label, 
                          0.85 * text_scale, 0.85 * text_scale, 0);
    
    gpu_set_blendmode(bm_normal);
}

// Text shadow
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_text_transformed(x + 1, y + 1, button_label, 
                      0.85 * text_scale, 0.85 * text_scale, 0);

// Main text
if (is_selected) {
    draw_set_color(c_aqua); // Cyan text when selected
} else if (is_pressed) {
    draw_set_color(c_white); // White text when pressed
} else if (is_hovered) {
    draw_set_color(c_yellow); // Yellow text on hover
} else {
    draw_set_color(c_white); // White text default
}
draw_set_alpha(1);
draw_text_transformed(x, y, button_label, 
                      0.85 * text_scale, 0.85 * text_scale, 0);

// Reset drawing settings
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
