/// @description Initialize all game globals
/// @function scr_initialize_game()

function scr_initialize_game() {
    
    // User data
    if (!variable_global_exists("logged_in_user")) {
        global.logged_in_user = "DefaultUser";
    }
    
    // Trophy system
    if (!variable_global_exists("player_trophies")) {
        global.player_trophies = 0;
    }
    
    if (!variable_global_exists("last_trophy_change")) {
        global.last_trophy_change = 0;
    }
    
    if (!variable_global_exists("last_change_timer")) {
        global.last_change_timer = 0;
    }
    
    if (!variable_global_exists("change_display_duration")) {
        global.change_display_duration = 120;
    }
    
    // Rank system
    if (!variable_global_exists("current_rank")) {
        global.current_rank = "bronze";
    }
    
    if (!variable_global_exists("current_rank_display")) {
        global.current_rank_display = "Bronze";
    }
    
    // Level system
    if (!variable_global_exists("current_level")) {
        global.current_level = 1;
    }
    
    if (!variable_global_exists("last_level_stars")) {
        global.last_level_stars = 0;
    }
    
    if (!variable_global_exists("last_completed_level")) {
        global.last_completed_level = 0;
    }
    
    // Health system
    if (!variable_global_exists("village_hp")) {
        global.village_hp = 10;
    }
    
    show_debug_message("=== GAME INITIALIZED ===");
    show_debug_message("User: " + string(global.logged_in_user));
    show_debug_message("Trophies: " + string(global.player_trophies));
    show_debug_message("Rank: " + string(global.current_rank));
    show_debug_message("=======================");
}
