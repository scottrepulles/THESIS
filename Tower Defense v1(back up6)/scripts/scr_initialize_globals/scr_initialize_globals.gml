function scr_initialize_globals(){
// Script: scr_initialize_globals

// Initialize all global variables used in the game
global.logged_in_user = "Player1";
global.current_level = 1;
global.target_stars = 0;

// You can add more global initializations here
global.game_version = "1.0";
global.sound_enabled = true;
global.music_enabled = true;

show_debug_message("Global variables initialized");

}