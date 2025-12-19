// Stage Level Parent - Create Event

// Initialize global.logged_in_user if it doesn't exist
if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
    global.logged_in_user = "DefaultUser";
    show_debug_message("Warning: global.logged_in_user not set. Using default: " + global.logged_in_user);
}

// Get stage number from object name - IMPROVED DETECTION
var obj_name = object_get_name(object_index);
stage_number = 1; // Default fallback

// Method 1: Look for numbers at the end of the object name
var name_length = string_length(obj_name);
var found_number = false;

// Check for two-digit numbers first (like "10")
if (name_length >= 2) {
    var last_two = string_copy(obj_name, name_length - 1, 2);
    if (string_digits(last_two) == last_two && last_two != "" && real(last_two) > 0) {
        stage_number = real(last_two);
        found_number = true;
        show_debug_message("Found two-digit stage number: " + string(stage_number) + " from: " + last_two);
    }
}

// If no two-digit number found, check single digit
if (!found_number && name_length >= 1) {
    var last_char = string_copy(obj_name, name_length, 1);
    if (string_digits(last_char) == last_char && last_char != "" && real(last_char) > 0) {
        stage_number = real(last_char);
        found_number = true;
        show_debug_message("Found single-digit stage number: " + string(stage_number) + " from: " + last_char);
    }
}

if (!found_number) {
    show_debug_message("Warning: Could not parse stage number from object name: " + obj_name + ". Using default: 1");
    stage_number = 1;
}

// Ensure stage_number is within valid range
stage_number = clamp(stage_number, 1, 10);

show_debug_message("Final stage number for " + obj_name + ": " + string(stage_number));

// Button properties - USE ROOM-DEFINED SIZE, NOT SPRITE SIZE
button_width = image_xscale * sprite_get_width(sprite_index);
button_height = image_yscale * sprite_get_height(sprite_index);

// Store original scale values from room
original_xscale = image_xscale;
original_yscale = image_yscale;

// Animation properties
scale_multiplier = 1.0;
target_scale_multiplier = 1.0;
bounce_timer = 0;
is_hovered = false;
is_pressed = false;

// Get current user's level progress from level data
current_user_levels = [];
if (file_exists("level_data.txt")) {
    var file = file_text_open_read("level_data.txt");
    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);
        
        if (line != "") {
            var data = string_split(line, ",");
            if (array_length(data) >= 11 && data[0] == global.logged_in_user) {
                // Parse level data (levels 1-10 are in positions 1-10)
                for (var i = 1; i <= 10; i++) {
                    current_user_levels[i - 1] = real(data[i]);
                }
                break;
            }
        }
    }
    file_text_close(file);
}

// Initialize levels array if user not found or array is empty
if (array_length(current_user_levels) == 0) {
    for (var i = 0; i < 10; i++) {
        current_user_levels[i] = 0;
    }
    show_debug_message("Initialized empty user data for: " + global.logged_in_user);
}

// Ensure array has exactly 10 elements
while (array_length(current_user_levels) < 10) {
    array_push(current_user_levels, 0);
}

// Check if level is unlocked based on level data logic
is_level_unlocked = function() {
    var level_index = stage_number - 1;
    
    // Safety check for valid level index
    if (level_index < 0 || level_index >= array_length(current_user_levels)) {
        return false;
    }
    
    // Level 1 is always unlocked
    if (stage_number == 1) return true;
    
    // Check if previous level has at least 1 star
    var prev_index = level_index - 1;
    if (prev_index >= 0 && prev_index < array_length(current_user_levels)) {
        return current_user_levels[prev_index] > 0;
    }
    
    return false;
}

// Function to get the room ID for this level
get_level_room_id = function() {
    // Method 1: Try common naming conventions
    var room_names = [
        "rm_level_" + string(stage_number),           // rm_level_1, rm_level_2, etc.
        "rm_level" + string(stage_number),            // rm_level1, rm_level2, etc.
        "room_level_" + string(stage_number),         // room_level_1, room_level_2, etc.
        "level_" + string(stage_number),              // level_1, level_2, etc.
        "Level" + string(stage_number),               // Level1, Level2, etc.
        "rm_stage_" + string(stage_number),           // rm_stage_1, rm_stage_2, etc.
        "rm_game_level_" + string(stage_number)       // rm_game_level_1, etc.
    ];
    
    // Try to find the room
    for (var i = 0; i < array_length(room_names); i++) {
        var room_id = asset_get_index(room_names[i]);
        if (room_id != -1) {
            show_debug_message("Found room: " + room_names[i] + " for Level " + string(stage_number));
            return room_id;
        }
    }
    
    // Method 2: Custom mapping for special levels
    switch (stage_number) {
        case 5:  
            var boss_room = asset_get_index("rm_boss_1");
            if (boss_room != -1) return boss_room;
            break;
        case 10: 
            var final_boss = asset_get_index("rm_final_boss");
            if (final_boss != -1) return final_boss;
            break;
        default: 
            break;
    }
    
    // Method 3: Try generic rooms as fallback
    var generic_rooms = [
        "rm_game",
        "rm_gameplay", 
        "rm_level_test"
    ];
    
    for (var i = 0; i < array_length(generic_rooms); i++) {
        var room_id = asset_get_index(generic_rooms[i]);
        if (room_id != -1) {
            show_debug_message("Using fallback room: " + generic_rooms[i] + " for Level " + string(stage_number));
            return room_id;
        }
    }
    
    show_debug_message("No room found for Level " + string(stage_number));
    return -1; // No room found
}

