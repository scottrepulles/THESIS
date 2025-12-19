draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Background
draw_set_color(c_dkgray);
draw_rectangle(0, 0, room_width, room_height, false);

if (!show_accounts && !show_player_stats && !show_profile) {
    // Draw main menu
    draw_set_color(c_white);
    var welcome_text = "Welcome, " + logged_in_user + "!";
    if (is_admin()) {
        welcome_text += " (ADMIN)";
        draw_set_color(c_yellow);
    }
    draw_text(center_x, center_y - 200, welcome_text);

    // Draw menu options
    for (var i = 0; i < array_length(menu_options); i++) {
        var option_y = center_y - 100 + (i * 60);
        
        // Highlight selected option
        if (i == selected_option) {
            draw_set_color(c_lime);
            draw_rectangle(center_x - button_width/2, option_y, 
                           center_x + button_width/2, option_y + 40, false);
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_gray);
            draw_rectangle(center_x - button_width/2, option_y, 
                           center_x + button_width/2, option_y + 40, false);
            draw_set_color(c_white);
        }
        
        // Button border
        draw_rectangle(center_x - button_width/2, option_y, 
                       center_x + button_width/2, option_y + 40, true);
        
        // Button text
        draw_text(center_x, option_y + 20, menu_options[i]);
    }

    // Instructions
    draw_set_color(c_ltgray);
    var instruction_text = "Use UP/DOWN arrows or mouse to navigate, ENTER to select";
    if (!is_admin()) {
        instruction_text += "\n\nLogin as 'admin' with password 'admin' to manage accounts";
    }
    draw_text(center_x, center_y + 200, instruction_text);
} else if (show_player_stats && !edit_stats_mode) {
    // Draw player stats screen (all users; non-admin read-only)
    
    draw_set_color(c_yellow);
    var stats_title = "Leaderboard - Player Statistics";
    draw_text(center_x, center_y - 250, stats_title);
    draw_set_color(c_white);
    draw_text(center_x, center_y - 220, "Total Players: " + string(array_length(player_stats_list)));
    
    if (array_length(player_stats_list) == 0) {
        draw_set_color(c_red);
        draw_text(center_x, center_y, "No players found!");
    } else {
        // Draw table headers
        draw_set_halign(fa_left);
        draw_set_color(c_yellow);
        // Always show IGN only in leaderboard
        draw_text(center_x - 380, center_y - 150, "IGN");
        draw_text(center_x - 100, center_y - 150, "TROPHY");
        draw_text(center_x + 40, center_y - 150, "LEVEL");
        draw_text(center_x + 140, center_y - 150, "RANK");
        draw_text(center_x + 240, center_y - 150, "STATUS");
        
        // Draw separator line
        draw_set_color(c_white);
        draw_line(center_x - 390, center_y - 135, center_x + 390, center_y - 135);
        
        // Draw player stats list
        for (var i = 0; i < min(array_length(player_stats_list), max_visible_accounts); i++) {
            var account_index = i + scroll_offset;
            if (account_index >= array_length(player_stats_list)) break;
            
            var account_y = center_y - 110 + (i * 35);
            var player_data = player_stats_list[account_index];
            var username = player_data[0];
            var password = player_data[1];
            var trophy = player_data[2];
            var level = player_data[3];
            var ign = player_data[4];
            var rank = get_rank_from_trophy(trophy);
            
            // Highlight selected player
            if (account_index == selected_account) {
                draw_set_color(c_yellow);
                draw_rectangle(center_x - 390, account_y - 5, center_x + 390, account_y + 25, false);
                draw_set_color(c_black);
            } else {
                // Color coding
                if (username == "admin") {
                    draw_set_color(c_red); // Admin in red
                } else if (username == logged_in_user) {
                    draw_set_color(c_lime); // Current user in green
                } else {
                    draw_set_color(c_white); // Others in white
                }
            }
            
            // Draw identifier: always IGN in leaderboard
            draw_text(center_x - 380, account_y + 10, ign);
            
            // Remove password column from leaderboard entirely
            
            // Draw trophy
            draw_text(center_x - 100, account_y + 10, string(trophy));
            
            // Draw level
            draw_text(center_x + 40, account_y + 10, string(level));
            
            // Draw rank with sprite if available; else colored text
            var rank_sprite = get_rank_sprite(rank);
            if (rank_sprite != -1) {
                draw_sprite_ext(rank_sprite, 0, center_x + 140, account_y + 10, 0.5, 0.5, 0, c_white, 1);
            } else {
                var rank_color = get_rank_color(rank);
                draw_set_color(rank_color);
                draw_text(center_x + 140, account_y + 10, rank);
            }
            
            // Reset color for status
            if (account_index == selected_account) {
                draw_set_color(c_black);
            } else {
                draw_set_color(c_white);
            }
            
            // Draw status
            var status_text = "";
            if (username == "admin") {
                status_text = "ADMIN";
            } else if (username == logged_in_user) {
                status_text = "LOGGED IN";
            } else {
                status_text = "OFFLINE";
            }
            draw_text(center_x + 240, account_y + 10, status_text);
        }
        
        // Draw scroll indicator
        if (array_length(player_stats_list) > max_visible_accounts) {
            draw_set_halign(fa_center);
            draw_set_color(c_ltgray);
            draw_text(center_x + 450, center_y - 50, "Page: " + string(scroll_offset + 1) + "/" + string(max(1, array_length(player_stats_list) - max_visible_accounts + 1)));
        }
        
        // Common Y for buttons/selected info
        draw_set_halign(fa_center);
        var btn_y = center_y + 120;

        // Draw action buttons (admin only)
        if (is_admin()) {
            
            // Edit button
            draw_set_color(c_blue);
            draw_rectangle(center_x - 200, btn_y, center_x - 50, btn_y + 30, false);
            draw_set_color(c_white);
            draw_rectangle(center_x - 200, btn_y, center_x - 50, btn_y + 30, true);
            draw_text(center_x - 125, btn_y + 15, "EDIT");
            
            // Delete button
            var can_delete = (array_length(player_stats_list) > 0 && player_stats_list[selected_account][0] != "admin");
            draw_set_color(can_delete ? c_red : c_dkgray);
            draw_rectangle(center_x - 25, btn_y, center_x + 25, btn_y + 30, false);
            draw_set_color(c_white);
            draw_rectangle(center_x - 25, btn_y, center_x + 25, btn_y + 30, true);
            draw_text(center_x, btn_y + 15, "DEL");
        }
        
        // Show selected player info with rank
        if (array_length(player_stats_list) > 0) {
            var selected_data = player_stats_list[selected_account];
            var selected_rank = get_rank_from_trophy(selected_data[2]);
            var selected_rank_color = get_rank_color(selected_rank);
            
            var selected_name = is_admin() ? selected_data[0] : selected_data[4]; // username or IGN
            draw_set_color(c_ltgray);
            draw_text(center_x, btn_y - 40, "Selected: " + selected_name + " | Trophy: " + string(selected_data[2]) + " | Level: " + string(selected_data[3]));
            
            // Draw rank with sprite if available; else colored text
            var selected_rank_sprite = get_rank_sprite(selected_rank);
            if (selected_rank_sprite != -1) {
                draw_sprite_ext(selected_rank_sprite, 0, center_x, btn_y - 20, 0.6, 0.6, 0, c_white, 1);
            } else {
                draw_set_color(selected_rank_color);
                draw_text(center_x, btn_y - 20, "Rank: " + selected_rank);
            }
        }
    }
    
    // Draw back button
    var back_btn_y = center_y + 160;
    draw_set_color(c_blue);
    draw_rectangle(center_x - 100, back_btn_y, center_x + 100, back_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x - 100, back_btn_y, center_x + 100, back_btn_y + 30, true);
    draw_text(center_x, back_btn_y + 15, "BACK TO MENU");
    
    // Instructions
    draw_set_color(c_ltgray);
    if (is_admin()) {
        draw_text(center_x, center_y + 200, "UP/DOWN: Navigate | ENTER: Edit | DELETE: Delete | ESC: Back");
    } else {
        draw_text(center_x, center_y + 200, "UP/DOWN: Navigate | ENTER: Edit Own IGN | ESC: Back");
    }
    
    // Draw rank legend with sprites if available
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 220, "Rank System:");
    var ly = center_y + 240;
    var xb = center_x - 200;
    var xs = center_x - 60;
    var xg = center_x + 80;
    var xp = center_x + 220;
    var spr_b = get_rank_sprite("Bronze");
    var spr_s = get_rank_sprite("Silver");
    var spr_g = get_rank_sprite("Gold");
    var spr_p = get_rank_sprite("Platinum");
    if (spr_b != -1) draw_sprite_ext(spr_b, 0, xb, ly, 0.5, 0.5, 0, c_white, 1) else { draw_set_color(get_rank_color("Bronze")); draw_text(xb, ly, "Bronze"); }
    if (spr_s != -1) draw_sprite_ext(spr_s, 0, xs, ly, 0.5, 0.5, 0, c_white, 1) else { draw_set_color(get_rank_color("Silver")); draw_text(xs, ly, "Silver"); }
    if (spr_g != -1) draw_sprite_ext(spr_g, 0, xg, ly, 0.5, 0.5, 0, c_white, 1) else { draw_set_color(get_rank_color("Gold")); draw_text(xg, ly, "Gold"); }
    if (spr_p != -1) draw_sprite_ext(spr_p, 0, xp, ly, 0.5, 0.5, 0, c_white, 1) else { draw_set_color(get_rank_color("Platinum")); draw_text(xp, ly, "Platinum"); }
    draw_set_color(c_ltgray);
    draw_text(center_x, ly + 20, "Bronze (0-999)  |  Silver (1000-1999)  |  Gold (2000-3999)  |  Platinum (4000+)");
    
} else if (edit_stats_mode) {
    // Draw edit stats mode (admin only)
    if (!is_admin()) return;
    
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(center_x, center_y - 200, "ADMIN - Edit Player: " + original_username);
    
    // Username field
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(center_x - 200, center_y - 140, "Username:");
    
    var user_color = edit_field == "username" ? c_yellow : c_white;
    draw_set_color(user_color);
    draw_rectangle(center_x - 200, center_y - 120, center_x + 200, center_y - 90, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y - 105, edit_username);
    
    // Password field
    draw_text(center_x - 200, center_y - 80, "Password:");
    
    var pass_color = edit_field == "password" ? c_yellow : c_white;
    draw_set_color(pass_color);
    draw_rectangle(center_x - 200, center_y - 60, center_x + 200, center_y - 30, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y - 45, edit_password);
    
    // Trophy field (changed from Score)
    draw_text(center_x - 200, center_y - 20, "Trophy:");
    
    var trophy_color = edit_field == "score" ? c_yellow : c_white;
    draw_set_color(trophy_color);
    draw_rectangle(center_x - 200, center_y, center_x + 200, center_y + 30, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y + 15, edit_score);
    
    // Show current rank for trophy, with sprite fallback
    if (edit_score != "" && is_string(edit_score)) {
        var trophy_val = real(edit_score);
        var current_rank = get_rank_from_trophy(trophy_val);
        var rank_sprite2 = get_rank_sprite(current_rank);
        if (rank_sprite2 != -1) {
            draw_sprite_ext(rank_sprite2, 0, center_x + 250, center_y + 15, 0.5, 0.5, 0, c_white, 1);
        } else {
            var rank_color = get_rank_color(current_rank);
            draw_set_color(rank_color);
            draw_text(center_x + 210, center_y + 15, "(" + current_rank + ")");
        }
    }
    
    // Level field
    draw_set_color(c_white);
    draw_text(center_x - 200, center_y + 40, "Level:");
    
    var lvl_color = edit_field == "level" ? c_yellow : c_white;
    draw_set_color(lvl_color);
    draw_rectangle(center_x - 200, center_y + 60, center_x + 200, center_y + 90, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y + 75, edit_level);
    
    // Action buttons
    draw_set_halign(fa_center);
    var save_btn_y = center_y + 120;
    
    // Save button
    draw_set_color(c_green);
    draw_rectangle(center_x - 150, save_btn_y, center_x - 50, save_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x - 150, save_btn_y, center_x - 50, save_btn_y + 30, true);
    draw_text(center_x - 100, save_btn_y + 15, "SAVE");
    
    // Cancel button
    draw_set_color(c_red);
    draw_rectangle(center_x + 50, save_btn_y, center_x + 150, save_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x + 50, save_btn_y, center_x + 150, save_btn_y + 30, true);
    draw_text(center_x + 100, save_btn_y + 15, "CANCEL");
    
    // Instructions
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 170, "TAB: Switch field | ENTER: Save | ESC: Cancel");
    draw_text(center_x, center_y + 190, "Trophy/Level: Numbers only");
    
    // Show current field indicator
    draw_set_color(c_yellow);
    var field_name = "";
    switch(edit_field) {
        case "username": field_name = "USERNAME"; break;
        case "password": field_name = "PASSWORD"; break;
        case "score": field_name = "TROPHY"; break;
        case "level": field_name = "LEVEL"; break;
        default: field_name = "UNKNOWN"; break;
    }
    draw_text(center_x, center_y + 210, "Editing: " + field_name);
    
    // Show rank system info
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 230, "Rank System: Bronze (0-999) | Silver (1000-1999) | Gold (2000-3999) | Platinum (4000+)");
    
} else if (show_accounts && !edit_mode) {
    // Draw account management screen (admin only) - unchanged
    if (!is_admin()) return;
    
    draw_set_color(c_yellow);
    draw_text(center_x, center_y - 250, "ADMIN - Account Management");
    draw_set_color(c_white);
    draw_text(center_x, center_y - 220, "Total Accounts: " + string(array_length(accounts_list)));
    
    if (array_length(accounts_list) == 0) {
        draw_set_color(c_red);
        draw_text(center_x, center_y, "No accounts found!");
    } else {
        // Draw table headers
        draw_set_halign(fa_left);
        draw_set_color(c_yellow);
        draw_text(center_x - 290, center_y - 170, "USERNAME");
        draw_text(center_x - 50, center_y - 170, "PASSWORD");
        draw_text(center_x + 150, center_y - 170, "STATUS");
        
        // Draw separator line
        draw_set_color(c_white);
        draw_line(center_x - 300, center_y - 155, center_x + 300, center_y - 155);
        
        // Draw account list
        for (var i = 0; i < min(array_length(accounts_list), max_visible_accounts); i++) {
            var account_index = i + scroll_offset;
            if (account_index >= array_length(accounts_list)) break;
            
            var account_y = center_y - 130 + (i * 35);
            var account_data = accounts_list[account_index];
            var username = account_data[0];
            var password = account_data[1];
            
            // Highlight selected account
            if (account_index == selected_account) {
                draw_set_color(c_yellow);
                draw_rectangle(center_x - 300, account_y - 5, center_x + 300, account_y + 25, false);
                draw_set_color(c_black);
            } else {
                // Color coding
                if (username == "admin") {
                    draw_set_color(c_red); // Admin in red
                } else if (username == logged_in_user) {
                    draw_set_color(c_lime); // Current user in green
                } else {
                    draw_set_color(c_white); // Others in white
                }
            }
            
            // Draw username
            draw_text(center_x - 290, account_y + 10, username);
            
            // Draw password
            draw_text(center_x - 50, account_y + 10, password);
            
            // Draw status
            var status_text = "";
            if (username == "admin") {
                status_text = "ADMIN";
            } else if (username == logged_in_user) {
                status_text = "LOGGED IN";
            } else {
                status_text = "OFFLINE";
            }
            draw_text(center_x + 150, account_y + 10, status_text);
        }
        
        // Draw scroll indicator
        if (array_length(accounts_list) > max_visible_accounts) {
            draw_set_halign(fa_center);
            draw_set_color(c_ltgray);
            draw_text(center_x + 350, center_y - 50, "Page: " + string(scroll_offset + 1) + "/" + string(max(1, array_length(accounts_list) - max_visible_accounts + 1)));
        }
        
        // Draw action buttons
        draw_set_halign(fa_center);
        var btn_y = center_y + 140;
        
        // Edit button
        draw_set_color(c_blue);
        draw_rectangle(center_x - 200, btn_y, center_x - 50, btn_y + 30, false);
        draw_set_color(c_white);
        draw_rectangle(center_x - 200, btn_y, center_x - 50, btn_y + 30, true);
        draw_text(center_x - 125, btn_y + 15, "EDIT");
        
        // Delete button
        var can_delete = (array_length(accounts_list) > 0 && accounts_list[selected_account][0] != "admin");
        draw_set_color(can_delete ? c_red : c_dkgray);
        draw_rectangle(center_x - 25, btn_y, center_x + 25, btn_y + 30, false);
        draw_set_color(c_white);
        draw_rectangle(center_x - 25, btn_y, center_x + 25, btn_y + 30, true);
        draw_text(center_x, btn_y + 15, "DEL");
        
        // Show selected account info
        if (array_length(accounts_list) > 0) {
            var selected_data = accounts_list[selected_account];
            draw_set_color(c_ltgray);
            draw_text(center_x, btn_y - 20, "Selected: " + selected_data[0] + " | Password: " + selected_data[1]);
        }
    }
    
    // Draw back button
    var back_btn_y = center_y + 180;
    draw_set_color(c_blue);
    draw_rectangle(center_x - 100, back_btn_y, center_x + 100, back_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x - 100, back_btn_y, center_x + 100, back_btn_y + 30, true);
    draw_text(center_x, back_btn_y + 15, "BACK TO MENU");
    
    // Instructions
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 240, "UP/DOWN: Navigate | ENTER: Edit | DELETE: Delete | ESC: Back");
} else if (edit_mode) {
    // Draw edit mode (admin only) - unchanged
    if (!is_admin()) return;
    
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(center_x, center_y - 200, "ADMIN - Edit Account: " + original_username);
    
    // Username field
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(center_x - 200, center_y - 120, "Username:");
    
    var user_color = edit_field == "username" ? c_yellow : c_white;
    draw_set_color(user_color);
    draw_rectangle(center_x - 200, center_y - 100, center_x + 200, center_y - 70, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y - 85, edit_username);
    
    // Password field
    draw_text(center_x - 200, center_y - 50, "Password:");
    
    var pass_color = edit_field == "password" ? c_yellow : c_white;
    draw_set_color(pass_color);
    draw_rectangle(center_x - 200, center_y - 30, center_x + 200, center_y, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y - 15, edit_password);
    
    // Action buttons
    draw_set_halign(fa_center);
    var save_btn_y = center_y + 50;
    
    // Save button
    draw_set_color(c_green);
    draw_rectangle(center_x - 150, save_btn_y, center_x - 50, save_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x - 150, save_btn_y, center_x - 50, save_btn_y + 30, true);
    draw_text(center_x - 100, save_btn_y + 15, "SAVE");
    
    // Cancel button
    draw_set_color(c_red);
    draw_rectangle(center_x + 50, save_btn_y, center_x + 150, save_btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x + 50, save_btn_y, center_x + 150, save_btn_y + 30, true);
    draw_text(center_x + 100, save_btn_y + 15, "CANCEL");
    
    // Instructions
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 120, "TAB: Switch field | ENTER: Save | ESC: Cancel");
    
    // Show current field indicator
    draw_set_color(c_yellow);
    var field_name = (edit_field == "username") ? "USERNAME" : "PASSWORD";
    draw_text(center_x, center_y + 140, "Editing: " + field_name);
}
// Profile screen (all users) - edit IGN only
else if (show_profile) {
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(center_x, center_y - 200, "Profile - " + logged_in_user);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    // Immutable username (login identifier)
    draw_text(center_x - 200, center_y - 160, "Username (login):");
    draw_set_color(c_ltgray);
    draw_text(center_x - 20, center_y - 160, logged_in_user);
    draw_set_color(c_white);

    // Current stats and rank
    var self_stats = get_player_stats(logged_in_user); // [score, level, ign]
    var self_rank = get_rank_from_trophy(self_stats[0]);
    var self_rank_col = get_rank_color(self_rank);
    draw_text(center_x - 200, center_y - 140, "Trophy: " + string(self_stats[0]) + "   Level: " + string(self_stats[1]));
    // Rank sprite if available, else colored text
    var self_rank_sprite = get_rank_sprite(self_rank);
    if (self_rank_sprite != -1) {
        draw_sprite_ext(self_rank_sprite, 0, center_x + 180, center_y - 140, 0.5, 0.5, 0, c_white, 1);
    } else {
        draw_set_color(self_rank_col);
        draw_text(center_x + 140, center_y - 140, "Rank: " + self_rank);
    }
    draw_set_color(c_white);

    // Editable IGN
    draw_text(center_x - 200, center_y - 120, "IGN:");

    var ign_color = profile_field == "ign" ? c_yellow : c_white;
    draw_set_color(ign_color);
    draw_rectangle(center_x - 200, center_y - 100, center_x + 200, center_y - 70, true);
    draw_set_color(c_white);
    draw_text(center_x - 195, center_y - 85, profile_edit_ign);

    // Buttons
    draw_set_halign(fa_center);
    var btn_y = center_y + 20;

    draw_set_color(c_green);
    draw_rectangle(center_x - 150, btn_y, center_x - 50, btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x - 150, btn_y, center_x - 50, btn_y + 30, true);
    draw_text(center_x - 100, btn_y + 15, "SAVE");

    draw_set_color(c_red);
    draw_rectangle(center_x + 50, btn_y, center_x + 150, btn_y + 30, false);
    draw_set_color(c_white);
    draw_rectangle(center_x + 50, btn_y, center_x + 150, btn_y + 30, true);
    draw_text(center_x + 100, btn_y + 15, "CANCEL");

    // Message and instructions
    if (profile_message != "") {
        draw_set_color(profile_message_color);
        draw_text(center_x, center_y + 70, profile_message);
    }
    draw_set_color(c_ltgray);
    draw_text(center_x, center_y + 100, "Type to edit | ENTER: Save | ESC: Back");
    draw_text(center_x, center_y + 120, "Only your IGN is shown on the leaderboard. Username cannot be changed.");
}
