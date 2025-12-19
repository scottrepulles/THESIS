/// @description Universal Rank Room Initialization

// Safety check - initialize everything
if (!variable_global_exists("player_trophies")) global.player_trophies = 0;
if (!variable_global_exists("logged_in_user")) global.logged_in_user = "DefaultUser";
if (!variable_global_exists("current_rank")) global.current_rank = "bronze";

// Load trophies from file if function exists
if (script_exists(scr_load_player_trophies)) {
    scr_load_player_trophies();
} else {
    show_debug_message("Warning: scr_load_player_trophies doesn't exist");
}

// Set room-specific rank
var room_name = room_get_name(room);
if (string_pos("bronze", room_name) > 0) {
    global.current_rank = "bronze";
} else if (string_pos("silver", room_name) > 0) {
    global.current_rank = "silver";
} else if (string_pos("gold", room_name) > 0) {
    global.current_rank = "gold";
} else if (string_pos("platinum", room_name) > 0) {
    global.current_rank = "platinum";
}

show_debug_message("Room " + room_name + " initialized successfully");
