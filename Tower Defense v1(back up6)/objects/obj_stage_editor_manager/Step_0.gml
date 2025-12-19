// Stage Editor Manager - Step Event

var mx = mouse_x;
var my = mouse_y;

// Decrease warning timer
if (show_warning_timer > 0) {
    show_warning_timer--;
}

// Handle UI interactions
if (mouse_check_button_pressed(mb_left)) {
    
    // User selection buttons (clickable for viewing)
    var user_y = panel_y + 100;
    for (var i = 0; i < array_length(all_user_data); i++) {
        var btn_y = user_y + i * 35;
        if (point_in_rectangle(mx, my, panel_x + 10, btn_y, panel_x + 250, btn_y + 30)) {
            switch_view_user(all_user_data[i].username);
        }
    }
    
    // Level editing buttons (only work for editable user)
    var user_data = get_current_view_data();
    if (user_data != undefined) {
        var levels_y = panel_y + 250;
        
        for (var level = 1; level <= 10; level++) {
            var level_y = levels_y + (level - 1) * 25;
            
            // Star buttons (0, 1, 2, 3 stars)
            for (var stars = 0; stars <= 3; stars++) {
                var star_x = panel_x + 80 + stars * 30;
                if (point_in_rectangle(mx, my, star_x, level_y, star_x + 25, level_y + 20)) {
                    set_level_stars(level, stars);
                }
            }
        }
    }
    
    // Utility buttons (only work for editable user)
    var util_y = panel_y + 500;
    
    // Reset progress button
    if (point_in_rectangle(mx, my, panel_x + 10, util_y, panel_x + 100, util_y + 25)) {
        reset_current_user_progress();
    }
    
    // Unlock all button
    if (point_in_rectangle(mx, my, panel_x + 110, util_y, panel_x + 200, util_y + 25)) {
        unlock_all_levels_current_user();
    }
    
    // Test level button
    var test_y = util_y + 30;
    if (point_in_rectangle(mx, my, panel_x + 10, test_y, panel_x + 100, test_y + 25)) {
        // Set global to current view user for testing
        global.logged_in_user = current_view_user;
        room_goto(rm_level); // Replace with your stage select room
    }
    
    // Refresh data button
    if (point_in_rectangle(mx, my, panel_x + 110, test_y, panel_x + 200, test_y + 25)) {
        load_all_user_data();
    }
    
    // Switch back to editable user button
    if (point_in_rectangle(mx, my, panel_x + 10, test_y + 30, panel_x + 150, test_y + 55)) {
        switch_view_user(editable_user);
    }
}

// Keyboard shortcuts
if (keyboard_check_pressed(vk_f5)) {
    load_all_user_data(); // Refresh data
}

if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_level); // Return to stage select
}

// Quick switch with number keys
for (var i = 1; i <= 9; i++) {
    if (keyboard_check_pressed(ord(string(i)))) {
        if (i <= array_length(all_user_data)) {
            switch_view_user(all_user_data[i-1].username);
        }
    }
}
