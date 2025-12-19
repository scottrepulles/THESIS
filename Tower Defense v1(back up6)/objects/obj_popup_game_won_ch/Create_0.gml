/// @description Game Won Object - Create Event (TROPHY SYSTEM INCLUDED)

// Flag to ensure we only update once
level_updated = false;
stars_earned = 0;
current_health = 0;
current_level = 1;

// Get current health from various sources (UPDATED TO INCLUDE VILLAGE_HP)
if (instance_exists(obj_gameplay_manager)) {
    current_health = obj_gameplay_manager.village_hp;
    show_debug_message("Health found in obj_gameplay_manager.village_hp: " + string(current_health));
} else if (variable_global_exists("village_hp")) {
    current_health = global.village_hp;
    show_debug_message("Health found in global.village_hp: " + string(current_health));
} else if (variable_global_exists("current_village_health")) {
    current_health = global.current_village_health;
    show_debug_message("Health found in global.current_village_health: " + string(current_health));
} else if (instance_exists(obj_player)) {
    current_health = obj_player.hp;
    show_debug_message("Health found in obj_player.hp: " + string(current_health));
} else if (variable_global_exists("player_health")) {
    current_health = global.player_health;
    show_debug_message("Health found in global.player_health: " + string(current_health));
} else if (variable_global_exists("health")) {
    current_health = global.health;
    show_debug_message("Health found in global.health: " + string(current_health));
} else if (variable_global_exists("hp")) {
    current_health = global.hp;
    show_debug_message("Health found in global.hp: " + string(current_health));
} else {
    current_health = 10; // Default fallback
    show_debug_message("Warning: No health variable found, using default value 10");
}

// Get current level - IMPROVED DETECTION FOR LEVELS 2-10
if (variable_global_exists("current_level") && global.current_level > 0) {
    current_level = global.current_level;
    show_debug_message("Level found in global.current_level: " + string(current_level));
} else {
    // Try to detect level from room name
    var room_name = room_get_name(room);
    var detected_level = 1;
    
    // Check for various room naming patterns
    if (string_pos("level_", room_name) > 0) {
        var pos = string_pos("level_", room_name) + 6;
        var level_str = string_copy(room_name, pos, 2);
        if (string_digits(level_str) != "") {
            detected_level = real(string_digits(level_str));
        }
    } else if (string_pos("level", room_name) > 0) {
        var pos = string_pos("level", room_name) + 5;
        var level_str = string_copy(room_name, pos, 2);
        if (string_digits(level_str) != "") {
            detected_level = real(string_digits(level_str));
        }
    } else if (string_pos("rm_", room_name) > 0) {
        // Extract numbers from room name
        var digits = string_digits(room_name);
        if (digits != "") {
            detected_level = real(digits);
        }
    }
    
    current_level = clamp(detected_level, 1, 10);
    show_debug_message("Level detected from room name '" + room_name + "': " + string(current_level));
}

// Calculate stars based on health ranges
if (current_health >= 9 && current_health <= 11) {
    stars_earned = 3; // 3 stars for 9-11 health
} else if (current_health >= 5 && current_health <= 8) {
    stars_earned = 2; // 2 stars for 5-8 health
} else if (current_health >= 1 && current_health <= 4) {
    stars_earned = 1; // 1 star for 1-4 health
} else {
    stars_earned = 1; // Minimum 1 star for completing the level
}

// ========== TROPHY REWARDS SYSTEM WITH FILE STORAGE ==========

// Ensure user exists
if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
    global.logged_in_user = "DefaultUser";
    show_debug_message("No user found, using DefaultUser");
}

// Calculate trophies based on health
var trophies_earned = 0;

if (current_health >= 10) {
    trophies_earned = 30; // Perfect health = 30 trophies
} else if (current_health >= 7) {
    trophies_earned = 25; // Good health = 25 trophies
} else if (current_health >= 4) {
    trophies_earned = 20; // Decent health = 20 trophies
} else if (current_health >= 1) {
    trophies_earned = 10; // Low health = 10 trophies
}

show_debug_message("=== TROPHY SYSTEM ===");
show_debug_message("Health Remaining: " + string(current_health));
show_debug_message("Trophies to Award: " + string(trophies_earned));

// Initialize global.player_trophies if it doesn't exist
if (!variable_global_exists("player_trophies")) {
    global.player_trophies = 0;
}

// Trophy file management
var trophy_file = "player_trophies.txt";
var trophy_data = [];
var user_found = false;
var old_trophy_count = 0;

// Read existing trophy data from file
if (file_exists(trophy_file)) {
    var file = file_text_open_read(trophy_file);
    
    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);
        
        if (line != "" && string_length(line) > 0) {
            var data = string_split(line, ",");
            
            if (array_length(data) >= 2 && data[0] == global.logged_in_user) {
                // Found current user's trophy data
                user_found = true;
                old_trophy_count = real(data[1]);
                
                // Add new trophies to existing count
                global.player_trophies = old_trophy_count + trophies_earned;
                
                // Store updated line
                array_push(trophy_data, global.logged_in_user + "," + string(global.player_trophies));
                
                show_debug_message("User found in trophy file");
                show_debug_message("Previous Trophies: " + string(old_trophy_count));
                show_debug_message("New Total: " + string(global.player_trophies));
            } else {
                // Keep other users' data unchanged
                array_push(trophy_data, line);
            }
        }
    }
    
    file_text_close(file);
} else {
    show_debug_message("Trophy file doesn't exist, creating new one");
}

