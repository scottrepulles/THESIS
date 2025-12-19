/// Draw Event of obj_evaluation - WITH EXPLANATIONS

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ============================================
// INITIAL STATE: Sprite Button - ALWAYS DRAW SPRITE
// ============================================
if (!show_result && current_question == 0 && !answered) {
    var scale_factor = 1.0;
    var hover_alpha = 1.0;
    
    if (position_meeting(mouse_x, mouse_y, id)) {
        scale_factor = lerp(scale_factor, 1.1, 0.15);
        hover_alpha = 0.95;
    }
    
    // Draw shadow
    if (shadow_alpha > 0.01) {
        draw_set_alpha(shadow_alpha * 0.2);
        draw_set_color(c_black);
        draw_circle(x, y, shadow_size + 15, false);
        
        draw_set_alpha(shadow_alpha * 0.4);
        draw_circle(x, y, shadow_size + 8, false);
        
        draw_set_alpha(shadow_alpha * 0.6);
        draw_circle(x, y, shadow_size, false);
        
        draw_set_alpha(1);
    }
    
    // Draw sprite
    image_alpha = hover_alpha;
    draw_sprite_ext(sprite_index, 0, x, y, scale_factor, scale_factor, 0, c_white, image_alpha);
    
    // "Evaluate" text
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_text_transformed(x + 2, y + 2, "Evaluate", 1.5, 1.5, 0);
    draw_set_alpha(1);
    draw_set_color(text_primary);
    draw_text_transformed(x, y, "Evaluate", 1.5, 1.5, 0);
}

