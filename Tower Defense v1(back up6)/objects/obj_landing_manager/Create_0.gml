// Store the logged-in username (this will be set from the login room)
logged_in_user = "";
if (variable_global_exists("current_user")) {
    logged_in_user = global.current_user;
} else {
    logged_in_user = "Guest";
}

// Store room references
login_room_index = 0;

// UI elements
button_width = 200;
button_height = 40;
center_x = room_width / 2;
center_y = room_height / 2;

// Menu options - will be updated based on user role
menu_options = ["Play Game", "Settings", "View Profile", "Player Stats", "Logout"];
selected_option = 0;

// Check if current user is admin and add admin options
function update_menu_options() {
    if (logged_in_user == "admin") {
        menu_options = ["Play Game", "Settings", "View Profile", "Manage Accounts", "Player Stats", "Logout"];
    } else {
        // Non-admins can also view Player Stats (read-only)
        menu_options = ["Play Game", "Settings", "View Profile", "Player Stats", "Logout"];
    }
}

// Account management variables (admin only)
show_accounts = false;
show_player_stats = false;
show_profile = false; // Profile screen for all users
accounts_list = [];
player_stats_list = []; // Will store [username, password, score, level, ign]
selected_account = 0;
scroll_offset = 0;
max_visible_accounts = 5;

// Edit mode variables (admin only)
edit_mode = false;
edit_stats_mode = false;
edit_field = "username"; // "username", "password", "score", "level"
edit_username = "";
edit_password = "";
edit_score = "";
edit_level = "";
original_username = "";
// Profile edit variables (all users - IGN only)
profile_field = "ign"; // only "ign"
profile_edit_ign = "";
profile_message = "";
profile_message_color = c_white;


// Admin check function
function is_admin() {
    return logged_in_user == "admin";
}

// Function to create admin account if it doesn't exist
function ensure_admin_exists() {
    if (!file_exists("users.txt")) {
        // Create the file with admin account
        var file = file_text_open_write("users.txt");
        if (file != -1) {
            file_text_write_string(file, "admin:admin\n");
            file_text_close(file);
        }
    } else {
        // Check if admin exists
        var admin_exists = false;
        var file = file_text_open_read("users.txt");
        if (file != -1) {
            while (!file_text_eof(file)) {
                var line = file_text_readln(file);
                var colon_pos = string_pos(":", line);
                if (colon_pos > 0) {
                    var username = string_copy(line, 1, colon_pos - 1);
                    if (username == "admin") {
                        admin_exists = true;
                        break;
                    }
                }
            }
            file_text_close(file);
        }
        
        // Add admin if doesn't exist
        if (!admin_exists) {
            var file = file_text_open_append("users.txt");
            if (file != -1) {
                file_text_write_string(file, "admin:admin\n");
                file_text_close(file);
            }
        }
    }
    
    // Ensure player stats file exists
    ensure_player_stats_exists();
}

// Function to ensure player stats file exists
function ensure_player_stats_exists() {
    if (!file_exists("player_stats.txt")) {
        // Create empty stats file
        var file = file_text_open_write("player_stats.txt");
        if (file != -1) {
            file_text_close(file);
        }
    }
}

// Function to get or create player stats (returns [score, level, ign])
function get_player_stats(username) {
    if (!file_exists("player_stats.txt")) return [0, 1, username]; // default score=0, level=1, ign=username

    var file = file_text_open_read("player_stats.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            line = string_replace(line, "\n", "");
            line = string_replace(line, "\r", "");

            var parts = string_split(line, ":");
            if (array_length(parts) >= 3 && parts[0] == username) {
                // Backward compatible: parts could be [user,score,level] or [user,score,level,ign]
                var score_val = real(parts[1]);
                var level_val = real(parts[2]);
                var ign_val = (array_length(parts) >= 4) ? parts[3] : username;
                file_text_close(file);
                return [score_val, level_val, ign_val];
            }
        }
        file_text_close(file);
    }

    // If player not found, create default stats with ign=username
    create_player_stats(username, 0, 1, username);
    return [0, 1, username];
}

