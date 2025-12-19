/// @description Level Progress Management Functions

/// @function update_level_completion(level_num, stars)
/// @param {real} level_num The level number (1-10)
/// @param {real} stars The stars earned (0-3)
function update_level_completion(level_num, stars) {
    // Validate inputs
    level_num = clamp(level_num, 1, 10);
    stars = clamp(stars, 0, 3);
    
    // Ensure user exists
    if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
        global.logged_in_user = "DefaultUser";
    }
    
    show_debug_message("Updating Level " + string(level_num) + " with " + string(stars) + " stars for user: " + global.logged_in_user);
    
    // Load current user data
    var user_levels = [];
    var user_found = false;
    var all_data = [];
    
    // Initialize user levels array
    for (var i = 0; i < 10; i++) {
        user_levels[i] = 0;
    }
    
    // Read existing data
    if (file_exists("level_data.txt")) {
        var file = file_text_open_read("level_data.txt");
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "") {
                var data = string_split(line, ",");
                if (array_length(data) >= 11 && data[0] == global.logged_in_user) {
                    // Found our user - load their current progress
                    user_found = true;
                    for (var i = 1; i <= 10; i++) {
                        user_levels[i - 1] = real(data[i]);
                    }
                    
                    // Update with new stars (only if better)
                    var level_index = level_num - 1;
                    if (level_index >= 0 && level_index < 10) {
                        var old_stars = user_levels[level_index];
                        if (stars > old_stars) {
                            user_levels[level_index] = stars;
                            show_debug_message("Updated Level " + string(level_num) + " from " + string(old_stars) + " to " + string(stars) + " stars");
                        } else {
                            show_debug_message("Level " + string(level_num) + " already has " + string(old_stars) + " stars (keeping higher score)");
                        }
                    }
                    
                    // Create updated line
                    var new_line = global.logged_in_user;
                    for (var i = 0; i < 10; i++) {
                        new_line += "," + string(user_levels[i]);
                    }
                    array_push(all_data, new_line);
                } else {
                    // Keep other users' data unchanged
                    array_push(all_data, line);
                }
            }
        }
        file_text_close(file);
    }
    
    // If user not found, create new entry
    if (!user_found) {
        show_debug_message("Creating new user entry for: " + global.logged_in_user);
        var level_index = level_num - 1;
        if (level_index >= 0 && level_index < 10) {
            user_levels[level_index] = stars;
        }
        
        var new_line = global.logged_in_user;
        for (var i = 0; i < 10; i++) {
            new_line += "," + string(user_levels[i]);
        }
        array_push(all_data, new_line);
    }
    
    // Write all data back to file
    var file = file_text_open_write("level_data.txt");
    for (var i = 0; i < array_length(all_data); i++) {
        file_text_write_string(file, all_data[i]);
        file_text_writeln(file);
    }
    file_text_close(file);
    
    show_debug_message("Level progress saved successfully!");
    
    // Set global variables for other objects to use
    global.last_level_stars = stars;
    global.last_completed_level = level_num;
    
    return stars;
}
