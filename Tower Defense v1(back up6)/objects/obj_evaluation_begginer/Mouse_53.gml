/// Global Left Pressed Event of obj_evaluation

// Debug - show where we're clicking
show_debug_message("Click at: " + string(mouse_x) + ", " + string(mouse_y));
show_debug_message("show_result: " + string(show_result));
show_debug_message("answered: " + string(answered));
show_debug_message("evaluation_complete: " + string(evaluation_complete));

// ============================================
// INITIAL SPRITE CLICK - START EVALUATION
// ============================================
if (!show_result && current_question == 0 && !answered) {
    // Click on sprite to start evaluation
    if (position_meeting(mouse_x, mouse_y, id)) {
        show_result = true;
        box_alpha_target = 1.0;
        
        show_debug_message("Starting evaluation!");
    }
    exit;
}

// ============================================
// QUESTION STATE - ANSWER BUTTON CLICKS
// ============================================
if (show_result && current_question < total_questions && !evaluation_complete) {
    
    show_debug_message("In question state");
    
    // ----------------------------------------
    // X BUTTON (CLOSE) CLICK - CHECK FIRST
    // ----------------------------------------
    var x_btn_x = box_x + box_width/2 - x_button_size/2 - 15;
    var x_btn_y = box_y - box_height/2 + x_button_size/2 + 15;
    var x_hitbox = x_button_size + 15;
    
    var x_left = x_btn_x - x_hitbox/2;
    var x_top = x_btn_y - x_hitbox/2;
    var x_right = x_btn_x + x_hitbox/2;
    var x_bottom = x_btn_y + x_hitbox/2;
    
    show_debug_message("X button area: " + string(x_left) + ", " + string(x_top) + " to " + string(x_right) + ", " + string(x_bottom));
    
    if (point_in_rectangle(mouse_x, mouse_y, x_left, x_top, x_right, x_bottom)) {
        show_debug_message("X BUTTON CLICKED!");
        
        // Reset everything and close
        current_question = 0;
        score = 0;
        answered = false;
        selected_answer = -1;
        show_result = false;
        evaluation_complete = false;
        box_alpha_target = 0.0;
        shadow_alpha = 0.0;
        
        exit; // Stop checking other clicks
    }
    
    // ----------------------------------------
    // NEXT BUTTON CLICK (Check if answered)
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
        
        show_debug_message("Next button area: " + string(next_left) + ", " + string(next_top) + " to " + string(next_right) + ", " + string(next_bottom));
        
        // Check if clicking Next button
        if (point_in_rectangle(mouse_x, mouse_y, next_left - 10, next_top - 5, next_right + 10, next_bottom + 5)) {
            show_debug_message("NEXT BUTTON CLICKED!");
            
            // Move to next question
            current_question++;
            answered = false;
            selected_answer = -1;
            
            // Check if evaluation is complete
            if (current_question >= total_questions) {
                evaluation_complete = true;
            }
            
            exit;
        }
    }
    
    // ----------------------------------------
    // ANSWER BUTTON CLICKS (Only if not answered yet)
    // ----------------------------------------
    if (!answered) {
        var q = questions[current_question];
        var question_y = box_y - box_height/2 + 45 + 50;
        var start_y = question_y + 100;
        
        show_debug_message("Checking answer buttons...");
        
        for (var i = 0; i < 4; i++) {
            var ay = start_y + i * (answer_button_height + answer_button_spacing);
            var ax = box_x;
            
            var btn_left = ax - answer_button_width/2;
            var btn_top = ay - answer_button_height/2;
            var btn_right = ax + answer_button_width/2;
            var btn_bottom = ay + answer_button_height/2;
            
            show_debug_message("Answer " + string(i) + " area: " + string(btn_left) + ", " + string(btn_top) + " to " + string(btn_right) + ", " + string(btn_bottom));
            
            // Check if clicking on this answer button
            if (point_in_rectangle(mouse_x, mouse_y, btn_left - 10, btn_top - 5, btn_right + 10, btn_bottom + 5)) {
                show_debug_message("ANSWER " + string(i) + " CLICKED!");
                
                selected_answer = i;
                answered = true;
                
                // Check if answer is correct
                if (selected_answer == q[5]) {
                    score++;
                }
                
                exit; // Stop checking other buttons
            }
        }
    }
}

// ============================================
// RESULTS STATE - BUTTONS CLICKS
// ============================================
if (evaluation_complete) {
    
    show_debug_message("In results state");
    
    var result_box_width = 700;
    var result_box_height = 500;
    
    // ----------------------------------------
    // X BUTTON (CLOSE) CLICK
    // ----------------------------------------
    var x_btn_x = box_x + result_box_width/2 - x_button_size/2 - 15;
    var x_btn_y = box_y - result_box_height/2 + x_button_size/2 + 15;
    var x_hitbox = x_button_size + 15;
    
    var x_left = x_btn_x - x_hitbox/2;
    var x_top = x_btn_y - x_hitbox/2;
    var x_right = x_btn_x + x_hitbox/2;
    var x_bottom = x_btn_y + x_hitbox/2;
    
    if (point_in_rectangle(mouse_x, mouse_y, x_left, x_top, x_right, x_bottom)) {
        show_debug_message("X BUTTON CLICKED (results)!");
        
        // Reset everything and close
        current_question = 0;
        score = 0;
        answered = false;
        selected_answer = -1;
        show_result = false;
        evaluation_complete = false;
        box_alpha_target = 0.0;
        shadow_alpha = 0.0;
        
        exit;
    }
    
    // ----------------------------------------
    // RESTART BUTTON CLICK
    // ----------------------------------------
    var restart_btn_y = box_y + 120;
    var restart_btn_w = 250;
    var restart_btn_h = 60;
    
    var restart_left = box_x - restart_btn_w/2;
    var restart_top = restart_btn_y - restart_btn_h/2;
    var restart_right = box_x + restart_btn_w/2;
    var restart_bottom = restart_btn_y + restart_btn_h/2;
    
    // Check if clicking Restart button
    if (point_in_rectangle(mouse_x, mouse_y, restart_left - 10, restart_top - 5, restart_right + 10, restart_bottom + 5)) {
        show_debug_message("RESTART BUTTON CLICKED!");
        
        // Reset and restart evaluation
        current_question = 0;
        score = 0;
        answered = false;
        selected_answer = -1;
        show_result = true; // Keep it open but restart
        evaluation_complete = false;
        box_alpha_target = 1.0;
        
        // Re-shuffle questions
        for (var i = array_length(questions) - 1; i > 0; i--) {
            var j = irandom(i);
            var temp = questions[i];
            questions[i] = questions[j];
            questions[j] = temp;
        }
        
        exit;
    }
}
