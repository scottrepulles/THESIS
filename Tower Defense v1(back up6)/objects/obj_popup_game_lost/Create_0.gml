/// @description Game Lost Object - Create Event (WITH TROPHY PENALTY)

// Flag to ensure we only update once
level_updated = false;
trophy_penalty_applied = false;

// Ensure user exists
if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
    global.logged_in_user = "DefaultUser";
}

// Initialize global.player_trophies if it doesn't exist
if (!variable_global_exists("player_trophies")) {
    global.player_trophies = 0;
}

// ========== CHECK IF IN RANK ROOM AND APPLY TROPHY PENALTY ==========
var current_room_name = room_get_name(room);
var is_rank_room = false;

// Check if current room is a rank room
if (string_pos("rm_rank_bronze", current_room_name) > 0 ||
    string_pos("rm_rank_silver", current_room_name) > 0 ||
    string_pos("rm_rank_gold", current_room_name) > 0 ||
    string_pos("rm_rank_platinum", current_room_name) > 0) {
    
    is_rank_room = true;
    show_debug_message("=== GAME LOST IN RANK ROOM ===");
    show_debug_message("Room: " + current_room_name);
}

var trophy_change = 0;

if (is_rank_room && !trophy_penalty_applied) {
    // Apply -30 trophy penalty for losing in rank rooms
    trophy_change = -30;
    
    show_debug_message("Trophy Penalty: " + string(trophy_change));
    
    // ===== LOAD AND UPDATE TROPHY FILE =====
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
                    
                    // Apply penalty (but don't go below 0)
                    global.player_trophies = max(0, old_trophy_count + trophy_change);
                    
                    // Store updated line
                    array_push(trophy_data, global.logged_in_user + "," + string(global.player_trophies));
                    
                    show_debug_message("User found in trophy file");
                    show_debug_message("Previous Trophies: " + string(old_trophy_count));
                    show_debug_message("Penalty Applied: " + string(trophy_change));
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
    
    // If user not found in file, create new entry (with 0 trophies after penalty)
    if (!user_found) {
        global.player_trophies = 0; // Can't go negative
        array_push(trophy_data, global.logged_in_user + "," + string(global.player_trophies));
        
        show_debug_message("New user created in trophy system");
        show_debug_message("Trophies after penalty: " + string(global.player_trophies));
    }
    
    // Write all trophy data back to file
    var file = file_text_open_write(trophy_file);
    
    for (var i = 0; i < array_length(trophy_data); i++) {
        file_text_write_string(file, trophy_data[i]);
        file_text_writeln(file);
    }
    
    file_text_close(file);
    
    show_debug_message("Trophy file updated successfully!");
    show_debug_message("Trophy Change: " + string(trophy_change));
    show_debug_message("Total Player Trophies: " + string(global.player_trophies));
    show_debug_message("=============================");
    
    // Update trophy display if it exists
    if (script_exists(asset_get_index("scr_update_trophy_display"))) {
        scr_update_trophy_display(trophy_change);
    } else {
        // Manual update
        global.last_trophy_change = trophy_change;
        if (variable_global_exists("change_display_duration")) {
            global.last_change_timer = global.change_display_duration;
        } else {
            global.last_change_timer = 120;
        }
        
        // Force trophy display to reload
        if (instance_exists(obj_trophy_display)) {
            obj_trophy_display.trophies_loaded = false;
        }
    }
    
    trophy_penalty_applied = true;
}

// ========== SET DEFEAT TEXT ==========
defeat_text = "";
message_text = "";

if (is_rank_room) {
    defeat_text = "Defeat!";
    message_text = "You Lost -30 Trophies!";
} else {
    defeat_text = "Level Failed!";
    message_text = "Try Again!";
}

show_debug_message("=== GAME LOST SUMMARY ===");
show_debug_message("Room: " + current_room_name);
show_debug_message("Is Rank Room: " + string(is_rank_room));
show_debug_message("Trophy Change: " + string(trophy_change));
show_debug_message("Current Trophies: " + string(global.player_trophies));
show_debug_message("User: " + string(global.logged_in_user));
show_debug_message("========================");
