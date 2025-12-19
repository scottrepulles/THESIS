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
    if (current_mode == "login") {
        current_mode = "register";
        confirm_password_input = "";
    } else {
        current_mode = "login";
    }
    message = "";
    active_field = "username";
}
