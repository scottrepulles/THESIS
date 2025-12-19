// Initialize variables
username_input = "";
password_input = "";
confirm_password_input = "";
message = "";
message_color = c_red;
current_mode = "login"; // "login" or "register"
active_field = "username"; // "username", "password", "confirm", "main_button", "switch_button"

// UI positions
button_width = 200;
button_height = 40;
textbox_width = 300;
textbox_height = 30;

// Center everything on screen
center_x = room_width / 2;
center_y = room_height / 2;

// Function to get next field in tab order
function get_next_field(current_field, mode) {
    if (mode == "login") {
        switch(current_field) {
            case "username": return "password";
            case "password": return "main_button";
            case "main_button": return "switch_button";
            case "switch_button": return "username";
            default: return "username";
        }
    } else { // register mode
        switch(current_field) {
            case "username": return "password";
            case "password": return "confirm";
            case "confirm": return "main_button";
            case "main_button": return "switch_button";
            case "switch_button": return "username";
            default: return "username";
        }
    }
}

// Function to save user data
function save_user_data(username, password) {
    var users = "";
    if (file_exists("users.txt")) {
        var read_file = file_text_open_read("users.txt");
        if (read_file != -1) {
            while (!file_text_eof(read_file)) {
                users += file_text_readln(read_file);
            }
            file_text_close(read_file);
        }
    }
    
    // Append new user
    var write_file = file_text_open_write("users.txt");
    if (write_file != -1) {
        file_text_write_string(write_file, users);
        file_text_write_string(write_file, username + ":" + password + "\n");
        file_text_close(write_file);
        return true;
    }
    return false;
}

// Function to check if user exists
function user_exists(username) {
    if (!file_exists("users.txt")) return false;
    
    var file = file_text_open_read("users.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var colon_pos = string_pos(":", line);
            if (colon_pos > 0) {
                var stored_username = string_copy(line, 1, colon_pos - 1);
                if (stored_username == username) {
                    file_text_close(file);
                    return true;
                }
            }
        }
        file_text_close(file);
    }
    return false;
}

// Function to validate login
function validate_login(username, password) {
    if (!file_exists("users.txt")) return false;
    
    var file = file_text_open_read("users.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var colon_pos = string_pos(":", line);
            if (colon_pos > 0) {
                var stored_username = string_copy(line, 1, colon_pos - 1);
                var stored_password = string_copy(line, colon_pos + 1, string_length(line) - colon_pos);
                // Remove newline character
                stored_password = string_replace(stored_password, "\n", "");
                stored_password = string_replace(stored_password, "\r", "");
                
                if (stored_username == username && stored_password == password) {
                    file_text_close(file);
                    return true;
                }
            }
        }
        file_text_close(file);
    }
    return false;
}
// Check if user is already logged in
if (variable_global_exists("current_user") && global.current_user != "") {
    room_goto(rm_landing);
}