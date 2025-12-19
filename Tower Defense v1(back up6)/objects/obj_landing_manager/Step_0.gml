if (!show_accounts && !show_player_stats && !show_profile) {
    // Normal menu navigation
    if (keyboard_check_pressed(vk_up)) {
        selected_option--;
        if (selected_option < 0) selected_option = array_length(menu_options) - 1;
    }

    if (keyboard_check_pressed(vk_down)) {
        selected_option++;
        if (selected_option >= array_length(menu_options)) selected_option = 0;
    }

    // Handle Enter key
    if (keyboard_check_pressed(vk_enter)) {
        if (is_admin() && array_length(menu_options) == 6) {
            // Admin menu (6 options)
            switch(selected_option) {
                case 0: show_message("Starting game for " + logged_in_user + "!"); break;
                case 1: show_message("Settings menu (not implemented yet)"); break;
                case 2:
                    show_profile = true;
                    var stats_self = get_player_stats(logged_in_user);
                    profile_edit_ign = stats_self[2];
                    profile_message = "";
                    profile_field = "ign";
                    break;
                case 3:
                    show_accounts = true;
                    load_accounts();
                    selected_account = 0;
                    scroll_offset = 0;
                    edit_mode = false;
                    break;
                case 4:
                    show_player_stats = true;
                    load_player_stats();
                    selected_account = 0;
                    scroll_offset = 0;
                    edit_stats_mode = false;
                    break;
                case 5:
                    global.current_user = "";
                    game_restart();
                    break;
            }
        } else {
            // Regular user menu (5 options including Player Stats)
            switch(selected_option) {
                case 0: show_message("Starting game for " + logged_in_user + "!"); break;
                case 1: show_message("Settings menu (not implemented yet)"); break;
                case 2: show_message("Profile for: " + logged_in_user); break;
                case 3:
                    show_player_stats = true; // read-only for non-admin
                    load_player_stats();
                    selected_account = 0;
                    scroll_offset = 0;
                    edit_stats_mode = false;
                    break;
                case 4:
                    global.current_user = "";
                    game_restart();
                    break;
            }
        }
    }

    // Handle mouse clicks for main menu
    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        
        for (var i = 0; i < array_length(menu_options); i++) {
            var option_y = center_y - 100 + (i * 60);
            
            if (mx >= center_x - button_width/2 && mx <= center_x + button_width/2 &&
                my >= option_y && my <= option_y + button_height) {
                selected_option = i;
                
                if (is_admin() && array_length(menu_options) == 6) {
                    // Admin menu
                    switch(i) {
                        case 0: show_message("Starting game for " + logged_in_user + "!"); break;
                        case 1: show_message("Settings menu (not implemented yet)"); break;
                        case 2:
                            show_profile = true;
                            var stats_self2 = get_player_stats(logged_in_user);
                            profile_edit_ign = stats_self2[2];
                            profile_message = "";
                            profile_field = "ign";
                            break;
                        case 3:
                            show_accounts = true;
                            load_accounts();
                            selected_account = 0;
                            scroll_offset = 0;
                            edit_mode = false;
                            break;
                        case 4:
                            show_player_stats = true;
                            load_player_stats();
                            selected_account = 0;
                            scroll_offset = 0;
                            edit_stats_mode = false;
                            break;
                        case 5:
                            global.current_user = "";
                            game_restart();
                            break;
                    }
                } else {
                    // Regular user menu with Player Stats
                    switch(i) {
                        case 0: show_message("Starting game for " + logged_in_user + "!"); break;
                        case 1: show_message("Settings menu (not implemented yet)"); break;
                        case 2: show_message("Profile for: " + logged_in_user); break;
                        case 3:
                            show_player_stats = true; // read-only for non-admin
                            load_player_stats();
                            selected_account = 0;
                            scroll_offset = 0;
                            edit_stats_mode = false;
                            break;
                        case 4:
                            global.current_user = "";
                            game_restart();
                            break;
                    }
                }
            }
        }
    }
} else if (show_player_stats && !edit_stats_mode) {
    // Player stats navigation (all users; restrict editing for non-admin)
    
    if (keyboard_check_pressed(vk_up)) {
        selected_account--;
        if (selected_account < 0) selected_account = array_length(player_stats_list) - 1;
        
        if (selected_account < scroll_offset) {
            scroll_offset = selected_account;
        }
    }

    if (keyboard_check_pressed(vk_down)) {
        selected_account++;
        if (selected_account >= array_length(player_stats_list)) selected_account = 0;
        
        if (selected_account >= scroll_offset + max_visible_accounts) {
            scroll_offset = selected_account - max_visible_accounts + 1;
        }
    }

    // Handle Enter key
    if (keyboard_check_pressed(vk_enter) && array_length(player_stats_list) > 0) {
        var player_data = player_stats_list[selected_account];
        if (is_admin()) {
            // Admin: open edit stats
            edit_stats_mode = true;
            edit_field = "username";
            edit_username = player_data[0];
            edit_password = player_data[1];
            edit_score = string(player_data[2]);
            edit_level = string(player_data[3]);
            original_username = player_data[0];
        } else {
            // Non-admin: if selecting own row, open Profile to edit IGN
            if (player_data[0] == logged_in_user) {
                show_profile = true;
                var self_stats_from_list = get_player_stats(logged_in_user);
                profile_edit_ign = self_stats_from_list[2];
                profile_message = "";
                profile_field = "ign";
            }
        }
    }

    // Handle Delete key (admin only)
    if (is_admin() && keyboard_check_pressed(vk_delete) && array_length(player_stats_list) > 0) {
        var player_data = player_stats_list[selected_account];
        var username_to_delete = player_data[0];
        
        if (username_to_delete == "admin") {
            show_message("Cannot delete admin account!");
        } else {
            var confirm = show_question("Delete player '" + username_to_delete + "' and all data?");
            if (confirm) {
                if (delete_account(username_to_delete)) {
                    show_message("Player '" + username_to_delete + "' deleted successfully!");
                    load_player_stats();
                    if (selected_account >= array_length(player_stats_list) && selected_account > 0) {
                        selected_account--;
                    }
                } else {
                    show_message("Failed to delete player!");
                }
            }
        }
    }

    // Handle Escape key to go back
    if (keyboard_check_pressed(vk_escape)) {
        show_player_stats = false;
    }

    // Handle mouse clicks for player stats
    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        
        // Check if clicking on a player
        for (var i = 0; i < min(array_length(player_stats_list), max_visible_accounts); i++) {
            var account_index = i + scroll_offset;
            if (account_index >= array_length(player_stats_list)) break;
            
            var account_y = center_y - 100 + (i * 35);
            
            if (mx >= center_x - 350 && mx <= center_x + 350 &&
                my >= account_y && my <= account_y + 30) {
                selected_account = account_index;
            }
        }
        
        // Check edit button (admin only)
        if (is_admin() && array_length(player_stats_list) > 0) {
            var edit_button_y = center_y + 120;
            if (mx >= center_x - 200 && mx <= center_x - 50 &&
                my >= edit_button_y && my <= edit_button_y + 30) {
                var player_data = player_stats_list[selected_account];
                edit_stats_mode = true;
                edit_field = "username";
                edit_username = player_data[0];
                edit_password = player_data[1];
                edit_score = string(player_data[2]);
                edit_level = string(player_data[3]);
                original_username = player_data[0];
            }
        }
        
        // Check delete button (admin only)
        if (is_admin() && array_length(player_stats_list) > 0) {
            var delete_button_y = center_y + 120;
            if (mx >= center_x - 25 && mx <= center_x + 25 &&
                my >= delete_button_y && my <= delete_button_y + 30) {
                
                var player_data = player_stats_list[selected_account];
                var username_to_delete = player_data[0];
                
                if (username_to_delete == "admin") {
                    show_message("Cannot delete admin account!");
                } else {
                    var confirm = show_question("Delete player '" + username_to_delete + "' and all data?");
                    if (confirm) {
                        if (delete_account(username_to_delete)) {
                            show_message("Player '" + username_to_delete + "' deleted successfully!");
                            load_player_stats();
                            if (selected_account >= array_length(player_stats_list) && selected_account > 0) {
                                selected_account--;
                            }
                        } else {
                            show_message("Failed to delete player!");
                        }
                    }
                }
            }
        }
        
        // Check back button
        var back_button_y = center_y + 160;
        if (mx >= center_x - 100 && mx <= center_x + 100 &&
            my >= back_button_y && my <= back_button_y + 30) {
            show_player_stats = false;
        }
    }
} else if (edit_stats_mode) {
    // Edit stats mode (admin only)
    if (!is_admin()) {
        edit_stats_mode = false;
        show_player_stats = false;
        return;
    }
    
    // Handle TAB to switch between fields
    if (keyboard_check_pressed(vk_tab)) {
        switch(edit_field) {
            case "username": edit_field = "password"; break;
            case "password": edit_field = "score"; break;
            case "score": edit_field = "level"; break;
            case "level": edit_field = "username"; break;
        }
    }

    // Handle text input
    if (keyboard_check_pressed(vk_anykey)) {
        var key = keyboard_lastkey;
        
        // Handle backspace
        if (keyboard_check_pressed(vk_backspace)) {
            switch(edit_field) {
                case "username":
                    if (string_length(edit_username) > 0) {
                        edit_username = string_delete(edit_username, string_length(edit_username), 1);
                    }
                    break;
                case "password":
                    if (string_length(edit_password) > 0) {
                        edit_password = string_delete(edit_password, string_length(edit_password), 1);
                    }
                    break;
                case "score":
                    if (string_length(edit_score) > 0) {
                        edit_score = string_delete(edit_score, string_length(edit_score), 1);
                    }
                    break;
                case "level":
                    if (string_length(edit_level) > 0) {
                        edit_level = string_delete(edit_level, string_length(edit_level), 1);
                    }
                    break;
            }
        }
        // Handle regular characters
        else if (key >= 32 && key <= 126 && key != ord("	") && key != vk_enter && key != vk_escape) {
            var char = chr(key);
            if (keyboard_check(vk_shift)) {
                char = string_upper(char);
            } else {
                char = string_lower(char);
            }
            
            switch(edit_field) {
                case "username":
                    if (string_length(edit_username) < 20) {
                        edit_username += char;
                    }
                    break;
                case "password":
                    if (string_length(edit_password) < 20) {
                        edit_password += char;
                    }
                    break;
                case "score":
                    // Only allow numbers for score
                    if (string_digits(char) != "" && string_length(edit_score) < 10) {
                        edit_score += char;
                    }
                    break;
                case "level":
                    // Only allow numbers for level
                    if (string_digits(char) != "" && string_length(edit_level) < 5) {
                        edit_level += char;
                    }
                    break;
            }
        }
    }

    // Handle Enter to save
    if (keyboard_check_pressed(vk_enter)) {
        if (edit_username == "" || edit_password == "" || edit_score == "" || edit_level == "") {
            show_message("All fields must be filled!");
        } else {
            var score_val = real(edit_score);
            var level_val = real(edit_level);
            
            if (level_val < 1) {
                show_message("Level must be at least 1!");
            } else if (score_val < 0) {
                show_message("Score cannot be negative!");
            } else {
                if (update_player_stats_admin(original_username, edit_username, edit_password, score_val, level_val)) {
                    show_message("Player data updated successfully!");
                    load_player_stats();
                    edit_stats_mode = false;
                    
                    // Update selected account index if username changed
                    for (var i = 0; i < array_length(player_stats_list); i++) {
                        if (player_stats_list[i][0] == edit_username) {
                            selected_account = i;
                            break;
                        }
                    }
                } else {
                    show_message("Failed to update player data! Username might already exist.");
                }
            }
        }
    }

    // Handle Escape to cancel
    if (keyboard_check_pressed(vk_escape)) {
        edit_stats_mode = false;
    }
} else if (show_accounts && !edit_mode) {
    // Account management navigation (admin only)
    if (!is_admin()) {
        show_accounts = false;
        return;
    }
    
    if (keyboard_check_pressed(vk_up)) {
        selected_account--;
        if (selected_account < 0) selected_account = array_length(accounts_list) - 1;
        
        if (selected_account < scroll_offset) {
            scroll_offset = selected_account;
        }
    }

    if (keyboard_check_pressed(vk_down)) {
        selected_account++;
        if (selected_account >= array_length(accounts_list)) selected_account = 0;
        
        if (selected_account >= scroll_offset + max_visible_accounts) {
            scroll_offset = selected_account - max_visible_accounts + 1;
        }
    }

    // Handle Enter key to edit
    if (keyboard_check_pressed(vk_enter) && array_length(accounts_list) > 0) {
        var account_data = accounts_list[selected_account];
        edit_mode = true;
        edit_field = "username";
        edit_username = account_data[0];
        edit_password = account_data[1];
        original_username = account_data[0];
    }

    // Handle Delete key
    if (keyboard_check_pressed(vk_delete) && array_length(accounts_list) > 0) {
        var account_data = accounts_list[selected_account];
        var username_to_delete = account_data[0];
        
        if (username_to_delete == "admin") {
            show_message("Cannot delete admin account!");
        } else {
            var confirm = show_question("Delete account '" + username_to_delete + "'?");
            if (confirm) {
                if (delete_account(username_to_delete)) {
                    show_message("Account '" + username_to_delete + "' deleted successfully!");
                    load_accounts();
                    if (selected_account >= array_length(accounts_list) && selected_account > 0) {
                        selected_account--;
                    }
                } else {
                    show_message("Failed to delete account!");
                }
            }
        }
    }

    // Handle Escape key to go back
    if (keyboard_check_pressed(vk_escape)) {
        show_accounts = false;
    }

    // Handle mouse clicks for account list
    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        
        // Check if clicking on an account
        for (var i = 0; i < min(array_length(accounts_list), max_visible_accounts); i++) {
            var account_index = i + scroll_offset;
            if (account_index >= array_length(accounts_list)) break;
            
            var account_y = center_y - 120 + (i * 35);
            
            if (mx >= center_x - 300 && mx <= center_x + 300 &&
                my >= account_y && my <= account_y + 30) {
                selected_account = account_index;
            }
        }
        
        // Check edit button
        if (array_length(accounts_list) > 0) {
            var edit_button_y = center_y + 140;
            if (mx >= center_x - 200 && mx <= center_x - 50 &&
                my >= edit_button_y && my <= edit_button_y + 30) {
                var account_data = accounts_list[selected_account];
                edit_mode = true;
                edit_field = "username";
                edit_username = account_data[0];
                edit_password = account_data[1];
                original_username = account_data[0];
            }
        }
        
        // Check delete button
        if (array_length(accounts_list) > 0) {
            var delete_button_y = center_y + 140;
            if (mx >= center_x - 25 && mx <= center_x + 25 &&
                my >= delete_button_y && my <= delete_button_y + 30) {
                
                var account_data = accounts_list[selected_account];
                var username_to_delete = account_data[0];
                
                if (username_to_delete == "admin") {
                    show_message("Cannot delete admin account!");
                } else {
                    var confirm = show_question("Delete account '" + username_to_delete + "'?");
                    if (confirm) {
                        if (delete_account(username_to_delete)) {
                            show_message("Account '" + username_to_delete + "' deleted successfully!");
                            load_accounts();
                            if (selected_account >= array_length(accounts_list) && selected_account > 0) {
                                selected_account--;
                            }
                        } else {
                            show_message("Failed to delete account!");
                        }
                    }
                }
            }
        }
        
        // Check back button
        var back_button_y = center_y + 180;
        if (mx >= center_x - 100 && mx <= center_x + 100 &&
            my >= back_button_y && my <= back_button_y + 30) {
            show_accounts = false;
        }
    }
} else if (edit_mode) {
    // Edit mode (admin only)
    if (!is_admin()) {
        edit_mode = false;
        show_accounts = false;
        return;
    }
    
    // Handle TAB to switch between fields
    if (keyboard_check_pressed(vk_tab)) {
        edit_field = (edit_field == "username") ? "password" : "username";
    }

    // Handle text input
    if (keyboard_check_pressed(vk_anykey)) {
        var key = keyboard_lastkey;
        
        // Handle backspace
        if (keyboard_check_pressed(vk_backspace)) {
            if (edit_field == "username" && string_length(edit_username) > 0) {
                edit_username = string_delete(edit_username, string_length(edit_username), 1);
            } else if (edit_field == "password" && string_length(edit_password) > 0) {
                edit_password = string_delete(edit_password, string_length(edit_password), 1);
            }
        }
        // Handle regular characters
        else if (key >= 32 && key <= 126 && key != ord("	") && key != vk_enter && key != vk_escape) {
            var char = chr(key);
            if (keyboard_check(vk_shift)) {
                char = string_upper(char);
            } else {
                char = string_lower(char);
            }
            
            if (edit_field == "username" && string_length(edit_username) < 20) {
                edit_username += char;
            } else if (edit_field == "password" && string_length(edit_password) < 20) {
                edit_password += char;
            }
        }
    }

    // Handle Enter to save
    if (keyboard_check_pressed(vk_enter)) {
        if (edit_username == "" || edit_password == "") {
            show_message("Username and password cannot be empty!");
        } else {
            if (update_account(original_username, edit_username, edit_password)) {
                show_message("Account updated successfully!");
                load_accounts();
                edit_mode = false;
                
                // Update selected account index if username changed
                for (var i = 0; i < array_length(accounts_list); i++) {
                    if (accounts_list[i][0] == edit_username) {
                        selected_account = i;
                        break;
                    }
                }
            } else {
                show_message("Failed to update account! Username might already exist.");
            }
        }
    }

    // Handle Escape to cancel
    if (keyboard_check_pressed(vk_escape)) {
        edit_mode = false;
    }
}
// Profile logic (all users) - edit IGN only
else if (show_profile) {
    // TAB does nothing for now since there is only one field

    // Text input
    if (keyboard_check_pressed(vk_anykey)) {
        var key = keyboard_lastkey;

        if (keyboard_check_pressed(vk_backspace)) {
            if (string_length(profile_edit_ign) > 0) {
                profile_edit_ign = string_delete(profile_edit_ign, string_length(profile_edit_ign), 1);
            }
        } else if (key >= 32 && key <= 126 && key != ord("\t") && key != vk_enter && key != vk_escape) {
            var char = chr(key);
            if (keyboard_check(vk_shift)) char = string_upper(char); else char = string_lower(char);
            if (string_length(profile_edit_ign) < 20) {
                profile_edit_ign += char;
            }
        }
    }

    // Save on ENTER
    if (keyboard_check_pressed(vk_enter)) {
        if (string_length(string_trim(profile_edit_ign)) == 0) {
            profile_message = "IGN cannot be empty";
            profile_message_color = c_red;
        } else {
            if (update_player_ign(logged_in_user, profile_edit_ign)) {
                profile_message = "IGN updated!";
                profile_message_color = c_green;
            } else {
                profile_message = "Failed to update IGN";
                profile_message_color = c_red;
            }
        }
    }

    // ESC to close
    if (keyboard_check_pressed(vk_escape)) {
        show_profile = false;
    }

    // Mouse: save/cancel buttons
    if (mouse_check_button_pressed(mb_left)) {
        var mx = mouse_x;
        var my = mouse_y;
        var btn_y = center_y + 20;

        // Save
        if (mx >= center_x - 150 && mx <= center_x - 50 && my >= btn_y && my <= btn_y + 30) {
            if (string_length(string_trim(profile_edit_ign)) == 0) {
                profile_message = "IGN cannot be empty";
                profile_message_color = c_red;
            } else {
                if (update_player_ign(logged_in_user, profile_edit_ign)) {
                    profile_message = "IGN updated!";
                    profile_message_color = c_green;
                } else {
                    profile_message = "Failed to update IGN";
                    profile_message_color = c_red;
                }
            }
        }

        // Cancel
        if (mx >= center_x + 50 && mx <= center_x + 150 && my >= btn_y && my <= btn_y + 30) {
            show_profile = false;
        }
    }
}
