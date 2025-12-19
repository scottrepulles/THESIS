// Stage Editor Manager - Create Event

// Ensure global variables are initialized
if (!variable_global_exists("logged_in_user")) {
    global.logged_in_user = "TestUser";
}

// Editor state
editor_mode = true;
selected_level = 1;
edit_mode = "stars"; // "stars", "unlock", "user"

// UI elements
button_width = 100;
button_height = 30;
panel_x = 50;
panel_y = 50;
panel_width = 300;
panel_height = 500;

// User selection
current_view_user = global.logged_in_user; // User currently being viewed
editable_user = global.logged_in_user; // Only this user can be edited
show_warning_timer = 0; // For showing edit restriction warnings

// Load all user data
all_user_data = [];
load_all_user_data = function() {
    all_user_data = [];
    
    if (file_exists("level_data.txt")) {
        var file = file_text_open_read("level_data.txt");
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "") {
                var data = string_split(line, ",");
                if (array_length(data) >= 11) {
                    var user_entry = {
                        username: data[0],
                        levels: [],
                        is_editable: (data[0] == editable_user)
                    };
                    
                    for (var i = 1; i <= 10; i++) {
                        user_entry.levels[i-1] = real(data[i]);
                    }
                    
                    array_push(all_user_data, user_entry);
                }
            }
        }
        file_text_close(file);
    }
}

// Save only the current user's data
save_current_user_data = function() {
    var temp_data = [];
    var found_user = false;
    
    // Read existing data
    if (file_exists("level_data.txt")) {
        var file = file_text_open_read("level_data.txt");
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "") {
                var data = string_split(line, ",");
                if (data[0] == editable_user) {
                    // Update current user's data
                    var user_data = get_user_data(editable_user);
                    var new_line = editable_user;
                    for (var j = 0; j < 10; j++) {
                        new_line += "," + string(user_data.levels[j]);
                    }
                    array_push(temp_data, new_line);
                    found_user = true;
                } else {
                    // Keep other users' data unchanged
                    array_push(temp_data, line);
                }
            }
        }
        file_text_close(file);
    }
    
    // If current user not found, add new entry
    if (!found_user) {
        var user_data = get_user_data(editable_user);
        var new_line = editable_user;
        for (var j = 0; j < 10; j++) {
            new_line += "," + string(user_data.levels[j]);
        }
        array_push(temp_data, new_line);
    }
    
    // Write updated data
    var file = file_text_open_write("level_data.txt");
    for (var i = 0; i < array_length(temp_data); i++) {
        file_text_write_string(file, temp_data[i]);
        file_text_writeln(file);
    }
    file_text_close(file);
}

// Get user data by username
get_user_data = function(username) {
    for (var i = 0; i < array_length(all_user_data); i++) {
        if (all_user_data[i].username == username) {
            return all_user_data[i];
        }
    }
    
    // Create new user if not found (only for editable user)
    if (username == editable_user) {
        var new_user = {
            username: username,
            levels: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            is_editable: true
        };
        array_push(all_user_data, new_user);
        return new_user;
    }
    
    return undefined;
}

// Get currently viewed user data
get_current_view_data = function() {
    return get_user_data(current_view_user);
}

// Set level stars (only for editable user)
set_level_stars = function(level, stars) {
    if (current_view_user != editable_user) {
        show_warning_timer = 180; // Show warning for 3 seconds
        return false;
    }
    
    var user_data = get_user_data(editable_user);
    if (user_data != undefined) {
        user_data.levels[level - 1] = clamp(stars, 0, 3);
        save_current_user_data();
        load_all_user_data();
        return true;
    }
    return false;
}

// Reset progress (only for editable user)
reset_current_user_progress = function() {
    if (current_view_user != editable_user) {
        show_warning_timer = 180;
        return false;
    }
    
    var user_data = get_user_data(editable_user);
    if (user_data != undefined) {
        for (var i = 0; i < 10; i++) {
            user_data.levels[i] = 0;
        }
        save_current_user_data();
        load_all_user_data();
        return true;
    }
    return false;
}

// Unlock all levels (only for editable user)
unlock_all_levels_current_user = function() {
    if (current_view_user != editable_user) {
        show_warning_timer = 180;
        return false;
    }
    
    var user_data = get_user_data(editable_user);
    if (user_data != undefined) {
        for (var i = 0; i < 10; i++) {
            if (user_data.levels[i] == 0) {
                user_data.levels[i] = 1; // Give 1 star to unlock
            }
        }
        save_current_user_data();
        load_all_user_data();
        return true;
    }
    return false;
}

// Switch view to different user
switch_view_user = function(username) {
    current_view_user = username;
    show_debug_message("Switched view to: " + username);
    if (username != editable_user) {
        show_debug_message("Note: " + username + " is view-only. Only " + editable_user + " can be edited.");
    }
}

// Check if currently viewed user is editable
is_current_view_editable = function() {
    return (current_view_user == editable_user);
}

// Load initial data
load_all_user_data();

// Ensure current user exists in data
get_user_data(editable_user);

// Create some test users if none exist
if (array_length(all_user_data) <= 1) {
    // Add test data to file for demonstration
    var test_users = [
        "Player,0,0,0,0,0,0,0,0,0,0",
    ];
    
    var file = file_text_open_write("level_data.txt");
    // Keep current user data
    var current_data = get_user_data(editable_user);
    if (current_data != undefined) {
        var line = editable_user;
        for (var i = 0; i < 10; i++) {
            line += "," + string(current_data.levels[i]);
        }
        file_text_write_string(file, line);
        file_text_writeln(file);
    }
    
    // Add test users (only if they're not the current user)
    for (var i = 0; i < array_length(test_users); i++) {
        var test_line = test_users[i];
        var test_name = string_copy(test_line, 1, string_pos(",", test_line) - 1);
        if (test_name != editable_user) {
            file_text_write_string(file, test_line);
            file_text_writeln(file);
        }
    }
    file_text_close(file);
    
    // Reload data
    load_all_user_data();
}
