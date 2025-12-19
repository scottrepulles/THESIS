/// @description Draw Trophy Display - Reads from file

// Load trophies from file if not already loaded or needs refresh
if (!variable_global_exists("player_trophies") || global.player_trophies == undefined) {
    global.player_trophies = 0;
}

// Load from file periodically or on first draw
if (!variable_instance_exists(id, "trophies_loaded")) {
    trophies_loaded = false;
}

if (!trophies_loaded) {
    // Load trophies from file
    var trophy_file = "player_trophies.txt";
    
    // Ensure user exists
    if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
        global.logged_in_user = "DefaultUser";
    }
    
    // Read trophy data from file
    if (file_exists(trophy_file)) {
        var file = file_text_open_read(trophy_file);
        
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "" && string_length(line) > 0) {
                var data = string_split(line, ",");
                
                if (array_length(data) >= 2 && data[0] == global.logged_in_user) {
                    // Found current user's trophies
                    global.player_trophies = real(data[1]);
                    show_debug_message("Trophies loaded from file: " + string(global.player_trophies));
                    break;
                }
            }
        }
        
        file_text_close(file);
    } else {
        show_debug_message("Trophy file not found, starting with 0 trophies");
        global.player_trophies = 0;
    }
    
    trophies_loaded = true;
}

// HUD positioning
var xx = 48;
var yy = 48;

// Decide rank and color based on trophies
var rank_color;
var current_rank;

if (global.player_trophies < 500) {
    current_rank = "Bronze";
    rank_color = make_color_rgb(139, 69, 19); // brownish
} else if (global.player_trophies < 1000) {
    current_rank = "Silver";
    rank_color = make_color_rgb(180, 180, 180); // silver-ish
} else if (global.player_trophies < 2000) {
    current_rank = "Gold";
    rank_color = make_color_rgb(255, 200, 0); // gold-ish
} else {
    current_rank = "Platinum";
    rank_color = make_color_rgb(135, 206, 250); // light blue
}

// Store current rank in global variable
global.current_rank_display = current_rank;

// Draw trophy sprite if you have one (name spr_trophy)
if (sprite_exists(spr_trophy)) {
    draw_sprite(spr_trophy, 0, xx - 12, yy - 12);
}

// Draw trophies number (right of the badge)
draw_set_font(fnt_menu); // replace with your font
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(xx + 40, yy, string(global.player_trophies));

// Draw rank text (optional, under the number)
draw_set_font(fnt_menu);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(rank_color); // Use rank color instead of white
draw_text(xx + 40, yy + 12, current_rank);

// --- Show last_trophy_change with fade ---
if (variable_global_exists("last_trophy_change") && variable_global_exists("last_change_timer")) {
    if (global.last_trophy_change != 0 && global.last_change_timer > 0) {
        var pct = global.last_change_timer / max(1, global.change_display_duration); // 0..1
        var alpha = pct; // fade from 1 -> 0

        // Format change text
        var change_text = (global.last_trophy_change > 0) ? "+" + string(global.last_trophy_change) : string(global.last_trophy_change);
        var change_color = (global.last_trophy_change > 0) ? make_color_rgb(50, 200, 50) : make_color_rgb(220, 50, 50);

        draw_set_alpha(alpha);
        draw_set_font(fnt_menu);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(change_color);
        draw_text(xx + 40, yy - 20, change_text);
        draw_set_alpha(1); // reset
    }
}

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
