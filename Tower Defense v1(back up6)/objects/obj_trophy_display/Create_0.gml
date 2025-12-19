/// @description Create Event - Initialize Trophy Display

// Flag to track if trophies have been loaded from file
trophies_loaded = false;

// Initialize global variables if they don't exist
if (!variable_global_exists("player_trophies")) {
    global.player_trophies = 0;
}

if (!variable_global_exists("logged_in_user")) {
    global.logged_in_user = "DefaultUser";
}

if (!variable_global_exists("last_trophy_change")) {
    global.last_trophy_change = 0;
}

if (!variable_global_exists("last_change_timer")) {
    global.last_change_timer = 0;
}

if (!variable_global_exists("change_display_duration")) {
    global.change_display_duration = 120; // 2 seconds at 60fps
}

show_debug_message("Trophy Display Object Created");
