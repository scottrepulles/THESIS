/// @description Load player trophies from file
/// @function scr_load_player_trophies()

function scr_load_player_trophies() {
    
    // Ensure user exists
    if (!variable_global_exists("logged_in_user") || global.logged_in_user == undefined || global.logged_in_user == "") {
        global.logged_in_user = "DefaultUser";
    }
    
    // Initialize global trophy variable
    global.player_trophies = 0;
    
    var trophy_file = "player_trophies.txt";
    
    // Check if trophy file exists
    if (file_exists(trophy_file)) {
        var file = file_text_open_read(trophy_file);
        
        while (!file_text_eof(file)) {
            var line = file_text_read_string(file);
            file_text_readln(file);
            
            if (line != "" && string_length(line) > 0) {
                var data = string_split(line, ",");
                
                if (array_length(data) >= 2 && data[0] == global.logged_in_user) {
                    // Found user's trophy data
                    global.player_trophies = real(data[1]);
                    
                    show_debug_message("=== TROPHIES LOADED ===");
                    show_debug_message("User: " + global.logged_in_user);
                    show_debug_message("Trophies: " + string(global.player_trophies));
                    show_debug_message("=======================");
                    
                    file_text_close(file);
                    return global.player_trophies;
                }
            }
        }
        
        file_text_close(file);
    }
    
    show_debug_message("No trophy data found for user: " + global.logged_in_user);
    show_debug_message("Starting with 0 trophies");
    
    return 0;
}
