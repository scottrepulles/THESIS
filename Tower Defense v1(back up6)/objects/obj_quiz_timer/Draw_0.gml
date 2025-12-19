/// obj_quiz_timer - Draw Event
// Enhanced timer display with modern UI design
// Always visible - shows different states

// Check if quiz manager exists
if (!instance_exists(obj_quiz_manager)) exit;

// Calculate center position
var center_x = x;
var center_y = y;

// Get sprite dimensions
var sprite_w = sprite_get_width(sprite_index);
var sprite_h = sprite_get_height(sprite_index);
var timer_radius = min(sprite_w, sprite_h) * 0.35;

// ===================================
// BACKGROUND PANEL
// ===================================
// Outer shadow
draw_set_alpha(0.4);
draw_set_color(c_black);
draw_roundrect_ext(
    center_x - sprite_w/2 + 4, 
    center_y - sprite_h/2 + 4, 
    center_x + sprite_w/2 + 4, 
    center_y + sprite_h/2 + 4, 
    12, 12, false
);

// Main background panel
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(33, 33, 33));
draw_roundrect_ext(
    center_x - sprite_w/2, 
    center_y - sprite_h/2, 
    center_x + sprite_w/2, 
    center_y + sprite_h/2, 
    12, 12, false
);

// Border
draw_set_alpha(0.6);
draw_set_color(timer_color);
draw_roundrect_ext(
    center_x - sprite_w/2, 
    center_y - sprite_h/2, 
    center_x + sprite_w/2, 
    center_y + sprite_h/2, 
    12, 12, true
);

// ===================================
// GLOW EFFECT
// ===================================
if (glow_alpha > 0) {
    draw_set_alpha(glow_alpha * 0.3);
    draw_set_color(timer_color);
    draw_circle(center_x, center_y, (timer_radius + glow_size) * pulse_scale, false);
    
    draw_set_alpha(glow_alpha * 0.2);
    draw_circle(center_x, center_y, (timer_radius + glow_size + 4) * pulse_scale, false);
}

