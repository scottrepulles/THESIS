// Stage Editor Manager - Draw Event

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw main panel
draw_set_color(c_dkgray);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height + 100, false);
draw_set_color(c_white);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height + 100, true);

// Title
draw_set_color(c_yellow);
draw_text(panel_x + 10, panel_y + 10, "STAGE LEVEL EDITOR");

// Instructions
draw_set_color(c_ltgray);
draw_text(panel_x + 10, panel_y + 30, "F5: Refresh | ESC: Exit | 1-9: Quick Switch");

// Current status
draw_set_color(c_lime);
draw_text(panel_x + 10, panel_y + 50, "Logged In: " + editable_user + " (Can Edit)");
draw_set_color(c_aqua); // Changed from c_cyan to c_aqua
draw_text(panel_x + 10, panel_y + 65, "Viewing: " + current_view_user + (is_current_view_editable() ? " (Editable)" : " (View Only)"));

// Warning message
if (show_warning_timer > 0) {
    draw_set_color(c_red);
    draw_rectangle(panel_x + 5, panel_y + 75, panel_x + panel_width - 5, panel_y + 95, false);
    draw_set_color(c_white);
    draw_text(panel_x + 10, panel_y + 78, "⚠ Cannot edit " + current_view_user + "! Only " + editable_user + " is editable.");
}

// User selection (clickable)
draw_set_color(c_white);
draw_text(panel_x + 10, panel_y + 100, "Select User to View (Click to Switch):");

var user_y = panel_y + 120;
for (var i = 0; i < array_length(all_user_data); i++) {
    var user = all_user_data[i];
    var btn_y = user_y + i * 35;
    
    // Button background
    if (user.username == current_view_user) {
        // Currently viewed user
        draw_set_color(user.username == editable_user ? c_green : c_blue);
        draw_rectangle(panel_x + 10, btn_y, panel_x + 250, btn_y + 30, false);
    } else {
        // Other users
        draw_set_color(user.username == editable_user ? c_dkgray : c_black);
        draw_rectangle(panel_x + 10, btn_y, panel_x + 250, btn_y + 30, false);
    }
    
    // Hover effect
    if (point_in_rectangle(mouse_x, mouse_y, panel_x + 10, btn_y, panel_x + 250, btn_y + 30)) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_rectangle(panel_x + 10, btn_y, panel_x + 250, btn_y + 30, false);
        draw_set_alpha(1);
    }
    
    // Button border
    draw_set_color(user.username == current_view_user ? c_white : c_gray);
    if (user.username == editable_user) {
        draw_set_color(c_lime); // Special border for editable user
    }
    draw_rectangle(panel_x + 10, btn_y, panel_x + 250, btn_y + 30, true);
    
    // User info
    var info_color = c_white;
    if (user.username == current_view_user) {
        info_color = c_white;
    } else if (user.username == editable_user) {
        info_color = c_ltgray;
    } else {
        info_color = c_gray;
    }
    
    draw_set_color(info_color);
    
    // User name with icons
    var user_text = string(i + 1) + ". " + user.username;
    if (user.username == editable_user) {
        user_text += " [EDIT]"; // Changed from ✎ to text
    } else {
        user_text += " [VIEW]"; // Changed from 👁 to text
    }
    
    if (user.username == current_view_user) {
        user_text += " <--"; // Changed from ◄ to text arrow
    }
    
    // Progress info
    var completed = 0;
    for (var j = 0; j < 10; j++) {
        if (user.levels[j] > 0) completed++;
    }
    user_text += " (" + string(completed) + "/10)";
    
    draw_text(panel_x + 15, btn_y + 8, user_text);
}

// Level editing section
var user_data = get_current_view_data();
if (user_data != undefined) {
    var edit_color = is_current_view_editable() ? c_lime : c_orange;
    draw_set_color(edit_color);
    var edit_text = is_current_view_editable() ? "Edit Levels:" : "View Levels (Read-Only):";
    draw_text(panel_x + 10, panel_y + 230, edit_text);
    
    var levels_y = panel_y + 250;
    draw_set_color(c_white);
    draw_text(panel_x + 10, levels_y - 20, "Level    0*  1*  2*  3*"); // Changed ★ to *
    
    for (var level = 1; level <= 10; level++) {
        var level_y = levels_y + (level - 1) * 25;
        var current_stars = user_data.levels[level - 1];
        
        // Level number
        draw_set_color(c_white);
        draw_text(panel_x + 10, level_y + 2, "Level " + string(level) + ":");
        
        // Star buttons
        for (var stars = 0; stars <= 3; stars++) {
            var star_x = panel_x + 80 + stars * 30;
            
            // Button background
            var btn_color = c_gray;
            if (current_stars == stars) {
                btn_color = is_current_view_editable() ? c_green : c_blue;
            } else if (!is_current_view_editable()) {
                btn_color = c_dkgray; // Darker for non-editable
            }
            
            draw_set_color(btn_color);
            draw_rectangle(star_x, level_y, star_x + 25, level_y + 20, false);
            
            // Hover effect (only for editable user)
            if (is_current_view_editable() && point_in_rectangle(mouse_x, mouse_y, star_x, level_y, star_x + 25, level_y + 20)) {
                draw_set_color(c_yellow);
                draw_set_alpha(0.5);
                draw_rectangle(star_x, level_y, star_x + 25, level_y + 20, false);
                draw_set_alpha(1);
            }
            
            // Button border
            draw_set_color(is_current_view_editable() ? c_white : c_gray);
            draw_rectangle(star_x, level_y, star_x + 25, level_y + 20, true);
            
            // Star text
            draw_set_halign(fa_center);
            draw_set_color(c_white);
            if (stars == 0) {
                draw_text(star_x + 12, level_y + 2, "0");
            } else {
                var star_text = "";
                repeat(stars) star_text += "*"; // Changed ★ to *
                draw_text(star_x + 12, level_y + 2, star_text);
            }
            draw_set_halign(fa_left);
        }
    }
}

