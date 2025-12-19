// ===== obj_leaderboard STEP EVENT =====

if (room != rm_leaderboard) {
    instance_destroy();
    exit;
}

// ============================================
// REFRESH BUTTON LOGIC
// ============================================
var _mx = mouse_x;
var _my = mouse_y;

// Check if hovering over refresh button
refresh_button.is_hovered = point_in_rectangle(_mx, _my, 
    refresh_button.x, refresh_button.y, 
    refresh_button.x + refresh_button.width, 
    refresh_button.y + refresh_button.height);

// Animate button scale
refresh_button.target_scale = refresh_button.is_hovered ? 1.05 : 1;
refresh_button.scale = lerp(refresh_button.scale, refresh_button.target_scale, 0.2);

// Button click
if (refresh_button.is_hovered && mouse_check_button_pressed(mb_left) && !is_loading) {
    refresh_button.is_pressed = true;
    fetch_leaderboard();
    
    // Create particles
    for (var i = 0; i < 10; i++) {
        create_particle(
            refresh_button.x + refresh_button.width/2,
            refresh_button.y + refresh_button.height/2
        );
    }
    
    show_debug_message("🔄 Refresh button clicked!");
}

// Rotation animation when loading
if (is_loading) {
    refresh_button.rotation += 5;
}

// ============================================
// BACK BUTTON LOGIC
// ============================================
back_button.is_hovered = point_in_rectangle(_mx, _my, 
    back_button.x, back_button.y, 
    back_button.x + back_button.width, 
    back_button.y + back_button.height);

back_button.target_scale = back_button.is_hovered ? 1.05 : 1;
back_button.scale = lerp(back_button.scale, back_button.target_scale, 0.2);

if (back_button.is_hovered && mouse_check_button_pressed(mb_left)) {
    // Change this to your menu room
      room_goto(rm_menu);
}

// ============================================
// SMOOTH SCROLLING
// ============================================
if (ui.scroll_offset != ui.target_scroll) {
    ui.scroll_offset = lerp(ui.scroll_offset, ui.target_scroll, ui.scroll_speed);
    
    if (abs(ui.scroll_offset - ui.target_scroll) < 0.5) {
        ui.scroll_offset = ui.target_scroll;
    }
}

// Mouse wheel scrolling
if (point_in_rectangle(_mx, _my, ui.x, ui.y, ui.x + ui.width, ui.y + ui.height)) {
    var _scroll_delta = mouse_wheel_down() - mouse_wheel_up();
    ui.target_scroll += _scroll_delta * 30;
    
    var _max_scroll = max(0, (array_length(leaderboard_data) * ui.row_height) - ui.height + ui.header_height + ui.title_height + 100);
    ui.target_scroll = clamp(ui.target_scroll, 0, _max_scroll);
}

// ============================================
// ENTRY FADE ANIMATION
// ============================================
for (var i = 0; i < array_length(ui.entry_fade); i++) {
    if (ui.entry_fade[i] < 1) {
        ui.entry_fade[i] += 0.05;
    }
}

// ============================================
// PARTICLE UPDATE
// ============================================
for (var i = array_length(particles) - 1; i >= 0; i--) {
    var _p = particles[i];
    _p.x += _p.vx;
    _p.y += _p.vy;
    _p.vy += 0.2; // Gravity
    _p.life--;
    
    if (_p.life <= 0) {
        array_delete(particles, i, 1);
    }
}

// ============================================
// EFFECTS
// ============================================
trophy_shine_time += 0.05;
refresh_button.pulse_time += 0.1;
