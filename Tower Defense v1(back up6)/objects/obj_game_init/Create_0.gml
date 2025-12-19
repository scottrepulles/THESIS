// Initialize audio settings
global.music_enabled = true;
global.sfx_enabled = true;
global.music_volume = 0.7;  // 0.0 to 1.0
global.sfx_volume = 0.8;
global.current_music = noone;  // ADD T

// Load saved settings
ini_open("game_settings.ini");
global.music_enabled = ini_read_real("Audio", "music_enabled", 1);
global.sfx_enabled = ini_read_real("Audio", "sfx_enabled", 1);
global.music_volume = ini_read_real("Audio", "music_volume", 0.7);
global.sfx_volume = ini_read_real("Audio", "sfx_volume", 0.8);
ini_close();

// Apply settings
audio_group_set_gain(audiogroup_default, global.sfx_volume, 0);

// Load Supabase config (kept outside code in supabase.ini)
ini_open("supabase.ini");
global.supabase_url  = ini_read_string("Supabase", "url", "");
global.supabase_key  = ini_read_string("Supabase", "anon_key", "");
global.supabase_table = ini_read_string("Supabase", "table", "leaderboard");
ini_close();


// Load player trophies from file
scr_load_player_trophies();

show_debug_message("Game initialized with " + string(global.player_trophies) + " trophies");