// ============================================
// QUESTION STATE - SPRITE INVISIBLE BUT OBJECT ACTIVE
// ============================================
else if (show_result && current_question < total_questions && !evaluation_complete) {
    // DON'T DRAW SPRITE - Object remains active for clicks
    
    // Semi-transparent backdrop
    draw_set_alpha(0.7 * box_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Box shadow and background (rounded corners)
    var shadow_offset = 8;
    var r = corner_radius;
    var box_left = box_x - box_width/2;
    var box_right = box_x + box_width/2;
    var box_top = box_y - box_height/2;
    var box_bottom = box_y + box_height/2;
    
    // Shadow layers
    draw_set_alpha(0.3 * box_alpha);
    draw_set_color(c_black);
    draw_rectangle(box_left + shadow_offset + r, box_top + shadow_offset, 
                   box_right + shadow_offset - r, box_bottom + shadow_offset, false);
    draw_rectangle(box_left + shadow_offset, box_top + shadow_offset + r, 
                   box_right + shadow_offset, box_bottom + shadow_offset - r, false);
    draw_circle(box_left + shadow_offset + r, box_top + shadow_offset + r, r, false);
    draw_circle(box_right + shadow_offset - r, box_top + shadow_offset + r, r, false);
    draw_circle(box_left + shadow_offset + r, box_bottom + shadow_offset - r, r, false);
    draw_circle(box_right + shadow_offset - r, box_bottom + shadow_offset - r, r, false);
    draw_set_alpha(1);
    
    // Main box background with rounded corners
    draw_set_alpha(box_alpha);
    draw_set_color(primary_color);
    draw_rectangle(box_left + r, box_top, box_right - r, box_bottom, false);
    draw_rectangle(box_left, box_top + r, box_right, box_bottom - r, false);
    draw_circle(box_left + r, box_top + r, r, false);
    draw_circle(box_right - r, box_top + r, r, false);
    draw_circle(box_left + r, box_bottom - r, r, false);
    draw_circle(box_right - r, box_bottom - r, r, false);
    
    // Gradient top section
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(box_left + r, box_top, box_right - r, box_top + 80, false);
    draw_rectangle(box_left, box_top + r, box_right, box_top + 80, false);
    draw_circle(box_left + r, box_top + r, r, false);
    draw_circle(box_right - r, box_top + r, r, false);
    
    // Border - top
    draw_set_color(accent_color);
    draw_set_alpha(box_alpha * 0.8);
    draw_rectangle(box_left + r, box_top, box_right - r, box_top + 2, false);
    
    // Border - bottom
    draw_rectangle(box_left + r, box_bottom - 2, box_right - r, box_bottom, false);
    
    // Border - left
    draw_rectangle(box_left, box_top + r, box_left + 2, box_bottom - r, false);
    
    // Border - right
    draw_rectangle(box_right - 2, box_top + r, box_right, box_bottom - r, false);
    
    // Border - corners
    draw_set_alpha(box_alpha * 0.8);
    draw_circle(box_left + r, box_top + r, r, true);
    draw_circle(box_right - r, box_top + r, r, true);
    draw_circle(box_left + r, box_bottom - r, r, true);
    draw_circle(box_right - r, box_bottom - r, r, true);
    draw_set_alpha(1);
    
    // ----------------------------------------
    // X BUTTON (CLOSE BUTTON)
    // ----------------------------------------
    var x_btn_x = box_x + box_width/2 - x_button_size/2 - 15;
    var x_btn_y = box_y - box_height/2 + x_button_size/2 + 15;
    
    // X button shadow
    draw_set_alpha(0.3 * box_alpha);
    draw_set_color(c_black);
    draw_circle(x_btn_x + 2, x_btn_y + 2, x_button_size/2, false);
    draw_set_alpha(box_alpha);
    
    // Check if hovering over X button
    var x_hitbox = x_button_size + 15;
    var x_hovering = point_in_rectangle(mouse_x, mouse_y, 
                                         x_btn_x - x_hitbox/2, x_btn_y - x_hitbox/2,
                                         x_btn_x + x_hitbox/2, x_btn_y + x_hitbox/2);
    
    // X button circle
    draw_set_color(x_hovering ? x_button_hover_color : x_button_color);
    draw_circle(x_btn_x, x_btn_y, x_button_size/2, false);
    
    // X button border
    draw_set_color(c_white);
    draw_circle(x_btn_x, x_btn_y, x_button_size/2, true);
    
    // X symbol
    var x_offset = x_button_size/4;
    draw_line_width(x_btn_x - x_offset, x_btn_y - x_offset, 
                    x_btn_x + x_offset, x_btn_y + x_offset, 3);
    draw_line_width(x_btn_x + x_offset, x_btn_y - x_offset, 
                    x_btn_x - x_offset, x_btn_y + x_offset, 3);
    
    // ----------------------------------------
    // HEADER AND PROGRESS
    // ----------------------------------------
    var header_y = box_y - box_height/2 + 45;
    
    // Main title
    draw_set_color(text_primary);
    draw_set_alpha(box_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(box_x, header_y, "SQL EVALUATION", 1.5, 1.5, 0);
    
    // Progress text
    var progress_text = "Question " + string(current_question + 1) + " of " + string(total_questions);
    draw_set_color(text_secondary);
    draw_text(box_x, header_y + 30, progress_text);
    
    // Progress bar background
    var prog_x = box_x - progress_bar_width/2;
    var prog_y = header_y + 55;
    var progress_percent = (current_question) / total_questions;
    
    draw_set_color(secondary_color);
    draw_roundrect(prog_x, prog_y, prog_x + progress_bar_width, prog_y + progress_bar_height, false);
    
    // Progress bar fill
    draw_set_color(accent_color);
    var prog_fill_width = progress_bar_width * progress_percent;
    if (prog_fill_width > 0) {
        draw_roundrect(prog_x, prog_y, prog_x + prog_fill_width, prog_y + progress_bar_height, false);
    }
    
    draw_set_alpha(1);
    
    // ----------------------------------------
    // QUESTION TEXT
    // ----------------------------------------
    var q = questions[current_question];
    var question_y = header_y + 50;
    
    draw_set_color(text_primary);
    draw_set_alpha(box_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(box_x, question_y + 35, q[0], 22, box_width - 100);
    
    // ----------------------------------------
    // ANSWER BUTTONS (A, B, C, D)
    // ----------------------------------------
    var start_y = question_y + 100;
    
    for (var i = 0; i < 4; i++) {
        var ay = start_y + i * (answer_button_height + answer_button_spacing);
        var ax = box_x;
        
        var btn_left = ax - answer_button_width/2;
        var btn_top = ay - answer_button_height/2;
        var btn_right = ax + answer_button_width/2;
        var btn_bottom = ay + answer_button_height/2;
        
        // Check if hovering
        var is_hovering = point_in_rectangle(mouse_x, mouse_y, btn_left - 10, btn_top - 5, btn_right + 10, btn_bottom + 5);
        var button_color = secondary_color;
        var button_scale = 1.0;
        
        // Determine button appearance based on state
        if (answered) {
            // Show correct/incorrect colors after answering
            if (i == q[5]) {
                // Correct answer - always green
                button_color = success_color;
            } else if (i == selected_answer && i != q[5]) {
                // Wrong answer that was selected - red
                button_color = error_color;
            } else {
                // Other answers - default color
                button_color = secondary_color;
            }
        } else if (is_hovering && !answered) {
            // Hover state before answering
            button_color = accent_hover_color;
            button_scale = 1.02;
        } else {
            // Default state
            button_color = accent_color;
        }
        
        // Button shadow
        draw_set_alpha(0.3 * box_alpha);
        draw_set_color(c_black);
        draw_roundrect(btn_left + 4, btn_top + 4, btn_right + 4, btn_bottom + 4, false);
        
        // Button background
        draw_set_alpha(box_alpha);
        draw_set_color(button_color);
        draw_roundrect(btn_left, btn_top, btn_right, btn_bottom, false);
        
        // Button border/outline
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(box_alpha * 0.3);
        draw_roundrect(btn_left, btn_top, btn_right, btn_bottom, true);
        draw_set_alpha(box_alpha);
        
        // Answer letter (A, B, C, D)
        var letter = "";
        switch(i) {
            case 0: letter = "A"; break;
            case 1: letter = "B"; break;
            case 2: letter = "C"; break;
            case 3: letter = "D"; break;
        }
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(text_primary);
        
        // Draw letter with circle background
        var letter_x = btn_left + 25;
        var letter_y = ay;
        
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(box_alpha * 0.2);
        draw_circle(letter_x, letter_y, 15, false);
        draw_set_alpha(box_alpha);
        
        draw_set_color(text_primary);
        draw_text(letter_x, letter_y, letter);
        
        // Answer text
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text_ext(btn_left + 55, ay, q[i + 1], 18, answer_button_width - 80);
    }
    
    // ----------------------------------------
    // EXPLANATION BOX (Only visible after answering)
    // ----------------------------------------
    if (answered) {
        var explanation_box_y = box_y + box_height/2 - 180;
        var explanation_box_width = box_width - 120;
        var explanation_box_height = 100;
        
        var exp_left = box_x - explanation_box_width/2;
        var exp_right = box_x + explanation_box_width/2;
        var exp_top = explanation_box_y - explanation_box_height/2;
        var exp_bottom = explanation_box_y + explanation_box_height/2;
        
        // Explanation box shadow
        draw_set_alpha(0.2 * box_alpha);
        draw_set_color(c_black);
        draw_roundrect(exp_left + 4, exp_top + 4, exp_right + 4, exp_bottom + 4, false);
        
        // Explanation box background
        draw_set_alpha(box_alpha * 0.95);
        draw_set_color(make_color_rgb(40, 45, 60));
        draw_roundrect(exp_left, exp_top, exp_right, exp_bottom, false);
        
        // Explanation box border
        draw_set_alpha(box_alpha * 0.5);
        draw_set_color(selected_answer == q[5] ? success_color : warning_color);
        draw_roundrect(exp_left, exp_top, exp_right, exp_bottom, true);
        draw_set_alpha(box_alpha);
        
        // "Explanation" label
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(selected_answer == q[5] ? success_color : warning_color);
        draw_text_transformed(box_x, exp_top + 12, "EXPLANATION", 0.9, 0.9, 0);
        
        // Explanation text
        draw_set_color(text_primary);
        draw_set_valign(fa_top);
        draw_text_ext(box_x, exp_top + 35, q[6], 16, explanation_box_width - 40);
        
        draw_set_alpha(1);
    }
    
    // ----------------------------------------
    // NEXT BUTTON (Only visible after answering)
    // ----------------------------------------
    if (answered) {
        var next_btn_y = box_y + box_height/2 - 50;
        var next_btn_x = box_x;
        var next_btn_w = 220;
        var next_btn_h = 55;
        
        var next_left = next_btn_x - next_btn_w/2;
        var next_top = next_btn_y - next_btn_h/2;
        var next_right = next_btn_x + next_btn_w/2;
        var next_bottom = next_btn_y + next_btn_h/2;
        
        // Check if hovering
        var next_hover = point_in_rectangle(mouse_x, mouse_y, next_left - 10, next_top - 5, next_right + 10, next_bottom + 5);
        
        // Shadow
        draw_set_alpha(0.3 * box_alpha);
        draw_set_color(c_black);
        draw_roundrect(next_left + 4, next_top + 4, next_right + 4, next_bottom + 4, false);
        
        // Button
        draw_set_alpha(box_alpha);
        draw_set_color(next_hover ? accent_hover_color : accent_color);
        draw_roundrect(next_left, next_top, next_right, next_bottom, false);
        
        // Button border
        draw_set_color(c_white);
        draw_set_alpha(box_alpha * 0.5);
        draw_roundrect(next_left, next_top, next_right, next_bottom, true);
        draw_set_alpha(box_alpha);
        
        // Button text
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(text_primary);
        
        var next_text = (current_question < total_questions - 1) ? "NEXT QUESTION" : "VIEW RESULTS";
        draw_text_transformed(next_btn_x, next_btn_y, next_text, 1.0, 1.0, 0);
    }
    
    draw_set_alpha(1);
}

// ============================================
// RESULTS STATE - FINAL SCORE SCREEN
// ============================================
else if (evaluation_complete) {
    // Semi-transparent backdrop
    draw_set_alpha(0.7 * box_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    var result_box_width = 700;
    var result_box_height = 500;
    var r = corner_radius;
    var box_left = box_x - result_box_width/2;
    var box_right = box_x + result_box_width/2;
    var box_top = box_y - result_box_height/2;
    var box_bottom = box_y + result_box_height/2;
    
    // Shadow
    draw_set_alpha(0.3 * box_alpha);
    draw_set_color(c_black);
    draw_rectangle(box_left + 8 + r, box_top + 8, box_right + 8 - r, box_bottom + 8, false);
    draw_rectangle(box_left + 8, box_top + 8 + r, box_right + 8, box_bottom + 8 - r, false);
    draw_circle(box_left + 8 + r, box_top + 8 + r, r, false);
    draw_circle(box_right + 8 - r, box_top + 8 + r, r, false);
    draw_circle(box_left + 8 + r, box_bottom + 8 - r, r, false);
    draw_circle(box_right + 8 - r, box_bottom + 8 - r, r, false);
    draw_set_alpha(1);
    
    // Main box with rounded corners
    draw_set_alpha(box_alpha);
    draw_set_color(primary_color);
    draw_rectangle(box_left + r, box_top, box_right - r, box_bottom, false);
    draw_rectangle(box_left, box_top + r, box_right, box_bottom - r, false);
    draw_circle(box_left + r, box_top + r, r, false);
    draw_circle(box_right - r, box_top + r, r, false);
    draw_circle(box_left + r, box_bottom - r, r, false);
    draw_circle(box_right - r, box_bottom - r, r, false);
    
    // Gradient top
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(box_left + r, box_top, box_right - r, box_top + 80, false);
    draw_rectangle(box_left, box_top + r, box_right, box_top + 80, false);
    draw_circle(box_left + r, box_top + r, r, false);
    draw_circle(box_right - r, box_top + r, r, false);
    
    // Border
    draw_set_color(accent_color);
    draw_set_alpha(box_alpha * 0.8);
    draw_rectangle(box_left + r, box_top, box_right - r, box_top + 2, false);
    draw_set_alpha(box_alpha);
    
    // ----------------------------------------
    // X BUTTON
    // ----------------------------------------
    var x_btn_x = box_x + result_box_width/2 - x_button_size/2 - 15;
    var x_btn_y = box_y - result_box_height/2 + x_button_size/2 + 15;
    
    // X button shadow
    draw_set_alpha(0.3 * box_alpha);
    draw_set_color(c_black);
    draw_circle(x_btn_x + 2, x_btn_y + 2, x_button_size/2, false);
    draw_set_alpha(box_alpha);
    
    // Check if hovering
    var x_hitbox = x_button_size + 15;
    var x_hovering = point_in_rectangle(mouse_x, mouse_y, 
                                         x_btn_x - x_hitbox/2, x_btn_y - x_hitbox/2,
                                         x_btn_x + x_hitbox/2, x_btn_y + x_hitbox/2);
    
    // X button circle
    draw_set_color(x_hovering ? x_button_hover_color : x_button_color);
    draw_circle(x_btn_x, x_btn_y, x_button_size/2, false);
    
    // X button border
    draw_set_color(c_white);
    draw_circle(x_btn_x, x_btn_y, x_button_size/2, true);
    
    // X symbol
    var x_offset = x_button_size/4;
    draw_line_width(x_btn_x - x_offset, x_btn_y - x_offset, 
                    x_btn_x + x_offset, x_btn_y + x_offset, 3);
    draw_line_width(x_btn_x + x_offset, x_btn_y - x_offset, 
                    x_btn_x - x_offset, x_btn_y + x_offset, 3);
    
    // ----------------------------------------
    // RESULTS CONTENT
    // ----------------------------------------
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Title
    draw_set_color(text_primary);
    draw_text_transformed(box_x, box_y - 150, "EVALUATION COMPLETE!", 1.8, 1.8, 0);
    
    // Calculate percentage and grade
    var percentage = (score / total_questions) * 100;
    var grade_text = "";
    var grade_color = c_white;
    
    if (percentage >= 90) {
        grade_text = "EXCELLENT!";
        grade_color = success_color;
    } else if (percentage >= 75) {
        grade_text = "GREAT JOB!";
        grade_color = make_color_rgb(100, 200, 100);
    } else if (percentage >= 60) {
        grade_text = "GOOD EFFORT!";
        grade_color = warning_color;
    } else {
        grade_text = "KEEP PRACTICING!";
        grade_color = error_color;
    }
    
    // Grade text
    draw_set_color(grade_color);
    draw_text_transformed(box_x, box_y - 80, grade_text, 1.3, 1.3, 0);
    
    // "Your Score:" label
    draw_set_color(text_primary);
    draw_text_transformed(box_x, box_y - 20, "Your Score:", 1.2, 1.2, 0);
    
    // Score numbers (large)
    draw_text_transformed(box_x, box_y + 20, string(score) + " / " + string(total_questions), 2.5, 2.5, 0);
    
    // Percentage
    draw_text_transformed(box_x, box_y + 60, string(floor(percentage)) + "%", 1.5, 1.5, 0);
    
    // ----------------------------------------
    // RESTART BUTTON
    // ----------------------------------------
    var restart_btn_y = box_y + 120;
    var restart_btn_w = 250;
    var restart_btn_h = 60;
    
    var restart_left = box_x - restart_btn_w/2;
    var restart_top = restart_btn_y - restart_btn_h/2;
    var restart_right = box_x + restart_btn_w/2;
    var restart_bottom = restart_btn_y + restart_btn_h/2;
    
    // Check if hovering
    var restart_hover = point_in_rectangle(mouse_x, mouse_y, restart_left - 10, restart_top - 5, restart_right + 10, restart_bottom + 5);
    
    // Shadow
    draw_set_alpha(0.3 * box_alpha);
    draw_set_color(c_black);
    draw_roundrect(restart_left + 4, restart_top + 4, restart_right + 4, restart_bottom + 4, false);
    
    // Button
    draw_set_alpha(box_alpha);
    draw_set_color(restart_hover ? accent_hover_color : accent_color);
    draw_roundrect(restart_left, restart_top, restart_right, restart_bottom, false);
    
    // Button border
    draw_set_color(c_white);
    draw_set_alpha(box_alpha * 0.5);
    draw_roundrect(restart_left, restart_top, restart_right, restart_bottom, true);
    draw_set_alpha(box_alpha);
    
    // Button text
    draw_set_color(text_primary);
    draw_text_transformed(box_x, restart_btn_y, "RESTART EVALUATION", 1.1, 1.1, 0);
    
    // Additional info at bottom
    draw_set_color(text_muted);
    draw_set_alpha(box_alpha * 0.7);
    draw_text(box_x, box_y + 190, "Press R to restart or click X to close");
    
    draw_set_alpha(1);
}

// ============================================
// RESET DRAW SETTINGS
// ============================================
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
