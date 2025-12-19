/// @description rm_rank_bronze_2 - Room Creation Code

show_debug_message("=== ENTERING rm_rank_bronze_2 ===");

// ===== ENSURE REQUIRED LAYERS EXIST =====
var required_layers = ["Sequences", "Instances", "Background"];

for (var i = 0; i < array_length(required_layers); i++) {
    var layer_name = required_layers[i];
    var layer_id = layer_get_id(layer_name);
    
    if (layer_id == -1) {
        show_debug_message("Creating missing layer: " + layer_name);
        
        var depth_value = 0;
        switch(layer_name) {
            case "Sequences":
                depth_value = -1000;
                break;
            case "Instances":
                depth_value = 0;
                break;
            case "Background":
                depth_value = 1000;
                break;
        }
        
        layer_create(depth_value, layer_name);
    }
}

// ===== INITIALIZE GLOBAL VARIABLES MANUALLY =====
// (In case script doesn't exist or fails)

if (!variable_global_exists("logged_in_user")) {
    global.logged_in_user = "DefaultUser";
}

if (!variable_global_exists("player_trophies")) {
    global.player_trophies = 0;
}

if (!variable_global_exists("current_rank")) {
    global.current_rank = "bronze";
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

if (!variable_global_exists("current_rank_display")) {
    global.current_rank_display = "Bronze";
}

if (!variable_global_exists("current_level")) {
    global.current_level = 1;
}

if (!variable_global_exists("last_level_stars")) {
    global.last_level_stars = 0;
}

if (!variable_global_exists("last_completed_level")) {
    global.last_completed_level = 0;
}

if (!variable_global_exists("village_hp")) {
    global.village_hp = 10;
}

// ===== LOAD TROPHIES FROM FILE =====
var trophy_file = "player_trophies.txt";

if (file_exists(trophy_file)) {
    var file = file_text_open_read(trophy_file);
    
    while (!file_text_eof(file)) {
        var line = file_text_read_string(file);
        file_text_readln(file);
        
        if (line != "" && string_length(line) > 0) {
            var data = string_split(line, ",");
            
            if (array_length(data) >= 2 && data[0] == global.logged_in_user) {
                global.player_trophies = real(data[1]);
                show_debug_message("Trophies loaded: " + string(global.player_trophies));
                break;
            }
        }
    }
    
    file_text_close(file);
} else {
    show_debug_message("Trophy file not found, creating default...");
    
    // Create default trophy file
    var file = file_text_open_write(trophy_file);
    file_text_write_string(file, global.logged_in_user + ",0");
    file_text_writeln(file);
    file_text_close(file);
}

// ===== SET ROOM-SPECIFIC RANK =====
global.current_rank = "bronze";
global.current_rank_display = "Bronze";

show_debug_message("Room initialized successfully");
show_debug_message("User: " + string(global.logged_in_user));
show_debug_message("Trophies: " + string(global.player_trophies));
show_debug_message("Rank: " + string(global.current_rank));
show_debug_message("=================================");
