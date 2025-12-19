/// obj_quiz_manager - Step Event
// FIXED: Can select any choice except previously wrong answer

// Block ALL quiz logic if waves have not started yet (safe check for variable)
if (!variable_global_exists("waves_have_started") || !global.waves_have_started) {
    exit;
}

// Prevent ALL quiz popups and timer countdowns unless a wave is running
if (!wave_is_running()) {
    // Pause the quiz system entirely until the player presses Start
    exit;
}


// Debug: Show countdown every 5 seconds
if (quiz_next_time % (room_speed * 5) == 0) {
    show_debug_message("Quiz countdown: " + string(ceil(quiz_next_time/room_speed)) + " seconds");
}

// Only run quiz logic if quiz is active
if (global.quiz_active) {
    // Continuously pause enemies (handles enemies spawned during the quiz)
    with (obj_enemy_parent) {
        if (!variable_instance_exists(id, "saved_path_speed")) saved_path_speed = path_speed;
        if (!variable_instance_exists(id, "saved_image_speed")) saved_image_speed = image_speed;
        path_speed = 0;
        image_speed = 0;
        hspeed = 0;
        vspeed = 0;
    }
    
    // Quiz timer countdown
    global.quiz_timer -= 1;
    if (global.quiz_timer <= 0 && !global.quiz_answered) {
        answer_quiz(-1); // -1 means time's up
    }
    
    // Fade animation
    quiz_alpha = lerp(quiz_alpha, quiz_target_alpha, 0.1);
    
    if (!global.quiz_answered) {
        // Handle extreme difficulty (typing) vs multiple choice
        if (global.quiz_difficulty == "extreme") {
            // ===== TYPING INPUT FOR EXTREME QUIZZES =====
            if (keyboard_check_pressed(vk_backspace)) {
                // Backspace - remove last character
                if (string_length(global.quiz_typing_answer) > 0) {
                    global.quiz_typing_answer = string_copy(global.quiz_typing_answer, 1, string_length(global.quiz_typing_answer) - 1);
                }
            } else if (keyboard_check_pressed(vk_enter)) {
                // Enter - submit answer
                answer_quiz(0); // Use 0 as placeholder for typing submission
            } else {
                // Check for printable character presses
                for (var i = 32; i <= 126; i++) {
                    if (keyboard_check_pressed(i)) {
                        // Limit answer length to prevent extremely long answers
                        if (string_length(global.quiz_typing_answer) < 200) {
                            global.quiz_typing_answer += chr(i);
                        }
                        break; // Only add one character per frame
                    }
                }
            }
        } else {
            // ===== MULTIPLE CHOICE INPUT (FIXED) =====
            
            // KEYBOARD INPUT - Check if option is NOT the wrong answer
            if (keyboard_check_pressed(ord("1"))) {
                if (global.quiz_selected_index != 0) {  // Only if not previously wrong
                    answer_quiz(0);
                }
            }
            if (keyboard_check_pressed(ord("2"))) {
                if (global.quiz_selected_index != 1) {  // Only if not previously wrong
                    answer_quiz(1);
                }
            }
            if (keyboard_check_pressed(ord("3"))) {
                if (global.quiz_selected_index != 2) {  // Only if not previously wrong
                    answer_quiz(2);
                }
            }
            if (keyboard_check_pressed(ord("4"))) {
                if (global.quiz_selected_index != 3) {  // Only if not previously wrong
                    answer_quiz(3);
                }
            }
            
            // MOUSE INPUT - With proper boundary detection
            if (mouse_check_button_pressed(mb_left)) {
                var mx = device_mouse_x_to_gui(0);
                var my = device_mouse_y_to_gui(0);
                
                var gui_width = display_get_gui_width();
                var gui_height = display_get_gui_height();
                
                // Match the Draw GUI dimensions
                var box_w = 760;
                var box_h = 640;
                var box_x = (gui_width - box_w) / 2;
                var box_y = (gui_height - box_h) / 2;
                
                // Question section
                var question_y = box_y + 65;
                var question_h = 140;
                
                // Content area (where options start)
                var content_y = question_y + question_h + 25;
                
                // Option dimensions (match Draw GUI)
                var option_spacing = 82;
                var option_height = 68;
                var option_x = box_x + 35;
                var option_w = box_w - 70;
                
                // Check each option
                for (var i = 0; i < array_length(global.quiz_options); i++) {
                    var option_y = content_y + (i * option_spacing);
                    
                    // Check if mouse is within option bounds
                    if (mx > option_x && mx < option_x + option_w 
                        && my > option_y && my < option_y + option_height) {
                        
                        // ONLY allow click if this is NOT the previously wrong answer
                        if (global.quiz_selected_index != i) {
                            answer_quiz(i);
                            break;  // Exit loop after clicking
                        } else {
                            // Optional: Show feedback that this option was already tried
                            show_debug_message("Cannot select option " + string(i + 1) + " - already tried and was wrong!");
                        }
                    }
                }
            }
        }
    }
    exit;
}

// Limit to room_quiz_limit quizzes per room
if (!global.quiz_active && !quiz_warning_active && room_quiz_count >= room_quiz_limit) {
    quiz_next_time = -1; // Prevent more quizzes
    exit;
}

// If a warning is active, count down
if (quiz_warning_active) {
    quiz_warning_timer -= 1;
    if (quiz_warning_timer <= 0) {
        quiz_warning_active = false;
        show_debug_message("Starting quiz after warning!");
        with (id) start_quiz(quiz_warning_difficulty);
    }
    exit;
}

// If not in a quiz or warning, count down to next quiz
quiz_next_time -= 1;
if (quiz_next_time <= 0) {
    // Set quiz difficulty based on rank/room
    switch (room) {
        case rm_rank_bronze:
            quiz_warning_difficulty = "easy";
            break;
		case rm_rank_bronze_2:
            quiz_warning_difficulty = "easy";
            break;
			
			
        case rm_rank_silver:
            quiz_warning_difficulty = "medium";
            break;
		case rm_rank_platinum:
            quiz_warning_difficulty = "medium";
            break;	
			
        case rm_rank_gold:
            quiz_warning_difficulty = "hard";
            break;
		case rm_rank_gold_2:
            quiz_warning_difficulty = "hard";
            break;	
			
        case rm_rank_platinum111:
            quiz_warning_difficulty = "extreme";
            break;
		case rm_rank_platinum_2:
            quiz_warning_difficulty = "extreme";
            break;
			
        default:
            quiz_warning_difficulty = "easy";
            break;
    }
    
    quiz_warning_active = true;
    quiz_warning_timer = quiz_warning_time;
    show_debug_message("Quiz warning started! Quiz will begin in " + string(quiz_warning_time/room_speed) + " seconds");
    
    // Set next quiz time for after this one is done
    quiz_next_time = irandom_range(room_speed * 30, room_speed * 60); // 30-60 seconds until next quiz
}
