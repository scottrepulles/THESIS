/// obj_quiz_manager - Draw GUI Event
// FIXED VERSION - Proper text spacing and no overlapping

// Block all quiz UI drawing unless game (wave) has started
if (!variable_global_exists("waves_have_started") || !global.waves_have_started) {
    exit;
}

// Get GUI dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// ===================================
// 1. QUIZ WARNING POPUP
// ===================================
if (quiz_warning_active) {
    var box_w = 400;
    var box_h = 140;
    var box_x = (gui_width - box_w) / 2;
    var box_y = (gui_height - box_h) / 2;

    // Full screen dark overlay
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);

    // Shadow
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_roundrect_ext(box_x + 4, box_y + 4, box_x + box_w + 4, box_y + box_h + 4, 15, 15, false);

    // Main warning box
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 152, 0));
    draw_roundrect_ext(box_x, box_y, box_x + box_w, box_y + box_h, 15, 15, false);
    
    // Inner dark panel
    draw_set_alpha(0.9);
    draw_set_color(make_color_rgb(33, 33, 33));
    draw_roundrect_ext(box_x + 8, box_y + 8, box_x + box_w - 8, box_y + box_h - 8, 12, 12, false);

    // Reset before drawing text
    draw_set_alpha(1);
    
    // Warning icon (animated)
    var icon_scale = 1 + sin(current_time * 0.01) * 0.1;
    draw_set_color(make_color_rgb(255, 193, 7));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(box_x + box_w/2, box_y + 30, "⚠", 1.5 * icon_scale, 1.5 * icon_scale, 0);

    // Warning text
    draw_set_color(c_white);
    draw_text_transformed(box_x + box_w/2, box_y + 60, "QUIZ INCOMING!", 0.7, 0.7, 0);
    
    // Countdown
    draw_set_color(make_color_rgb(255, 193, 7));
    var countdown = ceil(quiz_warning_timer / room_speed);
    draw_text_transformed(box_x + box_w/2, box_y + 82, "Starting in " + string(countdown) + "s", 0.6, 0.6, 0);
    
    // Difficulty indicator
    draw_set_alpha(0.8);
    draw_set_color(make_color_rgb(255, 152, 0));
    draw_roundrect_ext(box_x + box_w/2 - 35, box_y + box_h - 25, 
                       box_x + box_w/2 + 35, box_y + box_h - 10, 5, 5, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_text_transformed(box_x + box_w/2, box_y + box_h - 17, string_upper(quiz_warning_difficulty), 0.5, 0.5, 0);

    // Reset all settings
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

// ===================================
// 2. MAIN QUIZ BOX
// ===================================
if (global.quiz_active && quiz_alpha > 0) {
    // Full screen overlay
    draw_set_alpha(quiz_alpha * 0.75);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    
    // Quiz box dimensions
    var box_w = 760;
    var box_h = 640;
    var box_x = (gui_width - box_w) / 2;
    var box_y = (gui_height - box_h) / 2;

    // Shadow
    draw_set_alpha(quiz_alpha * 0.6);
    draw_set_color(c_black);
    draw_roundrect_ext(box_x + 6, box_y + 6, box_x + box_w + 6, box_y + box_h + 6, 15, 15, false);

    // Main box background
    draw_set_alpha(quiz_alpha * 0.98);
    draw_set_color(make_color_rgb(40, 40, 40));
    draw_roundrect_ext(box_x, box_y, box_x + box_w, box_y + box_h, 15, 15, false);

    // Header bar color
    var header_color;
    switch(global.quiz_difficulty) {
        case "easy": header_color = make_color_rgb(76, 175, 80); break;
        case "medium": header_color = make_color_rgb(255, 193, 7); break;
        case "hard": header_color = make_color_rgb(255, 87, 34); break;
        case "extreme": header_color = make_color_rgb(244, 67, 54); break;
        default: header_color = c_gray; break;
    }
    
    // Header bar
    draw_set_alpha(quiz_alpha);
    draw_set_color(header_color);
    draw_roundrect_ext(box_x, box_y, box_x + box_w, box_y + 50, 15, 15, false);
    draw_rectangle(box_x, box_y + 35, box_x + box_w, box_y + 50, false);

    // Header text
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(box_x + box_w/2, box_y + 25, "SQL QUIZ - " + string_upper(global.quiz_difficulty), 0.7, 0.7, 0);

    // Timer circle
    var time_left = ceil(global.quiz_timer / room_speed);
    var time_percent = time_left / (global.quiz_time_limit / room_speed);
    var timer_color;
    if (time_percent > 0.5) timer_color = make_color_rgb(76, 175, 80);
    else if (time_percent > 0.25) timer_color = make_color_rgb(255, 193, 7);
    else timer_color = make_color_rgb(244, 67, 54);
    
    draw_set_alpha(quiz_alpha * 0.9);
    draw_set_color(timer_color);
    draw_circle(box_x + box_w - 35, box_y + 25, 18, false);
    
    draw_set_alpha(quiz_alpha);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(box_x + box_w - 35, box_y + 25, string(time_left), 0.65, 0.65, 0);

    // ===== QUESTION SECTION =====
    var question_y = box_y + 65;
    var question_h = 140;
    
    draw_set_alpha(quiz_alpha * 0.3);
    draw_set_color(c_black);
    draw_roundrect_ext(box_x + 20, question_y, box_x + box_w - 20, question_y + question_h, 8, 8, false);

    // Question text - FIXED: Proper line separation
    draw_set_alpha(quiz_alpha);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    var q_scale = 0.75;
    // FIX: Line separation should be UNSCALED font height, not scaled
    var q_line_sep = string_height("Aby|gjpqQ") * 1.5; // Unscaled base height with spacing
    
    draw_text_ext_transformed(
        box_x + box_w/2, 
        question_y + 20, 
        global.quiz_question, 
        q_line_sep,           // FIXED: Use unscaled line separation
        (box_w - 100) / q_scale, // FIXED: Width must be divided by scale
        q_scale, q_scale, 0
    );

    // Content area
    var content_y = question_y + question_h + 25;
    
    if (global.quiz_difficulty == "extreme") {
        // ===== EXTREME - TYPING INTERFACE =====
        var input_x = box_x + 35;
        var input_y = content_y;
        var input_w = box_w - 70;
        var input_h = 130;
        
        // Input box shadow
        draw_set_alpha(quiz_alpha * 0.4);
        draw_set_color(c_black);
        draw_roundrect_ext(input_x + 3, input_y + 3, input_x + input_w + 3, input_y + input_h + 3, 8, 8, false);
        
        // Input box background
        draw_set_alpha(quiz_alpha * 0.9);
        draw_set_color(make_color_rgb(50, 50, 50));
        draw_roundrect_ext(input_x, input_y, input_x + input_w, input_y + input_h, 8, 8, false);
        
        // Input box border
        draw_set_alpha(quiz_alpha * 0.6);
        draw_set_color(header_color);
        draw_roundrect_ext(input_x, input_y, input_x + input_w, input_y + input_h, 8, 8, true);
        draw_roundrect_ext(input_x + 1, input_y + 1, input_x + input_w - 1, input_y + input_h - 1, 8, 8, true);
        
        // Typed answer - FIXED
        var answer_text = global.quiz_typing_answer;
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        if (answer_text == "") {
            draw_set_alpha(quiz_alpha * 0.4);
            draw_set_color(c_gray);
            answer_text = "Type your SQL query here...";
        } else {
            draw_set_alpha(quiz_alpha);
            draw_set_color(c_white);
        }
        
        var input_scale = 0.72;
        var input_line_sep = string_height("Aby|gjpqQ") * 1.4; // FIXED: Unscaled line separation
        
        draw_text_ext_transformed(
            input_x + 20, 
            input_y + 20, 
            answer_text, 
            input_line_sep,              // FIXED
            (input_w - 50) / input_scale, // FIXED: Width divided by scale
            input_scale, input_scale, 0
        );
        
        // Animated cursor
        if (!global.quiz_answered && global.quiz_typing_answer != "") {
            var cursor_blink = (current_time / 500) % 1 > 0.5;
            if (cursor_blink) {
                draw_set_alpha(quiz_alpha);
                draw_set_color(c_white);
                
                // Get cursor position based on actual rendered text
                var lines = string_count("\n", global.quiz_typing_answer);
                var last_line_start = string_last_pos("\n", global.quiz_typing_answer);
                var last_line = (last_line_start > 0) ? 
                    string_copy(global.quiz_typing_answer, last_line_start + 1, 
                               string_length(global.quiz_typing_answer) - last_line_start) : 
                    global.quiz_typing_answer;
                
                var text_width = string_width(last_line) * input_scale;
                var cursor_x = input_x + 20 + min(text_width, (input_w - 50));
                var cursor_y = input_y + 20 + (lines * input_line_sep * input_scale);
                var cursor_h = string_height("A") * input_scale;
                
                draw_line_width(cursor_x, cursor_y, cursor_x, cursor_y + cursor_h, 2);
            }
        }
        
        // Instructions
        draw_set_alpha(quiz_alpha * 0.6);
        draw_set_color(c_ltgray);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text_transformed(box_x + box_w/2, input_y + input_h + 12, 
                            "Press ENTER to submit • BACKSPACE to delete", 0.5, 0.5, 0);
        
    } else {
        // ===== MULTIPLE CHOICE OPTIONS =====
        var option_spacing = 82;
        var option_height = 68;
        
        for (var i = 0; i < array_length(global.quiz_options); i++) {
            var option_x = box_x + 35;
            var option_y = content_y + (i * option_spacing);
            var option_w = box_w - 70;
            
            // Determine colors
            var option_bg_color = make_color_rgb(50, 50, 50);
            var option_border_color = make_color_rgb(100, 100, 100);
            var option_text_color = c_white;
            
            if (global.quiz_answered) {
                if (i == global.quiz_correct_answer) {
                    option_bg_color = make_color_rgb(27, 94, 32);
                    option_border_color = make_color_rgb(76, 175, 80);
                } else if (i == global.quiz_selected_index && !global.quiz_correct) {
                    option_bg_color = make_color_rgb(183, 28, 28);
                    option_border_color = make_color_rgb(244, 67, 54);
                }
            } else {
                var mx = device_mouse_x_to_gui(0);
                var my = device_mouse_y_to_gui(0);
                if (mx > option_x && mx < option_x + option_w 
                    && my > option_y && my < option_y + option_height) {
                    option_bg_color = make_color_rgb(70, 70, 70);
                    option_border_color = header_color;
                }
                
                if (quiz_last_wrong && i == global.quiz_selected_index) {
                    option_bg_color = make_color_rgb(120, 30, 30);
                    option_border_color = make_color_rgb(244, 67, 54);
                }
            }
            
            // Option shadow
            draw_set_alpha(quiz_alpha * 0.4);
            draw_set_color(c_black);
            draw_roundrect_ext(option_x + 3, option_y + 3, option_x + option_w + 3, 
                             option_y + option_height + 3, 8, 8, false);
            
            // Option background
            draw_set_alpha(quiz_alpha * 0.9);
            draw_set_color(option_bg_color);
            draw_roundrect_ext(option_x, option_y, option_x + option_w, 
                             option_y + option_height, 8, 8, false);
            
            // Option border
            draw_set_alpha(quiz_alpha);
            draw_set_color(option_border_color);
            draw_roundrect_ext(option_x, option_y, option_x + option_w, 
                             option_y + option_height, 8, 8, true);
            
            // Number badge
            draw_set_alpha(quiz_alpha * 0.8);
            draw_set_color(option_border_color);
            draw_circle(option_x + 30, option_y + option_height/2, 17, false);
            
            draw_set_alpha(quiz_alpha);
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(option_x + 30, option_y + option_height/2, string(i + 1), 0.65, 0.65, 0);
            
            // Option text - REDUCED BY 25% (from 0.72 to 0.54)
            draw_set_color(option_text_color);
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            
            var opt_scale = 0.54;  // REDUCED: 0.72 * 0.75 = 0.54
            var opt_line_sep = string_height("Aby|gjpqQ") * 1.4; // FIXED: Unscaled
            
            draw_text_ext_transformed(
                option_x + 60, 
                option_y + option_height/2, 
                global.quiz_options[i], 
                opt_line_sep,                    // FIXED
                (option_w - 85) / opt_scale,     // FIXED: Width divided by scale
                opt_scale, opt_scale, 0
            );
        }
    }

    // Bottom section
    var bottom_section_y = box_y + box_h - 110;

    if (!global.quiz_answered) {
        // Wrong message
        if (quiz_last_wrong) {
            draw_set_alpha(quiz_alpha);
            draw_set_color(make_color_rgb(244, 67, 54));
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(box_x + box_w/2, bottom_section_y, "✗ WRONG! Try again.", 0.65, 0.65, 0);
        }
        
        // Attempts counter
        var attempts_y = bottom_section_y + 30;
        draw_set_alpha(quiz_alpha * 0.8);
        draw_set_color(make_color_rgb(60, 60, 60));
        draw_roundrect_ext(box_x + box_w/2 - 65, attempts_y, 
                          box_x + box_w/2 + 65, attempts_y + 28, 5, 5, false);
        
        draw_set_alpha(quiz_alpha);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(box_x + box_w/2, attempts_y + 14, 
                            "Attempts: " + string(global.quiz_attempts), 0.6, 0.6, 0);
        
        // Instructions
        if (global.quiz_difficulty != "extreme") {
            draw_set_alpha(quiz_alpha * 0.5);
            draw_set_color(c_ltgray);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text_transformed(box_x + box_w/2, attempts_y + 40, 
                                "Click an option or press 1-4", 0.5, 0.5, 0);
        }
    }

    // Result display
    if (global.quiz_answered) {
        var result_text = "";
        var result_color = c_white;
        
        if (global.quiz_correct) {
            result_text = "✓ CORRECT! +" + string(global.quiz_reward) + " coins!";
            result_color = make_color_rgb(76, 175, 80);
        } else {
            result_text = "✗ INCORRECT!";
            result_color = make_color_rgb(244, 67, 54);
            
            // Correct answer display - FIXED
            draw_set_alpha(quiz_alpha * 0.65);
            draw_set_color(c_ltgray);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            
            var correct_text = "Correct: ";
            if (global.quiz_difficulty == "extreme") {
                correct_text += global.quiz_correct_answer_text;
            } else {
                correct_text += global.quiz_options[global.quiz_correct_answer];
            }
            
            var result_scale = 0.68;
            var result_line_sep = string_height("Aby|gjpqQ") * 1.3; // FIXED: Unscaled
            
            draw_text_ext_transformed(
                box_x + box_w/2, 
                bottom_section_y, 
                correct_text, 
                result_line_sep,                 // FIXED
                (box_w - 100) / result_scale,    // FIXED: Width divided by scale
                result_scale, result_scale, 0
            );
        }
        
        // Result banner
        var result_banner_y = bottom_section_y + (global.quiz_correct ? 0 : 45);
        draw_set_alpha(quiz_alpha * 0.9);
        draw_set_color(result_color);
        draw_roundrect_ext(box_x + 35, result_banner_y, box_x + box_w - 35, result_banner_y + 34, 8, 8, false);
        
        draw_set_alpha(quiz_alpha);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(box_x + box_w/2, result_banner_y + 17, result_text, 0.68, 0.68, 0);
        
        // Penalty warning
        if (!global.quiz_correct) {
            draw_set_alpha(quiz_alpha * 0.75);
            draw_set_color(make_color_rgb(255, 152, 0));
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text_transformed(box_x + box_w/2, result_banner_y + 40, "⚠ Monster spawned!", 0.55, 0.55, 0);
        }
        
        // Closing message
        draw_set_alpha(quiz_alpha * 0.45);
        draw_set_color(c_gray);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text_transformed(box_x + box_w/2, box_y + box_h - 24, "Closing in a moment...", 0.5, 0.5, 0);
    }

    // FINAL RESET
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
