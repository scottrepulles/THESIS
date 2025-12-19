/// Step Event of obj_evaluation

// ============================================
// SMOOTH ANIMATIONS AND TRANSITIONS
// ============================================

// Smooth alpha transition for box fade-in/fade-out
box_alpha = lerp(box_alpha, box_alpha_target, 0.1);

// Smooth scale transition for UI elements
ui_scale_current = lerp(ui_scale_current, ui_scale_target, ui_animation_speed);

// ============================================
// INITIAL SPRITE HOVER EFFECTS
// ============================================
if (!show_result && current_question == 0 && !answered) {
    // Check if mouse is hovering over the initial sprite
    if (position_meeting(mouse_x, mouse_y, id)) {
        // Fade in shadow on hover
        shadow_alpha = lerp(shadow_alpha, 0.6, 0.2);
        shadow_size = lerp(shadow_size, sprite_get_width(spr_evaluation)/2 + 25, 0.2);
    } else {
        // Fade out shadow when not hovering
        shadow_alpha = lerp(shadow_alpha, 0.0, 0.2);
        shadow_size = lerp(shadow_size, sprite_get_width(spr_evaluation)/2, 0.2);
    }
}

// ============================================
// AUTO-FADE IN BOX WHEN STARTING EVALUATION
// ============================================
if (show_result && !evaluation_complete) {
    // Ensure box fades in smoothly
    if (box_alpha_target < 1.0) {
        box_alpha_target = 1.0;
    }
}

// ============================================
// KEYBOARD SHORTCUTS (A, B, C, D for answers)
// ============================================
if (show_result && !evaluation_complete && current_question < total_questions) {
    // Allow keyboard input for answer selection (A, B, C, D keys)
    if (!answered) {
        if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("1"))) {
            selected_answer = 0;
            answered = true;
            if (selected_answer == questions[current_question][5]) {
                score++;
            }
        }
        else if (keyboard_check_pressed(ord("B")) || keyboard_check_pressed(ord("2"))) {
            selected_answer = 1;
            answered = true;
            if (selected_answer == questions[current_question][5]) {
                score++;
            }
        }
        else if (keyboard_check_pressed(ord("C")) || keyboard_check_pressed(ord("3"))) {
            selected_answer = 2;
            answered = true;
            if (selected_answer == questions[current_question][5]) {
                score++;
            }
        }
        else if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("4"))) {
            selected_answer = 3;
            answered = true;
            if (selected_answer == questions[current_question][5]) {
                score++;
            }
        }
    }
    // Allow Enter/Space to proceed to next question
    else if (answered) {
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            current_question++;
            answered = false;
            selected_answer = -1;
            
            if (current_question >= total_questions) {
                evaluation_complete = true;
            }
        }
    }
}

// ============================================
// RESTART SHORTCUT (R KEY) ON RESULTS SCREEN
// ============================================
if (evaluation_complete) {
    if (keyboard_check_pressed(ord("R"))) {
        // Reset and restart evaluation
        current_question = 0;
        score = 0;
        answered = false;
        selected_answer = -1;
        show_result = true;
        evaluation_complete = false;
        box_alpha_target = 1.0;
        
        // Re-shuffle questions
        for (var i = array_length(questions) - 1; i > 0; i--) {
            var j = irandom(i);
            var temp = questions[i];
            questions[i] = questions[j];
            questions[j] = temp;
        }
    }
}

// ============================================
// CLAMP VALUES TO PREVENT ERRORS
// ============================================
box_alpha = clamp(box_alpha, 0, 1);
shadow_alpha = clamp(shadow_alpha, 0, 1);
ui_scale_current = clamp(ui_scale_current, 0.5, 1.5);
