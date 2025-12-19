/// obj_tutorial_manager - Step Event
// Handle tutorial Q&A interaction (multiple-choice)

// Manage alpha: visible only when tutorial is shown
text_alpha = (global.show_tutorial ? 1 : 0);

// Update click cooldown timer
if (click_cooldown > 0) {
    click_cooldown -= 1;
}

// Keep flags consistent with visibility; tutorial shows only when triggered
global.tutorial_active = global.show_tutorial;

// Hotkey: Alt+T toggles tutorial visibility
if (keyboard_check(vk_alt) && keyboard_check_pressed(ord("T"))) {
    global.show_tutorial = !global.show_tutorial;
    global.tutorial_active = global.show_tutorial;
    if (global.show_tutorial) {
        // Guard against out-of-range tutorial index
        var step_count = array_length(global.tutorial_steps);
        if (step_count <= 0 || global.tutorial_index >= step_count) {
            // If no steps or index past end, just stop processing
            exit;
        }
        global.tutorial_index = 0;
        global.selected_choice = -1;
        global.tutorial_waiting_continue = false;
        global.tutorial_feedback = "";
        global.tutorial_complete = false;
        global.next_btn_label = "NEXT";
    }
}

if (global.show_tutorial) {
    // Canonical layout metrics (shared with Draw events)
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    global.tutorial_box_w = 840; // Wider box for long text
    global.tutorial_box_h = 560; // Taller box for feedback area
    global.tutorial_box_x = (gui_w - global.tutorial_box_w) / 2;
    global.tutorial_box_y = (gui_h - global.tutorial_box_h) / 2;
    var box_x = global.tutorial_box_x;
    var box_y = global.tutorial_box_y;
    var box_w = global.tutorial_box_w;
    var box_h = global.tutorial_box_h;

    // Options layout (4 choices) - moved to the top
    global.tutorial_option_y = box_y + 100;
    global.tutorial_option_x = box_x + 50;
    global.tutorial_option_w = box_w - 100;
    global.tutorial_option_h = 40; // slightly taller for wrapped text

    // Feedback area position: below options with extra spacing
    global.feedback_y = global.tutorial_option_y + 4 * 56 + 30;

    // Adaptive Next button size and position based on label and feedback
    draw_set_font(ft_popup);
    var fb_text_w = box_w - 70;
    var fb_h = string_height_ext(global.tutorial_feedback, 24, fb_text_w) + 18;
    draw_set_font(ft_button);
    var label = global.tutorial_complete ? "CLOSE" : (variable_global_exists("next_btn_label") ? global.next_btn_label : "NEXT");
    var label_w = string_width(label);
    var label_h = string_height(label);
    global.next_btn_w = label_w + 32; // padding left/right
    global.next_btn_h = max(36, label_h + 12); // padding top/bottom
    global.next_btn_x = box_x + (box_w - global.next_btn_w) / 2; // Centered
    global.next_btn_y = min(box_y + box_h - global.next_btn_h - 25, global.feedback_y + fb_h + 16); // Below feedback or bottom

    if (!global.tutorial_waiting_continue) {
        // Mouse selection only - single click evaluates immediately (with stronger cooldown)
        if (mouse_check_button_pressed(mb_left) && click_cooldown <= 0) {
            click_cooldown = 15; // prevent rapid clicking issues
            var mx = device_mouse_x_to_gui(0);
            var my = device_mouse_y_to_gui(0);
            // Option selection hitboxes
            var option_y = global.tutorial_option_y;
            var option_x = global.tutorial_option_x;
            var option_w = global.tutorial_option_w;
            var option_h = global.tutorial_option_h;
            for (var i = 0; i < 4; i++) {
                var oy = option_y + i * 56;
                var inside = point_in_rectangle(mx, my, option_x, oy, option_x + option_w, oy + option_h);
                if (inside) {
                    global.selected_choice = i;
                    var data = global.tutorial_steps[global.tutorial_index];
                    var correct_index = variable_struct_exists(data, "correct") ? data.correct : -1;
                    var is_correct = (global.selected_choice == correct_index);
                    var has_choices = variable_struct_exists(data, "choices");
                    var correct_text = (has_choices && correct_index >= 0 && is_array(data.choices) && correct_index < array_length(data.choices)) ? data.choices[correct_index] : "";
                    var correct_label = (correct_index >= 0 ? string(chr(ord("A") + correct_index)) : "") + (correct_text != "" ? ": " + correct_text : "");
                    var expl = variable_struct_exists(data, "explanation") ? data.explanation : "";
                    global.tutorial_feedback = (is_correct ? "✓ Correct! " : "✗ Not quite. ") + expl + (correct_label != "" ? "\n\nCorrect answer: " + correct_label : "");
                    global.tutorial_waiting_continue = true; // show feedback; wait for Next click
                    break;
                }
            }
        }
    } else {
        // Waiting for user to click Next button to proceed
        var mx2 = device_mouse_x_to_gui(0);
        var my2 = device_mouse_y_to_gui(0);
        if (mouse_check_button_pressed(mb_left) && mx2 >= global.next_btn_x && mx2 <= global.next_btn_x + global.next_btn_w && my2 >= global.next_btn_y && my2 <= global.next_btn_y + global.next_btn_h) {
            var step_count = array_length(global.tutorial_steps);
            // If already at completion, CLOSE
            if (global.tutorial_complete) {
                global.show_tutorial = false;
                global.tutorial_active = false;
                global.tutorial_paused = false;
                game_paused = false;
                if (script_exists(start_next_wave)) {
                    start_next_wave();
                }
                exit; // stop further processing
            }

            // Advance to next question
            global.tutorial_index += 1;
            global.selected_choice = -1;
            global.tutorial_feedback = "";
            global.tutorial_waiting_continue = false;

            // If we reached the end, show completion message and wait for CLOSE
            if (global.tutorial_index >= step_count) {
                global.tutorial_index = max(0, step_count - 1); // keep safe for draw
                global.tutorial_complete = true;
                global.tutorial_feedback = "🎉 Congratulations! You've completed the tutorial!\n\nNow you understand how SQL injection works and how to defend against it.\n\nEnjoy the game and have fun protecting your database!";
                global.tutorial_waiting_continue = true;
                global.next_btn_label = "CLOSE";
            }
        }
    }
}