// ===================================
// DRAW BASED ON DISPLAY MODE
// ===================================
switch(display_mode) {
    case "active":
        // ===== ACTIVE QUIZ =====
        var time_left = ceil(global.quiz_timer / room_speed);
        var time_limit = global.quiz_time_limit / room_speed;
        var time_percent = time_left / time_limit;
        
        // Progress circle background (dark)
        draw_set_alpha(0.4);
        draw_set_color(timer_bg_color);
        draw_circle(center_x, center_y, timer_radius * pulse_scale, false);
        
        // Progress arc (filled based on time remaining)
        draw_set_alpha(0.8);
        draw_set_color(timer_color);
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(center_x, center_y);
        
        var segments = 60;
        for (var i = 0; i <= segments * time_percent; i++) {
            var angle = (i / segments) * 360 - 90; // Start from top
            var px = center_x + lengthdir_x(timer_radius * pulse_scale, angle);
            var py = center_y + lengthdir_y(timer_radius * pulse_scale, angle);
            draw_vertex(px, py);
        }
        draw_primitive_end();
        
        // Inner circle (background for text)
        draw_set_alpha(0.9);
        draw_set_color(make_color_rgb(33, 33, 33));
        draw_circle(center_x, center_y, timer_radius * 0.75 * pulse_scale, false);
        
        // Circle outlines (draw multiple circles for thicker effect)
        draw_set_alpha(1);
        draw_set_color(timer_color);
        draw_circle(center_x, center_y, timer_radius * pulse_scale, true);
        draw_circle(center_x, center_y, timer_radius * pulse_scale - 1, true);
        draw_circle(center_x, center_y, timer_radius * 0.75 * pulse_scale, true);
        draw_circle(center_x, center_y, timer_radius * 0.75 * pulse_scale - 1, true);
        
        // Time number (compact)
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(center_x, center_y - 3, string(time_left), 1.5, 1.5, 0);
        
        // "seconds" label (smaller)
        draw_set_alpha(0.6);
        draw_set_color(c_ltgray);
        draw_text_transformed(center_x, center_y + 12, "sec", 0.5, 0.5, 0);
        
        // Top label with icon (smaller)
        draw_set_alpha(0.9);
        draw_set_color(timer_color);
        draw_text_transformed(center_x, center_y - timer_radius - 12, "QUIZ", 0.5, 0.5, 0);
        
        // Difficulty badge at bottom (smaller)
        var difficulty_text = string_upper(global.quiz_difficulty);
        var badge_color = timer_color;
        draw_set_alpha(0.9);
        draw_set_color(badge_color);
        draw_roundrect_ext(
            center_x - 25, 
            center_y + timer_radius + 6, 
            center_x + 25, 
            center_y + timer_radius + 18, 
            4, 4, false
        );
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_text_transformed(center_x, center_y + timer_radius + 12, difficulty_text, 0.5, 0.5, 0);
        break;
        
    case "warning":
        // ===== WARNING - QUIZ INCOMING =====
        var warning_time = ceil(obj_quiz_manager.quiz_warning_timer / room_speed);
        
        // Animated warning circle
        draw_set_alpha(0.6);
        draw_set_color(timer_bg_color);
        draw_circle(center_x, center_y, timer_radius * pulse_scale, false);
        
        // Rotating warning segments
        draw_set_alpha(0.9);
        draw_set_color(timer_color);
        var rotation_offset = (current_time * 0.1) % 360;
        for (var i = 0; i < 8; i++) {
            var angle = (i * 45) + rotation_offset;
            var inner_r = timer_radius * 0.6;
            var outer_r = timer_radius * pulse_scale;
            
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(center_x, center_y);
            
            for (var a = angle - 15; a <= angle + 15; a += 3) {
                var px = center_x + lengthdir_x(outer_r, a);
                var py = center_y + lengthdir_y(outer_r, a);
                draw_vertex(px, py);
            }
            draw_primitive_end();
        }
        
        // Inner circle
        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(33, 33, 33));
        draw_circle(center_x, center_y, timer_radius * 0.7, false);
        
        // Circle outline (multiple for thickness)
        draw_set_alpha(1);
        draw_set_color(timer_color);
        draw_circle(center_x, center_y, timer_radius * pulse_scale, true);
        draw_circle(center_x, center_y, timer_radius * pulse_scale - 1, true);
        draw_circle(center_x, center_y, timer_radius * pulse_scale - 2, true);
        
        // Warning time (compact)
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(center_x, center_y - 3, string(warning_time), 1.5, 1.5, 0);
        
        draw_set_alpha(0.6);
        draw_set_color(c_ltgray);
        draw_text_transformed(center_x, center_y + 12, "sec", 0.5, 0.5, 0);
        
        // Flashing warning label (smaller)
        var flash_alpha = 0.5 + sin(current_time * 0.2) * 0.5;
        draw_set_alpha(flash_alpha);
        draw_set_color(timer_color);
        draw_text_transformed(center_x, center_y - timer_radius - 12, "INCOMING", 0.5, 0.5, 0);
        
        // Next difficulty indicator (smaller)
        var next_diff = string_upper(obj_quiz_manager.quiz_warning_difficulty);
        draw_set_alpha(0.9);
        draw_set_color(timer_color);
        draw_roundrect_ext(
            center_x - 25, 
            center_y + timer_radius + 6, 
            center_x + 25, 
            center_y + timer_radius + 18, 
            4, 4, false
        );
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_text_transformed(center_x, center_y + timer_radius + 12, next_diff, 0.5, 0.5, 0);
        break;
        
    case "waiting":
        // ===== WAITING - COUNTDOWN TO NEXT QUIZ =====
        if (obj_quiz_manager.quiz_next_time > 0) {
            var next_quiz_time = ceil(obj_quiz_manager.quiz_next_time / room_speed);
            
            // Subtle circle background
            draw_set_alpha(0.3);
            draw_set_color(timer_bg_color);
            draw_circle(center_x, center_y, timer_radius, false);
            
            // Dotted circle progress (slow fill)
            var max_wait_time = 60; // Assume max 60 seconds for visual
            var wait_percent = clamp(1 - (next_quiz_time / max_wait_time), 0, 1);
            
            draw_set_alpha(0.5);
            draw_set_color(timer_color);
            var dots = 24;
            for (var i = 0; i < dots * wait_percent; i++) {
                var angle = (i / dots) * 360 - 90;
                var px = center_x + lengthdir_x(timer_radius, angle);
                var py = center_y + lengthdir_y(timer_radius, angle);
                draw_circle(px, py, 2, false);
            }
            
            // Inner circle
            draw_set_alpha(0.8);
            draw_set_color(make_color_rgb(45, 45, 45));
            draw_circle(center_x, center_y, timer_radius * 0.75, false);
            
            // Circle outline
            draw_set_alpha(0.5);
            draw_set_color(timer_color);
            draw_circle(center_x, center_y, timer_radius, true);
            
            // Time display (compact)
            draw_set_alpha(1);
            draw_set_color(c_ltgray);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            if (next_quiz_time >= 60) {
                // Format as MM:SS
                var minutes = floor(next_quiz_time / 60);
                var seconds = next_quiz_time % 60;
                var time_str = string(minutes) + ":" + (seconds < 10 ? "0" : "") + string(seconds);
                draw_text_transformed(center_x, center_y - 2, time_str, 1.2, 1.2, 0);
            } else {
                // Show seconds
                draw_text_transformed(center_x, center_y - 3, string(next_quiz_time), 1.4, 1.4, 0);
                draw_set_alpha(0.5);
                draw_text_transformed(center_x, center_y + 11, "sec", 0.5, 0.5, 0);
            }
            
            // Top label (smaller)
            draw_set_alpha(0.7);
            draw_set_color(c_gray);
            draw_text_transformed(center_x, center_y - timer_radius - 12, "NEXT QUIZ", 0.45, 0.45, 0);
            
            // Quiz count indicator (smaller)
            var quiz_count_text = string(obj_quiz_manager.room_quiz_count) + "/" + string(obj_quiz_manager.room_quiz_limit);
            draw_set_alpha(0.6);
            draw_set_color(c_dkgray);
            draw_roundrect_ext(
                center_x - 20, 
                center_y + timer_radius + 6, 
                center_x + 20, 
                center_y + timer_radius + 18, 
                4, 4, false
            );
            draw_set_alpha(0.8);
            draw_set_color(c_ltgray);
            draw_text_transformed(center_x, center_y + timer_radius + 12, quiz_count_text, 0.5, 0.5, 0);
            
        } else {
            // No more quizzes - completion state
            draw_set_alpha(0.3);
            draw_set_color(make_color_rgb(76, 175, 80));
            draw_circle(center_x, center_y, timer_radius, false);
            
            // Checkmark or completion icon (smaller)
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(76, 175, 80));
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(center_x, center_y, "✓", 2.5, 2.5, 0);
            
            // "COMPLETE" label (smaller)
            draw_set_alpha(0.9);
            draw_set_color(c_white);
            draw_text_transformed(center_x, center_y - timer_radius - 12, "COMPLETE", 0.5, 0.5, 0);
            
            // All quizzes done badge (smaller)
            draw_set_alpha(0.8);
            draw_set_color(make_color_rgb(76, 175, 80));
            draw_roundrect_ext(
                center_x - 28, 
                center_y + timer_radius + 6, 
                center_x + 28, 
                center_y + timer_radius + 18, 
                4, 4, false
            );
            draw_set_alpha(1);
            draw_set_color(c_white);
            var complete_text = string(obj_quiz_manager.room_quiz_limit) + "/" + string(obj_quiz_manager.room_quiz_limit) + " DONE";
            draw_text_transformed(center_x, center_y + timer_radius + 12, complete_text, 0.45, 0.45, 0);
        }
        break;
}

// Reset draw settings
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