// If user not found in file, create new entry
if (!user_found) {
    global.player_trophies = trophies_earned;
    array_push(trophy_data, global.logged_in_user + "," + string(global.player_trophies));
    
    show_debug_message("New user created in trophy system");
    show_debug_message("Initial Trophies: " + string(global.player_trophies));
}

// Write all trophy data back to file
var file = file_text_open_write(trophy_file);

for (var i = 0; i < array_length(trophy_data); i++) {
    file_text_write_string(file, trophy_data[i]);
    file_text_writeln(file);
}

file_text_close(file);

show_debug_message("Trophy file updated successfully!");
show_debug_message("Trophies Earned This Level: +" + string(trophies_earned));
show_debug_message("Total Player Trophies: " + string(global.player_trophies));
show_debug_message("====================");

scr_update_trophy_display(trophies_earned);

// ========== UPDATE LEVEL PROGRESS ==========
// Update database once - WORKS FOR ALL LEVELS 1-10
if (!level_updated) {
    // Validate inputs
    var level_num = clamp(current_level, 1, 10);
    var stars = clamp(stars_earned, 0, 3);
    
    show_debug_message("=== UPDATING LEVEL PROGRESS ===");
    show_debug_message("Level: " + string(level_num));
    show_debug_message("Stars: " + string(stars));
    show_debug_message("User: " + global.logged_in_user);
    show_debug_message("Health: " + string(current_health));
    
    // Load current user data
    var user_levels = [];
    var user_found_level = false;
    var all_data = [];
    
    // Initialize user levels array with zeros
    for (var i = 0; i < 10; i++) {
        user_levels[i] = 0;
    }
    
    // Read existing data
    if (file_exists("level_data.txt")) {
        var file = file_text_open_read("level_data.txt");
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "" && string_length(line) > 0) {
                var data = string_split(line, ",");
                if (array_length(data) >= 11 && data[0] == global.logged_in_user) {
                    // Found our user - load their current progress
                    user_found_level = true;
                    show_debug_message("Found existing user data");
                    
                    for (var i = 1; i <= 10; i++) {
                        if (i < array_length(data)) {
                            user_levels[i - 1] = real(data[i]);
                        }
                    }
                    
                    // Update with new stars (only if better)
                    var level_index = level_num - 1;
                    if (level_index >= 0 && level_index < 10) {
                        var old_stars = user_levels[level_index];
                        if (stars > old_stars) {
                            user_levels[level_index] = stars;
                            show_debug_message("UPDATED: Level " + string(level_num) + " from " + string(old_stars) + " to " + string(stars) + " stars");
                        } else {
                            show_debug_message("KEPT: Level " + string(level_num) + " already has " + string(old_stars) + " stars (not updating)");
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
    if (!user_found_level) {
        show_debug_message("Creating NEW user entry");
        var level_index = level_num - 1;
        if (level_index >= 0 && level_index < 10) {
            user_levels[level_index] = stars;
        }
        
        var new_line = global.logged_in_user;
        for (var i = 0; i < 10; i++) {
            new_line += "," + string(user_levels[i]);
        }
        array_push(all_data, new_line);
        show_debug_message("NEW USER: Created entry with " + string(stars) + " stars for level " + string(level_num));
    }
    
    // Write all data back to file
    var file = file_text_open_write("level_data.txt");
    for (var i = 0; i < array_length(all_data); i++) {
        file_text_write_string(file, all_data[i]);
        file_text_writeln(file);
    }
    file_text_close(file);
    
    show_debug_message("SUCCESS: Level progress saved to file!");
    
    // Set global variables for other objects to use
    global.last_level_stars = stars;
    global.last_completed_level = level_num;
    
    level_updated = true;
    
    show_debug_message("=== LEVEL COMPLETION SUMMARY ===");
    show_debug_message("Level: " + string(current_level));
    show_debug_message("Village Health Left: " + string(current_health));
    show_debug_message("Stars Earned: " + string(stars_earned));
    show_debug_message("Trophies Earned: " + string(trophies_earned));
    show_debug_message("Total Player Trophies: " + string(global.player_trophies));
    show_debug_message("User: " + string(global.logged_in_user));
    show_debug_message("Files Updated: YES");
    show_debug_message("===============================");
}

// Set text based on stars earned
completion_text = "";
congrats_text = "";

if (stars_earned == 3) {
    completion_text = "Perfect! Stage Complete!";
    congrats_text = "Flawless Victory! +" + string(trophies_earned) + " Trophies!";
} else if (stars_earned == 2) {
    completion_text = "Great! Stage Complete!";
    congrats_text = "Well Done! +" + string(trophies_earned) + " Trophies!";
} else if (stars_earned == 1) {
    completion_text = "Good! Stage Complete!";
    congrats_text = "Keep Trying! +" + string(trophies_earned) + " Trophies!";
} else {
    completion_text = "Stage Complete!";
    congrats_text = "Try Again! +" + string(trophies_earned) + " Trophies!";
}
