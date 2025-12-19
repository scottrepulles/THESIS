/// obj_tutorial_manager - Draw Event

if (!global.tutorial_active) exit;

// When in Q&A tutorial mode, draw interactive multiple-choice UI
if (global.show_tutorial) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var box_w = global.tutorial_box_w;
    var box_h = global.tutorial_box_h;
    var box_x = global.tutorial_box_x;
    var box_y = global.tutorial_box_y;
    var text_w = box_w - 80;

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

    // Title & question (with smaller font)
    var step_count = array_length(global.tutorial_steps);
    if (step_count <= 0 || global.tutorial_index >= step_count) {
        // Nothing to show; bail out safely to avoid errors
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_font(-1);
        exit;
    }
    var data = global.tutorial_steps[global.tutorial_index];
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_font(ft_popup); // Smaller font for title
    draw_text(box_x + box_w/2, box_y + 8, data.title);
    
    // Progress indicator
    draw_set_font(ft_popup);
    draw_set_color(c_dkgray);
    draw_text(box_x + box_w/2, box_y + 30, "Question " + string(global.tutorial_index + 1) + " of " + string(step_count));
    
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_set_font(ft_popup);
    draw_text_ext(box_x + 40, box_y + 60, data.question, 22, text_w);

    // Options - moved to top area
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

    // Feedback or instructions + Next button
    draw_set_halign(fa_center);
    if (global.tutorial_waiting_continue) {
        draw_set_color(c_black);
        draw_set_font(ft_popup);
        // Feedback area background and text
        var fb_x = box_x + box_w/2;
        var fb_y = global.feedback_y;
        var fb_w = text_w;
        var fb_h = string_height_ext(global.tutorial_feedback, 24, text_w) + 18;
        // Light background for feedback area (no dark overlay)
        draw_set_alpha(0.35);
        draw_set_color(c_white);
        draw_roundrect(fb_x - fb_w/2 - 10, fb_y - 10, fb_x + fb_w/2 + 10, fb_y + fb_h, false);
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_text_ext(fb_x, fb_y, global.tutorial_feedback, 24, text_w);

        // Next button (click to proceed) - centered at bottom
        var next_w = global.next_btn_w;
        var next_h = global.next_btn_h;
        var next_x = global.next_btn_x;
        var next_y = global.next_btn_y;
        draw_set_alpha(0.95);
        draw_set_color(c_blue);
        draw_roundrect(next_x, next_y, next_x + next_w, next_y + next_h, false);
        draw_set_color(c_black);
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

    // Reset draw state
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_font(-1);
    exit;
}

// Draw semi-transparent overlay
draw_set_alpha(text_alpha * 0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

draw_set_alpha(1);

// Tutorial popup box settings
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();
var box_w = 700; // Wider box for better readability
var font_size = 20; // Slightly smaller for better fit
var line_sep = 28; // Better line spacing
var prompt_size = 16;
var padding_top = 40;
var padding_sides = 40;
var padding_bottom = 40;
var spacing = 20;
var text_w = box_w - 2 * padding_sides;

// Calculate height of main message
draw_set_font(ft_popup);
var text_height = string_height_ext(global.tutorial_message, line_sep, text_w);
var prompt_text = "Click or press SPACE to continue";
var prompt_height = string_height(prompt_text);

// Calculate total box height
var box_h = padding_top + text_height + (global.tutorial_can_continue ? (spacing + prompt_height) : 0) + padding_bottom;

// Ensure the box never goes off the bottom of the screen
var box_x = (gui_width - box_w) / 2;
var box_y = max(gui_height - box_h - 40, 20);

// Draw box background with a subtle shadow for contrast
draw_set_alpha(text_alpha * 0.95);
draw_set_color(make_color_rgb(20, 20, 20));
draw_roundrect(box_x + 6, box_y + 6, box_x + box_w + 6, box_y + box_h + 6, false);
draw_set_alpha(text_alpha * 0.9);
draw_set_color(make_color_rgb(40, 40, 40));
draw_roundrect(box_x + 3, box_y + 3, box_x + box_w + 3, box_y + box_h + 3, false);
draw_set_alpha(text_alpha * 0.95);
draw_set_color(c_white);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, false);

// Draw box border with gradient effect
draw_set_alpha(text_alpha);
draw_set_color(c_black);
draw_roundrect(box_x, box_y, box_x + box_w, box_y + box_h, true);

// Draw tutorial title
draw_set_alpha(text_alpha);
draw_set_color(c_blue);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(ft_button);
draw_text(box_x + box_w/2, box_y + 15, "TUTORIAL GUIDE");

// Draw step counter
if (variable_global_exists("tutorial_step") && variable_instance_exists(id, "tutorial_total_steps")) {
    var step_text = "Step " + string(global.tutorial_step + 1) + " of " + string(tutorial_total_steps);
    draw_set_color(c_dkgray);
    draw_set_font(ft_popup);
    draw_text(box_x + box_w/2, box_y + 35, step_text);
}

// Draw main tutorial text, centered and wrapped
draw_set_alpha(text_alpha);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(ft_popup);
var text_x = box_x + box_w / 2;
var text_y = box_y + padding_top + 45; // Add space for title and step counter
draw_text_ext(text_x, text_y, global.tutorial_message, line_sep, text_w);

// Draw continue prompt below the main message (always show if tutorial is visible)
if (global.tutorial_visible) {
    draw_set_alpha(text_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(ft_button);
    var prompt_y = text_y + text_height + spacing;
    
    // Draw a more visible continue prompt
    draw_set_color(c_black);
    draw_text(text_x, prompt_y, "Click anywhere to continue...");
    
    // Add a pulsing effect
    var pulse_alpha = 0.7 + 0.3 * sin(current_time/300);
    draw_set_alpha(text_alpha * pulse_alpha);
    draw_set_color(c_blue);
    draw_text(text_x, prompt_y, "Click anywhere to continue...");
}

// Reset draw settings
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
