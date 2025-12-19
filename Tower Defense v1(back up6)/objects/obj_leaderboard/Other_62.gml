// ===== obj_leaderboard ASYNC HTTP EVENT =====

if (room != rm_leaderboard) {
    exit;
}

if (async_load[? "id"] == request_id) {
    var _status = async_load[? "status"];
    var _result = async_load[? "result"];
    var _http_status = async_load[? "http_status"];
    
    show_debug_message("📡 Response received - Status: " + string(_status) + " | HTTP: " + string(_http_status));
    
    if (_status == 0 && _http_status == 200) {
        try {
            leaderboard_data = json_parse(_result);
            is_loading = false;
            error_message = "";
            refresh_button.rotation = 0; // Reset rotation
            
            calculate_statistics();
            
            show_debug_message("✅ Success! Loaded " + string(array_length(leaderboard_data)) + " entries");
            
            if (current_player_name != "") {
                search_player(current_player_name);
            }
            
            // Success particles
            for (var i = 0; i < 20; i++) {
                create_particle(
                    ui.x + ui.width/2 + random_range(-100, 100),
                    ui.y + ui.title_height
                );
            }
            
        } catch (_error) {
            show_debug_message("❌ JSON Parse Error: " + string(_error));
            error_message = "Failed to parse data";
            is_loading = false;
            refresh_button.rotation = 0;
        }
    } else if (_status == 0 && _http_status == 201) {
        show_debug_message("✅ Score submitted successfully!");
        is_loading = false;
        refresh_button.rotation = 0;
        alarm[0] = 60;
        
    } else {
        show_debug_message("❌ HTTP Error: " + string(_http_status));
        show_debug_message("Response: " + _result);
        error_message = "Error: " + string(_http_status);
        is_loading = false;
        refresh_button.rotation = 0;
    }
}
