/// obj_button_shop - Step Event (Enhanced - replace previous)
var _mouse_x = mouse_x;
var _mouse_y = mouse_y;

var _sprite_width = sprite_get_width(sprite_index);
var _sprite_height = sprite_get_height(sprite_index);

if (point_in_rectangle(_mouse_x, _mouse_y, 
    x - _sprite_width/2, y - _sprite_height/2, 
    x + _sprite_width/2, y + _sprite_height/2)) {
    
    hover = true;
    glow_alpha = lerp(glow_alpha, 0.8, 0.15);
    glow_size = lerp(glow_size, 1.3, 0.15);
    
    // Pulsing effect
    pulse_timer += 0.2;
    
    window_set_cursor(cr_handpoint);
    
    if (mouse_check_button_pressed(mb_left)) {
        // Your shop code here
    }
} else {
    hover = false;
    glow_alpha = lerp(glow_alpha, 0, 0.15);
    glow_size = lerp(glow_size, 1, 0.15);
    pulse_timer = 0;
    
    window_set_cursor(cr_default);
}
