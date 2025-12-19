/// obj_quiz_timer - Step Event
// Update timer display based on quiz state

// Check if quiz manager exists
if (!instance_exists(obj_quiz_manager)) exit;

// Determine display mode based on quiz state
if (global.quiz_active && !global.quiz_answered) {
    // ACTIVE QUIZ - Show remaining time
    display_mode = "active";
    
    var time_left = ceil(global.quiz_timer / room_speed);
    var time_limit = global.quiz_time_limit / room_speed;
    var time_percent = time_left / time_limit;
    
    // Smooth time display transition
    current_time_display = lerp(current_time_display, time_left, 0.3);
    
    // Change color based on time remaining
    if (time_percent > 0.5) {
        timer_color = make_color_rgb(76, 175, 80); // Green
        timer_bg_color = make_color_rgb(27, 94, 32);
        pulse_speed = 0;
        glow_alpha = 0.3;
    } else if (time_percent > 0.25) {
        timer_color = make_color_rgb(255, 193, 7); // Yellow
        timer_bg_color = make_color_rgb(245, 127, 23);
        pulse_speed = 0.05;
        glow_alpha = 0.5;
    } else {
        timer_color = make_color_rgb(244, 67, 54); // Red
        timer_bg_color = make_color_rgb(183, 28, 28);
        pulse_speed = 0.1;
        glow_alpha = 0.8;
    }
    
    // Pulsing animation for urgency
    if (pulse_speed > 0) {
        pulse_scale = 1 + sin(current_time * pulse_speed) * 0.15;
        glow_size = 4 + sin(current_time * pulse_speed) * 3;
    } else {
        pulse_scale = 1;
        glow_size = 2;
    }
    
} else if (obj_quiz_manager.quiz_warning_active) {
    // WARNING - Quiz incoming
    display_mode = "warning";
    
    var warning_time = ceil(obj_quiz_manager.quiz_warning_timer / room_speed);
    current_time_display = lerp(current_time_display, warning_time, 0.3);
    
    timer_color = make_color_rgb(255, 152, 0); // Orange
    timer_bg_color = make_color_rgb(230, 81, 0);
    pulse_speed = 0.08;
    pulse_scale = 1 + sin(current_time * pulse_speed) * 0.2;
    glow_alpha = 0.7;
    glow_size = 5 + sin(current_time * pulse_speed) * 4;
    
} else {
    // WAITING - Show countdown to next quiz
    display_mode = "waiting";
    
    if (obj_quiz_manager.quiz_next_time > 0) {
        var next_quiz_time = ceil(obj_quiz_manager.quiz_next_time / room_speed);
        current_time_display = lerp(current_time_display, next_quiz_time, 0.3);
    }
    
    timer_color = make_color_rgb(158, 158, 158); // Gray
    timer_bg_color = make_color_rgb(66, 66, 66);
    pulse_speed = 0;
    pulse_scale = 1;
    glow_alpha = 0.2;
    glow_size = 2;
}

// Smooth transition animation
transition_progress = lerp(transition_progress, 1, 0.1);