// Utility buttons
var util_y = panel_y + 500;
var btn_alpha = is_current_view_editable() ? 1.0 : 0.5;

// Reset progress button
draw_set_alpha(btn_alpha);
draw_set_color(is_current_view_editable() ? c_red : c_dkgray);
draw_rectangle(panel_x + 10, util_y, panel_x + 100, util_y + 25, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(panel_x + 10, util_y, panel_x + 100, util_y + 25, true);
draw_set_halign(fa_center);
draw_text(panel_x + 55, util_y + 5, "Reset All");

// Unlock all button
draw_set_alpha(btn_alpha);
draw_set_color(is_current_view_editable() ? c_green : c_dkgray);
draw_rectangle(panel_x + 110, util_y, panel_x + 200, util_y + 25, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(panel_x + 110, util_y, panel_x + 200, util_y + 25, true);
draw_text(panel_x + 155, util_y + 5, "Unlock All");

// Test button
var test_y = util_y + 30;
draw_set_color(c_purple);
draw_rectangle(panel_x + 10, test_y, panel_x + 100, test_y + 25, false);
draw_set_color(c_white);
draw_rectangle(panel_x + 10, test_y, panel_x + 100, test_y + 25, true);
draw_text(panel_x + 55, test_y + 5, "Test as " + current_view_user);

// Refresh button
draw_set_color(c_blue);
draw_rectangle(panel_x + 110, test_y, panel_x + 200, test_y + 25, false);
draw_set_color(c_white);
draw_rectangle(panel_x + 110, test_y, panel_x + 200, test_y + 25, true);
draw_text(panel_x + 155, test_y + 5, "Refresh");

// Back to editable user button (only show if viewing someone else)
if (!is_current_view_editable()) {
    var back_y = test_y + 30;
    draw_set_color(c_lime);
    draw_rectangle(panel_x + 10, back_y, panel_x + 150, back_y + 25, false);
    draw_set_color(c_white);
    draw_rectangle(panel_x + 10, back_y, panel_x + 150, back_y + 25, true);
    draw_text(panel_x + 80, back_y + 5, "Edit " + editable_user);
}

draw_set_halign(fa_left);

// Live preview section
var preview_x = panel_x + panel_width + 20;
var preview_y = panel_y;

draw_set_color(c_white);
draw_text(preview_x, preview_y, "Live Preview:");
draw_set_color(is_current_view_editable() ? c_lime : c_aqua); // Changed c_cyan to c_aqua
draw_text(preview_x, preview_y + 20, "User: " + current_view_user);
draw_set_color(is_current_view_editable() ? c_lime : c_orange);
draw_text(preview_x, preview_y + 35, is_current_view_editable() ? "(Editable)" : "(View Only)");

// Show unlock status for each level
if (user_data != undefined) {
    for (var i = 1; i <= 10; i++) {
        var py = preview_y + 60 + i * 20;
        var stars = user_data.levels[i - 1];
        var unlocked = (i == 1) || (i > 1 && user_data.levels[i - 2] > 0);
        
        var status_text = "Level " + string(i) + ": ";
        if (!unlocked) {
            draw_set_color(c_red);
            status_text += "LOCKED";
        } else if (stars == 0) {
            draw_set_color(c_yellow);
            status_text += "AVAILABLE";
        } else {
            draw_set_color(c_lime);
            status_text += string(stars) + " STARS";
        }
        
        draw_text(preview_x, py, status_text);
    }
}

// Instructions
draw_set_color(c_ltgray);
draw_text(preview_x, preview_y + 300, "CONTROLS:");
draw_text(preview_x, preview_y + 320, "• Click user to switch view");
draw_text(preview_x, preview_y + 335, "• Press 1-9 for quick switch");
draw_text(preview_x, preview_y + 350, "• Only logged-in user editable");
draw_text(preview_x, preview_y + 365, "• Others are view-only");

draw_set_color(c_white);