// Function to check if level is clickable (unlocked)
is_level_clickable = function() {
    return is_level_unlocked();
}

// Function to get level status text
get_level_status_text = function() {
    var unlocked = is_level_unlocked();
    var stars = get_star_count();
    
    if (!unlocked) {
        return "LOCKED";
    } else if (stars == 0) {
        return "AVAILABLE";
    } else {
        return string(stars) + " STAR" + (stars == 1 ? "" : "S");
    }
}

// Determine button state based on level data
get_button_state = function() {
    var level_index = stage_number - 1;
    
    // Safety check for valid level index
    if (level_index < 0 || level_index >= array_length(current_user_levels)) {
        show_debug_message("Error: Invalid level index " + string(level_index) + " for stage " + string(stage_number));
        return 0; // Return locked state as fallback
    }
    
    var stars = current_user_levels[level_index];
    var unlocked = is_level_unlocked();
    
    show_debug_message("Level " + string(stage_number) + " - Stars: " + string(stars) + ", Unlocked: " + string(unlocked));
    
    // Sprite frame mapping:
    // Frame 0: Locked
    // Frame 1: Available (0 stars, but unlocked)
    // Frame 2: 1 star completed
    // Frame 3: 2 stars completed
    // Frame 4: 3 stars completed
    
    if (!unlocked) {
        return 0; // Locked state
    }
    
    if (stars == 0) {
        return 1; // Available but not completed
    }
    
    // Return frame 2, 3, or 4 for 1, 2, or 3 stars
    return 1 + clamp(stars, 1, 3);
}

// Get star count for this level
get_star_count = function() {
    var level_index = stage_number - 1;
    
    // Safety check for valid level index
    if (level_index < 0 || level_index >= array_length(current_user_levels)) {
        show_debug_message("Error: Invalid level index " + string(level_index) + " for stage " + string(stage_number));
        return 0;
    }
    
    return current_user_levels[level_index];
}

// Function to update level progress (call this when level is completed)
update_level_progress = function(stars) {
    var level_index = stage_number - 1;
    
    // Safety check for valid level index
    if (level_index < 0 || level_index >= array_length(current_user_levels)) {
        show_debug_message("Error: Cannot update progress for invalid level index " + string(level_index));
        return;
    }
    
    // Clamp stars to valid range
    stars = clamp(stars, 0, 3);
    
    // Only update if new score is better
    if (stars > current_user_levels[level_index]) {
        current_user_levels[level_index] = stars;
        save_level_progress();
        show_debug_message("Updated Level " + string(stage_number) + " to " + string(stars) + " stars");
    }
}

// Save level progress to file
save_level_progress = function() {
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
                if (data[0] == global.logged_in_user) {
                    // Update this user's data
                    var new_line = global.logged_in_user;
                    for (var i = 0; i < 10; i++) {
                        new_line += "," + string(current_user_levels[i]);
                    }
                    array_push(temp_data, new_line);
                    found_user = true;
                } else {
                    array_push(temp_data, line);
                }
            }
        }
        file_text_close(file);
    }
    
    // If user not found, add new entry
    if (!found_user) {
        var new_line = global.logged_in_user;
        for (var i = 0; i < 10; i++) {
            new_line += "," + string(current_user_levels[i]);
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

// Create some test data if file doesn't exist
if (!file_exists("level_data.txt")) {
    show_debug_message("Creating test data...");
    var file = file_text_open_write("level_data.txt");
    // Level 1 has 3 stars, Level 2 has 2 stars, Level 3 has 1 star, rest are 0
    file_text_write_string(file, global.logged_in_user + ",3,2,1,0,0,0,0,0,0,0");
    file_text_writeln(file);
    file_text_close(file);
    
    // Reload data
    current_user_levels = [];
    var file = file_text_open_read("level_data.txt");
    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);
        
        if (line != "") {
            var data = string_split(line, ",");
            if (array_length(data) >= 11 && data[0] == global.logged_in_user) {
                for (var i = 1; i <= 10; i++) {
                    current_user_levels[i - 1] = real(data[i]);
                }
                break;
            }
        }
    }
    file_text_close(file);
}

// Debug info
show_debug_message("=== LEVEL " + string(stage_number) + " CREATED ===");
show_debug_message("Object: " + obj_name);
show_debug_message("Stage Number: " + string(stage_number));
show_debug_message("Room-defined size: " + string(button_width) + "x" + string(button_height));
show_debug_message("Original scale: " + string(original_xscale) + "x" + string(original_yscale));
show_debug_message("Stars: " + string(get_star_count()));
show_debug_message("Unlocked: " + string(is_level_unlocked()));
show_debug_message("Button Frame: " + string(get_button_state()));
show_debug_message("Status: " + get_level_status_text());
show_debug_message("User Data: " + string(current_user_levels));
show_debug_message("=====================================");