// Function to create player stats (with IGN)
function create_player_stats(username, score, level, ign) {
    var file = file_text_open_append("player_stats.txt");
    if (file != -1) {
        file_text_write_string(file, username + ":" + string(score) + ":" + string(level) + ":" + string(ign) + "\n");
        file_text_close(file);
    }
}

// Function to update player stats (keeps IGN as-is)
function update_player_stats(username, new_score, new_level) {
    if (!file_exists("player_stats.txt")) return false;
    
    var new_content = "";
    var found = false;
    
    var file = file_text_open_read("player_stats.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var clean_line = string_replace(line, "\n", "");
            clean_line = string_replace(clean_line, "\r", "");
            
            var parts = string_split(clean_line, ":");
            if (array_length(parts) >= 3 && parts[0] == username) {
                var ign_val = (array_length(parts) >= 4) ? parts[3] : username;
                new_content += username + ":" + string(new_score) + ":" + string(new_level) + ":" + string(ign_val) + "\n";
                found = true;
            } else if (clean_line != "") {
                new_content += line;
            }
        }
        file_text_close(file);
        
        // If player not found, add them
        if (!found) {
            new_content += username + ":" + string(new_score) + ":" + string(new_level) + ":" + string(username) + "\n";
        }
        
        // Write back to file
        var write_file = file_text_open_write("player_stats.txt");
        if (write_file != -1) {
            file_text_write_string(write_file, new_content);
            file_text_close(write_file);
            return true;
        }
    }
    return false;
}

// Function to update only the IGN for a player
function update_player_ign(username, new_ign) {
    if (!file_exists("player_stats.txt")) return false;

    var new_content = "";
    var found = false;

    var file = file_text_open_read("player_stats.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var clean_line = string_replace(line, "\n", "");
            clean_line = string_replace(clean_line, "\r", "");

            var parts = string_split(clean_line, ":");
            if (array_length(parts) >= 3 && parts[0] == username) {
                var score_val = real(parts[1]);
                var level_val = real(parts[2]);
                new_content += username + ":" + string(score_val) + ":" + string(level_val) + ":" + string(new_ign) + "\n";
                found = true;
            } else if (clean_line != "") {
                new_content += line;
            }
        }
        file_text_close(file);

        if (!found) {
            // Create a new entry if none existed
            new_content += username + ":0:1:" + string(new_ign) + "\n";
        }

        var write_file = file_text_open_write("player_stats.txt");
        if (write_file != -1) {
            file_text_write_string(write_file, new_content);
            file_text_close(write_file);
            return true;
        }
    }
    return false;
}

// Function to load all accounts with passwords (admin only)
function load_accounts() {
    accounts_list = [];
    if (!file_exists("users.txt")) return;
    
    var file = file_text_open_read("users.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var colon_pos = string_pos(":", line);
            if (colon_pos > 0) {
                var username = string_copy(line, 1, colon_pos - 1);
                var password = string_copy(line, colon_pos + 1, string_length(line) - colon_pos);
                // Remove newline characters
                password = string_replace(password, "\n", "");
                password = string_replace(password, "\r", "");
                
                if (username != "") {
                    array_push(accounts_list, [username, password]);
                }
            }
        }
        file_text_close(file);
    }
}

// Function to load player stats (all users can view; admin can edit)
function load_player_stats() {
    player_stats_list = [];

    // First load all accounts
    load_accounts();

    // Then get stats for each account
    for (var i = 0; i < array_length(accounts_list); i++) {
        var account_data = accounts_list[i];
        var username = account_data[0];
        var password = account_data[1];
        var stats = get_player_stats(username); // [score, level, ign]

        array_push(player_stats_list, [username, password, stats[0], stats[1], stats[2]]); // [username, password, score, level, ign]
    }
}

// Function to save all accounts (admin only)
function save_all_accounts() {
    if (!is_admin()) return false;
    
    var file = file_text_open_write("users.txt");
    if (file != -1) {
        for (var i = 0; i < array_length(accounts_list); i++) {
            var account_data = accounts_list[i];
            file_text_write_string(file, account_data[0] + ":" + account_data[1] + "\n");
        }
        file_text_close(file);
        return true;
    }
    return false;
}

