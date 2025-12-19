// Register function
if (username_input == "" || password_input == "" || confirm_password_input == "") {
    message = "Please fill in all fields!";
    message_color = c_red;
    return;
}

if (password_input != confirm_password_input) {
    message = "Passwords do not match!";
    message_color = c_red;
    return;
}

if (string_length(username_input) < 3) {
    message = "Username must be at least 3 characters!";
    message_color = c_red;
    return;
}

if (string_length(password_input) < 4) {
    message = "Password must be at least 4 characters!";
    message_color = c_red;
    return;
}

if (user_exists(username_input)) {
    message = "Username already exists!";
    message_color = c_red;
    return;
}

if (save_user_data(username_input, password_input)) {
    message = "Account created successfully!";
    message_color = c_green;
    current_mode = "login";
    confirm_password_input = "";
    // Initialize default stats with IGN = username
    with (obj_landing_manager) {
        if (function_exists(create_player_stats)) {
            create_player_stats(username_input, 0, 1, username_input);
        }
    }
} else {
    message = "Error creating account!";
    message_color = c_red;
}
