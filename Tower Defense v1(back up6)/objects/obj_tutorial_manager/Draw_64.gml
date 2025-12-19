/// obj_tutorial_manager - Draw GUI Event
// Draw GUI End: ensure tutorial dialogue is above all UI and fully visible

if (!global.tutorial_active) exit;

if (global.show_tutorial) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var box_w = global.tutorial_box_w;
    var box_h = global.tutorial_box_h;
    var box_x = global.tutorial_box_x;
    var box_y = global.tutorial_box_y;
    var text_w = box_w - 70;

    // Dim background
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gui_width, gui_height, false);
    draw_set_alpha(1);

    // Panel
    draw_set_alpha(0.95);
    draw_set_color(c_white);
    draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);
    draw_set_color(c_black);
    draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

    var step_count = array_length(global.tutorial_steps);
    if (step_count <= 0 || global.tutorial_index >= step_count) {
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_font(-1);
        exit;
    }
    var data = global.tutorial_steps[global.tutorial_index];

    // Title & question (wrapped)
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_font(ft_button);
    draw_text(box_x + box_w/2, box_y + 20, data.title);
    
    // Progress indicator
    draw_set_font(ft_popup);
    draw_set_color(c_dkgray);
    draw_text(box_x + box_w/2, box_y + 42, "Question " + string(global.tutorial_index + 1) + " of " + string(step_count));
    
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_set_font(ft_popup);
    draw_text_ext(box_x + 50, box_y + 70, data.question, 20, text_w);

    // Options styled like quiz UI - moved to top
    var option_y = global.tutorial_option_y;
    var option_x = global.tutorial_option_x;
    var option_w = global.tutorial_option_w;
    var option_h = global.tutorial_option_h;
    for (var i = 0; i < 4; i++) {
        var bg = c_white;

        if (global.tutorial_waiting_continue) {
            if (i == data.correct) bg = c_lime;
            else if (i == global.selected_choice) bg = c_red;
        } else if (global.selected_choice == i) {
            bg = make_color_rgb(225,240,255);
        }
        draw_set_alpha(0.9);
        draw_set_color(bg);
        draw_roundrect(option_x, option_y + i * 56, option_x + option_w, option_y + i * 56 + option_h, false);
        draw_set_color(c_black);
        draw_roundrect(option_x, option_y + i * 56, option_x + option_w, option_y + i * 56 + option_h, true);
        draw_set_font(ft_popup);
        draw_text_ext(option_x + 16, option_y + i * 56 + 10, data.choices[i], 18, option_w - 32);
    }

    // Footer: feedback or hint + Next button
    draw_set_halign(fa_center);
    if (global.tutorial_waiting_continue) {
        draw_set_color(c_white);
        draw_set_font(ft_popup);
        // Feedback area background and text
        var fb_x = box_x + box_w/2;
        var fb_y = global.feedback_y;
        var fb_w = text_w;
        var fb_h = string_height_ext(global.tutorial_feedback, 24, text_w) + 18;
        // Light background for feedback area
        draw_set_alpha(0.35);
        draw_set_color(c_white);
        draw_roundrect(fb_x - fb_w/2 - 10, fb_y - 10, fb_x + fb_w/2 + 10, fb_y + fb_h, false);
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_set_font(ft_popup);
        draw_text_ext(fb_x, fb_y, global.tutorial_feedback, 24, text_w);
        
        // Next button - centered at bottom
        var next_w = global.next_btn_w;
        var next_h = global.next_btn_h;
        var next_x = global.next_btn_x;
        var next_y = global.next_btn_y;
        draw_set_alpha(0.95);
        draw_set_color(c_blue);
        draw_roundrect(next_x, next_y, next_x + next_w, next_y + next_h, false);
        draw_set_color(c_white);
        draw_roundrect(next_x, next_y, next_x + next_w, next_y + next_h, true);
        draw_set_font(ft_button);
        draw_set_color(c_white);
        var label = global.tutorial_complete ? "CLOSE" : (variable_global_exists("next_btn_label") ? global.next_btn_label : "NEXT");
        draw_text(next_x + next_w/2, next_y + 10, label);
    } else {
        draw_set_color(c_dkgray);
        draw_set_font(ft_popup);
        draw_text(box_x + box_w/2, box_y + box_h - 34, "Click an answer to select");
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_font(-1);
}