// Function to update account (admin only)
function update_account(old_username, new_username, new_password) {
    if (!is_admin()) return false;
    
    // Check if new username already exists (if username changed)
    if (old_username != new_username) {
        for (var i = 0; i < array_length(accounts_list); i++) {
            if (accounts_list[i][0] == new_username) {
                return false; // Username already exists
            }
        }
    }
    
    // Find and update the account
    for (var i = 0; i < array_length(accounts_list); i++) {
        if (accounts_list[i][0] == old_username) {
            accounts_list[i][0] = new_username;
            accounts_list[i][1] = new_password;
            
            // Update global current_user if editing own account
            if (old_username == logged_in_user) {
                global.current_user = new_username;
                logged_in_user = new_username;
            }
            
            return save_all_accounts();
        }
    }
    return false;
}

// Function to update player stats in admin mode
function update_player_stats_admin(old_username, new_username, new_password, new_score, new_level) {
    if (!is_admin()) return false;
    
    // Update account info first
    if (!update_account(old_username, new_username, new_password)) {
        return false;
    }
    
    // Update player stats
    return update_player_stats(new_username, new_score, new_level);
}

// Function to delete account (admin only)
function delete_account(username_to_delete) {
    if (!is_admin()) return false;
    
    // Prevent deleting admin account
    if (username_to_delete == "admin") {
        show_message("Cannot delete admin account!");
        return false;
    }
    
    for (var i = 0; i < array_length(accounts_list); i++) {
        if (accounts_list[i][0] == username_to_delete) {
            array_delete(accounts_list, i, 1);
            
            // Also remove from stats file
            delete_player_stats(username_to_delete);
            
            return save_all_accounts();
        }
    }
    return false;
}

// Function to delete player stats
function delete_player_stats(username) {
    if (!file_exists("player_stats.txt")) return;
    
    var new_content = "";
    var file = file_text_open_read("player_stats.txt");
    if (file != -1) {
        while (!file_text_eof(file)) {
            var line = file_text_readln(file);
            var clean_line = string_replace(line, "\n", "");
            clean_line = string_replace(clean_line, "\r", "");
            
            var parts = string_split(clean_line, ":");
            if (array_length(parts) >= 3 && parts[0] != username) {
                new_content += line;
            }
        }
        file_text_close(file);
        
        // Write back to file
        var write_file = file_text_open_write("player_stats.txt");
        if (write_file != -1) {
            file_text_write_string(write_file, new_content);
            file_text_close(write_file);
        }
    }
}

// Initialize
ensure_admin_exists();
update_menu_options();
if (is_admin()) {
    load_accounts();
    load_player_stats();
}

// Function to get rank based on trophy count
function get_rank_from_trophy(trophy_count) {
    if (trophy_count >= 2000) {
        return "Platinum";
    } else if (trophy_count >= 1999) {
        return "Gold";
    } else if (trophy_count >= 999) {
        return "Silver";
    } else {
        return "Bronze";
    }
}

// Function to get rank color (case-insensitive)
function get_rank_color(rank_name) {
    var r = string_lower(rank_name);
    switch(r) {
        case "platinum": return c_aqua;
        case "gold": return c_yellow;
        case "silver": return c_ltgray;
        case "bronze": return #CD7F32; // Bronze color
        default: return c_white;
    }
}

// Optional: get rank sprite if available in assets
// Expected sprite names: spr_rank_bronze, spr_rank_silver, spr_rank_gold, spr_rank_platinum
function get_rank_sprite(rank_name) {
    var r = string_lower(rank_name);
    var sprite_name = "";
    switch(r) {
        case "platinum": sprite_name = "spr_rank_platinum"; break;
        case "gold": sprite_name = "spr_rank_gold"; break;
        case "silver": sprite_name = "spr_rank_silver"; break;
        case "bronze": sprite_name = "spr_rank_bronze"; break;
        default: sprite_name = ""; break;
    }
    if (sprite_name != "") {
        var spr = asset_get_index(sprite_name);
        if (spr != -1) {
            return spr;
        }
    }
    return -1; // not found
}

