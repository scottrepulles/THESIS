/// obj_button_settings - Draw Event (Enhanced - replace previous)
// Draw outer glow with pulsing
if (glow_alpha > 0.01) {
    gpu_set_blendmode(bm_add);
    
    var _pulse = (sin(pulse_timer) + 1) / 2; // 0 to 1
    
    for (var i = 3; i > 0; i--) {
        var _glow_scale = glow_size + (i * 0.1) + (_pulse * 0.1);
        var _glow_a = (glow_alpha / i) * 0.5;
        
        // Alternate between green shades for depth
        var _color = (i % 2 == 0) ? neon_green : neon_lime;
        
        draw_sprite_ext(sprite_index, 0, x, y, 
            _glow_scale, _glow_scale, rotation, 
            _color, _glow_a);
    }
    
    gpu_set_blendmode(bm_normal);
}

// Main sprite
draw_sprite_ext(sprite_index, 0, x, y, 
    1, 1, rotation, c_white, 1);

// Bright overlay
if (hover) {
    gpu_set_blendmode(bm_add);
    var _pulse = (sin(pulse_timer) + 1) / 2;
    draw_sprite_ext(sprite_index, 0, x, y, 
        1, 1, rotation, neon_green, (glow_alpha * 0.3) + (_pulse * 0.2));
    gpu_set_blendmode(bm_normal);
}
