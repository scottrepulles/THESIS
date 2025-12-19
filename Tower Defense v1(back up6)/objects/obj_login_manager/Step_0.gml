// Handle TAB navigation
if (keyboard_check_pressed(vk_tab)) {
    if (current_mode == "login") {
        switch(active_field) {
            case "username": active_field = "password"; break;
            case "password": active_field = "main_button"; break;
            case "main_button": active_field = "switch_button"; break;
            case "switch_button": active_field = "username"; break;
            default: active_field = "username"; break;
        }
    } else {
        switch(active_field) {
            case "username": active_field = "password"; break;
            case "password": active_field = "confirm"; break;
            case "confirm": active_field = "main_button"; break;
            case "main_button": active_field = "switch_button"; break;
            case "switch_button": active_field = "username"; break;
            default: active_field = "username"; break;
        }
    }
}

// Handle ENTER key
if (keyboard_check_pressed(vk_enter)) {
    if (active_field == "main_button") {
        // Execute main button action
        if (current_mode == "login") {
            event_user(0); // Login
        } else {
            event_user(1); // Register
        }
    } else if (active_field == "switch_button") {
        // Execute switch button action
        if (current_mode == "login") {
            current_mode = "register";
            confirm_password_input = "";
        } else {
            current_mode = "login";
        }
        message = "";
        active_field = "username";
    }
}

// Handle text input for active text fields only
if (active_field == "username" || active_field == "password" || active_field == "confirm") {
    if (keyboard_check_pressed(vk_anykey)) {
        var key = keyboard_lastkey;
        
        // Handle backspace
        if (keyboard_check_pressed(vk_backspace)) {
            if (active_field == "username" && string_length(username_input) > 0) {
                username_input = string_delete(username_input, string_length(username_input), 1);
            } else if (active_field == "password" && string_length(password_input) > 0) {
                password_input = string_delete(password_input, string_length(password_input), 1);
            } else if (active_field == "confirm" && string_length(confirm_password_input) > 0) {
                confirm_password_input = string_delete(confirm_password_input, string_length(confirm_password_input), 1);
            }
        }
        // Handle regular characters
        else if (key >= 32 && key <= 126 && key != ord("	") && key != vk_enter) {
            var char = chr(key);
            if (keyboard_check(vk_shift)) {
                char = string_upper(char);
            } else {
                char = string_lower(char);
            }
            
            if (active_field == "username" && string_length(username_input) < 20) {
                username_input += char;
            } else if (active_field == "password" && string_length(password_input) < 20) {
                password_input += char;
            } else if (active_field == "confirm" && string_length(confirm_password_input) < 20) {
                confirm_password_input += char;
            }
        }
    }
}

// Handle mouse clicks
if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;

    // Username textbox
    var username_y = center_y - 80;
    if (mx >= center_x - textbox_width/2 && mx <= center_x + textbox_width/2 &&
        my >= username_y && my <= username_y + textbox_height) {
        active_field = "username";
    }

    // Password textbox
    var password_y = center_y - 30;
    if (mx >= center_x - textbox_width/2 && mx <= center_x + textbox_width/2 &&
        my >= password_y && my <= password_y + textbox_height) {
        active_field = "password";
    }

    // Confirm password textbox (only in register mode)
    if (current_mode == "register") {
        var confirm_y = center_y + 20;
        if (mx >= center_x - textbox_width/2 && mx <= center_x + textbox_width/2 &&
            my >= confirm_y && my <= confirm_y + textbox_height) {
            active_field = "confirm";
        }
    }

    // Login/Register button
    var main_button_y = current_mode == "login" ? center_y + 30 : center_y + 70;
    if (mx >= center_x - button_width/2 && mx <= center_x + button_width/2 &&
        my >= main_button_y && my <= main_button_y + button_height) {
        active_field = "main_button";
        // Also execute the action immediately on click
        if (current_mode == "login") {
            event_user(0); // Login
        } else {
            event_user(1); // Register
        }
    }

    // Switch mode button
    var switch_button_y = current_mode == "login" ? center_y + 80 : center_y + 120;
    if (mx >= center_x - button_width/2 && mx <= center_x + button_width/2 &&
        my >= switch_button_y && my <= switch_button_y + button_height) {
        active_field = "switch_button";
        // Also execute the action immediately on click
        if (current_mode == "login") {
            current_mode = "register";
            confirm_password_input = "";
        } else {
            current_mode = "login";
        }
        message = "";
        active_field = "username";
    }
}

// Clear message after 3 seconds
if (message != "" && alarm[0] == -1) {
    alarm[0] = 180; // 3 seconds at 60 FPS
}
